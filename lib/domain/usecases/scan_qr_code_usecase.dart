
import '../entities/qr_code.dart';

class ScanQRCodeUseCase {
  Future<QRCode> execute(String rawCode) async {
    // معالجة الكود وإرجاع كائن QRCode
    return QRCode(content: rawCode, timestamp: DateTime.now());
  }
}