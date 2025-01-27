import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../cubits/generate_cubit.dart';
import 'dart:ui' as ui;
import 'dart:io';

class GenerateScreen extends StatefulWidget {
  GenerateScreen({Key? key}) : super(key: key);

  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _inputController = TextEditingController();
  String? _lastGeneratedFilePath;

  // توليد QR Code مع خلفية بيضاء، اسم التطبيق، وأيقونة
  Future<String?> _generateQRCodeWithBackground(String data) async {
    try {
      // إنشاء QR Code
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
      );

      // إعداد حجم الصورة
      final qrImage = await qrPainter.toImage(300);
      final qrByteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
      final qrBytes = qrByteData?.buffer.asUint8List();

      if (qrBytes != null) {
        // إنشاء صورة جديدة مع خلفية بيضاء وكتابة النص
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(
          recorder,
          Rect.fromLTWH(0, 0, 400, 500), // حجم الصورة الجديدة
        );

        // رسم الخلفية البيضاء
        final paint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, 400, 500), paint);

        // رسم QR Code في المنتصف
        final image = await decodeImageFromList(qrBytes);
        canvas.drawImage(image, Offset(50, 50), Paint());

        // تحميل الأيقونة
        final ByteData iconData = await rootBundle.load('assets/image.png'); // تأكد من وجود الصورة هنا
        final Uint8List iconBytes = iconData.buffer.asUint8List();
        final iconImage = await decodeImageFromList(iconBytes);

        // رسم الأيقونة بحجم صغير
        const iconSize = 30.0; // حجم الأيقونة
        final iconRect = Rect.fromLTWH(130, 390, iconSize, iconSize); // موقع الأيقونة وحجمها
        canvas.drawImageRect(
          iconImage,
          Rect.fromLTWH(0, 0, iconImage.width.toDouble(), iconImage.height.toDouble()),
          iconRect,
          Paint(),
        );

        // كتابة النص بجانب الأيقونة
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'QR Code Scanner\nand Generator',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: 0, maxWidth: 200);
        textPainter.paint(canvas, Offset(170, 390)); // رسم النص بجانب الأيقونة

        // إنهاء الرسم
        final picture = recorder.endRecording();
        final finalImage = await picture.toImage(400, 500); // حجم الصورة النهائية
        final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
        final finalBytes = byteData?.buffer.asUint8List();

        // حفظ الصورة في ملف
        if (finalBytes != null) {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/qr_code_with_background.png';
          final file = File(filePath);
          await file.writeAsBytes(finalBytes);
          return filePath; // إرجاع مسار الملف
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء توليد QR Code: $e")),
      );
    }
    return null;
  }

  // حفظ الصورة في المعرض
  Future<void> _saveToGallery() async {
    if (_lastGeneratedFilePath != null) {
      final result = await GallerySaver.saveImage(_lastGeneratedFilePath!);
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم حفظ الصورة بنجاح")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في حفظ الصورة")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى توليد QR Code أولاً")),
      );
    }
  }

  // مشاركة الصورة
  Future<void> _shareImage() async {
    if (_lastGeneratedFilePath != null) {
      await Share.shareXFiles([_lastGeneratedFilePath!], text: "QR Code تم توليده بواسطة التطبيق");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى توليد QR Code أولاً")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("توليد QR Code")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: "أدخل النص أو الرابط",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<GenerateCubit, GenerateState>(
              builder: (context, state) {
                if (state is GenerateLoading) {
                  return CircularProgressIndicator();
                } else if (state is GenerateSuccess) {
                  return Column(
                    children: [
                      QrImageView(
                        data: state.qrCode.content,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _saveToGallery,
                            child: Text("حفظ الصورة"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _shareImage,
                            child: Text("مشاركة الصورة"),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is GenerateError) {
                  return Text(state.message);
                }
                return Container();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final input = _inputController.text;
                if (input.isNotEmpty) {
                  // توليد QR Code وحفظ المسار
                  final filePath = await _generateQRCodeWithBackground(input);
                  if (filePath != null) {
                    setState(() {
                      _lastGeneratedFilePath = filePath;
                    });
                  }
                }
              },
              child: Text("توليد QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
