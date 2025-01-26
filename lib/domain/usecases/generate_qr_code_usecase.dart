import '../entities/qr_code.dart';

class GenerateQRCodeUseCase {
  Future<QRCode> execute(String input) async {
    // توليد الكود وإرجاع كائن QRCode
    return QRCode(content: input, timestamp: DateTime.now(), isScanned: false);
  }
}