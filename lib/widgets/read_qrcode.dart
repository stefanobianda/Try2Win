import 'package:flutter/material.dart';
import 'package:try2win/qrcode/qrcode_scanner.dart';

class ReadQRCode extends StatefulWidget {
  const ReadQRCode({super.key});

  @override
  State<ReadQRCode> createState() {
    return _ReadQRCodeState();
  }
}

class _ReadQRCodeState extends State<ReadQRCode> {
  String? _result;

  void setResult(String result) {
    setState(() {
      _result = result;
    });
  }

  void _readQRCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrCodeScanner(setResult: setResult),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_result ?? 'No result'),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _readQRCode,
          child: const Text('Read user QR code'),
        ),
      ],
    );
  }
}
