import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../utils/helpers.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// QR Code Generator Screen for Exhibitor
/// شاشة إنشاء QR Code للعارض
class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final GlobalKey _qrKey = GlobalKey();

  Future<void> _shareQRCode() async {
    try {
      // Capture QR code as image
      final RenderRepaintBoundary? boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        if (mounted) {
          Helpers.showErrorSnackBar(context, 'فشل إنشاء QR Code');
        }
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        if (mounted) {
          Helpers.showErrorSnackBar(context, 'فشل تحويل QR Code إلى صورة');
        }
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(pngBytes);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'QR Code الخاص بي - Smart Card',
      );

      if (mounted) {
        Helpers.showSuccessSnackBar(context, 'تم مشاركة QR Code بنجاح!');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackBar(context, 'فشل مشاركة QR Code: $e');
      }
    }
  }

  Future<void> _saveQRCode() async {
    try {
      // For now, use share functionality to save
      await _shareQRCode();
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackBar(context, 'فشل حفظ QR Code');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final expoId = user?.expoId ?? 'SmartCard#2048';

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code الجناح'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Info Card
              Card(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'عرض هذا QR Code في الجناح الخاص بك. الزوار يمكنهم مسحه للحصول على معلوماتك.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // ExpoID Display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'SmartCardID الخاص بك',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        expoId,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // QR Code
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: expoId,
                    version: QrVersions.auto,
                    size: 250.0,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Instructions
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'كيفية الاستخدام',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionStep(
                        context,
                        '1',
                        'اطبع QR Code أو احفظه كصورة',
                      ),
                      _buildInstructionStep(
                        context,
                        '2',
                        'اعرض QR Code في الجناح الخاص بك',
                      ),
                      _buildInstructionStep(
                        context,
                        '3',
                        'الزوار يمسحون QR Code باستخدام التطبيق',
                      ),
                      _buildInstructionStep(
                        context,
                        '4',
                        'يتم حفظ معلوماتك تلقائياً في قائمة جهات الاتصال',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Actions
              PrimaryButton(
                text: 'مشاركة QR Code',
                icon: Icons.share,
                onPressed: _shareQRCode,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'حفظ QR Code',
                icon: Icons.download,
                onPressed: _saveQRCode,
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'طباعة QR Code',
                icon: Icons.print,
                onPressed: () {
                  Helpers.showSnackBar(
                    context,
                    'يمكنك استخدام زر "مشاركة" ثم اختيار "طباعة"',
                  );
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
    BuildContext context,
    String number,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

