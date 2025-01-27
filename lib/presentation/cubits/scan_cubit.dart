import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/qr_code.dart';
import '../../domain/usecases/scan_qr_code_usecase.dart';


part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanQRCodeUseCase scanUseCase;

  ScanCubit(this.scanUseCase) : super(ScanInitial());

  Future<void> scanQRCode(String rawCode) async {
    try {
      emit(ScanLoading());
      final result = await scanUseCase.execute(rawCode);
      emit(ScanSuccess(result));
    } catch (error) {
      emit(ScanError("فشل في مسح الكود"));
    }
  }
}