import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/qr_code.dart';
import '../../domain/usecases/generate_qr_code_usecase.dart';

part 'generate_state.dart';

class GenerateCubit extends Cubit<GenerateState> {
  final GenerateQRCodeUseCase generateUseCase;

  GenerateCubit(this.generateUseCase) : super(GenerateInitial());

  Future<void> generateQRCode(String input) async {
    try {
      emit(GenerateLoading());
      final qrCode = await generateUseCase.execute(input);
      emit(GenerateSuccess(qrCode));
    } catch (error) {
      emit(GenerateError("فشل في توليد الكود"));
    }
  }
}