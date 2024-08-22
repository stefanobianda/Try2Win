import 'package:flutter/material.dart';
import 'package:try2win/widgets/app_decoration.dart';

class CampaignOptionScreen extends StatefulWidget {
  const CampaignOptionScreen({super.key});

  @override
  State<CampaignOptionScreen> createState() {
    return _CampaignOptionScreenState();
  }
}

class _CampaignOptionScreenState extends State<CampaignOptionScreen> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _renumerationController = TextEditingController();

  final List<double> thresholdList = [100, 250, 500, 1000];
  final List<double> renumerationList = [25, 35, 60, 100];
  int current = 0;

  @override
  void initState() {
    super.initState();
    _renumerationController.text = renumerationList[current].round().toString();
  }

  @override
  void dispose() {
    // Pulisci il controller quando il widget viene eliminato
    _renumerationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppDecoration.build(context),
      padding: const EdgeInsets.all(32),
      child: Form(
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
              label: thresholdList[current].round().toString(),
              value: current.toDouble(),
              onChanged: onChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Text(
                  thresholdList[index].round().toString(),
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
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
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
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 64,
            ),
            ElevatedButton.icon(
              onPressed: _submit,
              label: const Text("Accept"),
            )
          ],
        ),
      ),
    );
  }

  void onChanged(double value) {
    setState(() {
      current = value.toInt();
    });
    _renumerationController.text = renumerationList[current].round().toString();
  }

  void _submit() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
  }
}
