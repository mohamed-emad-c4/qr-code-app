import '../../domain/entities/qr_code.dart';

abstract class LocalDataSource {
  Future<void> saveQRCode(QRCode qrCode);
  Future<List<QRCode>> getHistory();
}