import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/models/quota.dart';

class NewCampaignOption extends StatefulWidget {
  const NewCampaignOption({super.key});

  @override
  State<NewCampaignOption> createState() {
    return _NewCampaignOptionState();
  }
}

class _NewCampaignOptionState extends State<NewCampaignOption> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _renumerationController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  final List<int> thresholdList = [100, 250, 500, 1000];
  final List<int> renumerationList = [25, 35, 60, 100];
  int current = 0;

  String? _value;
  bool _isButtonEnabled = false;

  late Quota readQuota;
  bool initDone = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    readQuota = await AppFirestore().getSellerCampaignQuota();
    setState(() {
      current = thresholdList.indexOf(readQuota.quota);
      initDone = true;
    });
    _renumerationController.text = renumerationList[current].toString();
    _valueController.text = readQuota.value.toString();
    _value = readQuota.value.toString();
  }

  @override
  void dispose() {
    // Pulisci il controller quando il widget viene eliminato
    _renumerationController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initDone) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text("Choose your threshold value"),
          const SizedBox(
            height: 8,
          ),
          Slider(
            min: 0,
            max: (thresholdList.length - 1).toDouble(),
            divisions: thresholdList.length - 1,
            label: thresholdList[current].toString(),
            value: current.toDouble(),
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return Text(
                thresholdList[index].toString(),
                style: const TextStyle(fontSize: 16),
              );
            }),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Cost for the selected threshold:"),
              const SizedBox(
                width: 32,
              ),
              Expanded(
                child: TextField(
                  controller: _renumerationController,
                  enabled: false,
                  decoration: const InputDecoration(
                    fillColor: Colors.red,
                    filled: true,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Text("Enter the value of the coupons:"),
              const SizedBox(
                width: 32,
              ),
              Expanded(
                child: TextFormField(
                  controller: _valueController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    fillColor: Colors.red,
                    filled: true,
                    hintText: "min 20",
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return "Only integer";
                    }
                    if (int.parse(value) < 20) {
                      return "Min is 20";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _value = value;
                    setState(() {
                      _isButtonEnabled = checkIsButtonEnabled();
                    });
                  },
                  onSaved: (value) {
                    _value = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 64,
          ),
          ElevatedButton.icon(
            onPressed: _isButtonEnabled ? _submit : null,
            label: const Text("Accept"),
          )
        ],
      ),
    );
  }

  void onChanged(double value) {
    setState(() {
      current = value.toInt();
      _isButtonEnabled = checkIsButtonEnabled();
    });
    _renumerationController.text = renumerationList[current].round().toString();
  }

  void _submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isButtonEnabled = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setting saved!')),
    );
    Quota quota = Quota(
      quota: thresholdList[current],
      renumeration: renumerationList[current],
      value: int.parse(_value!),
      createdAt: Timestamp.now(),
    );
    AppFirestore().setQuota(quota);
  }

  bool checkIsButtonEnabled() {
    bool enabled = false;
    if ((thresholdList[current] != readQuota.quota) ||
        (readQuota.value.toString() != _value)) {
      enabled = true;
    }
    return enabled;
  }
}
