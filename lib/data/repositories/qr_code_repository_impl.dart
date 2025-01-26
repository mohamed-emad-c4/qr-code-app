import '../../domain/entities/qr_code.dart';
import '../data_sources/local_data_source.dart';

class QRCodeRepositoryImpl {
  final LocalDataSource localDataSource;

  QRCodeRepositoryImpl(this.localDataSource);

  Future<void> saveQRCode(QRCode qrCode) async {
    await localDataSource.saveQRCode(qrCode);
  }

  Future<List<QRCode>> getHistory() async {
    return await localDataSource.getHistory();
  }
}