import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../models/contact_model.dart';
import '../../services/mock_api_service.dart';
import '../../utils/helpers.dart';
import 'contact_card_screen.dart';

/// Scan Screen
/// شاشة مسح QR Code
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = false;
  String? _scannedCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning && capture.barcodes.isNotEmpty) {
      setState(() {
        _isScanning = true;
        _scannedCode = capture.barcodes.first.rawValue;
      });

      // Stop scanning
      _controller.stop();

      // Show result
      _showScanResult(_scannedCode!);
    }
  }

  Future<void> _showScanResult(String code) async {
    // Validate SmartCardID format
    if (!Helpers.isValidExpoId(code)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code غير صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      _resetScan();
      return;
    }

    // Get contact from API
    final apiService = MockApiService();
    final contacts = await apiService.getContacts();
    final contact = contacts.firstWhere(
      (c) => c.expoId == code,
      orElse: () => ContactModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'عارض',
        expoId: code,
        scannedAt: DateTime.now(),
      ),
    );

    if (!mounted) return;

    // Navigate to contact card screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ContactCardScreen(contact: contact),
      ),
    );
  }

  void _resetScan() {
    setState(() {
      _isScanning = false;
      _scannedCode = null;
    });
    _controller.start();
  }

  Future<void> _simulateScan() async {
    // Simulate scanning for demo
    await _showScanResult('SmartCard#2048');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مسح QR Code'),
      ),
      body: Column(
        children: [
          // Scanner view
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
                // Overlay
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(40),
                ),
                // Instructions
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ضع QR code داخل الإطار',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                PrimaryButton(
                  text: 'محاكاة المسح (للتجربة)',
                  icon: Icons.qr_code_scanner,
                  onPressed: _simulateScan,
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  text: 'إلغاء',
                  onPressed: () => Navigator.of(context).pop(),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

