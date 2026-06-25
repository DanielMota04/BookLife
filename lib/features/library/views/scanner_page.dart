import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _barcodeEncontrado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear ISBN'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (_barcodeEncontrado) return;
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              setState(() {
                _barcodeEncontrado = true;
              });
              Navigator.pop(context, barcode.rawValue);
              break;
            }
          }
        },
      ),
    );
  }
}
