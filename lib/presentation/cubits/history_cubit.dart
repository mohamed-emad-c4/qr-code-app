import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/qr_code.dart';
import '../../domain/usecases/fetch_history_usecase.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final FetchHistoryUseCase fetchHistoryUseCase;

  HistoryCubit(this.fetchHistoryUseCase) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    try {
      emit(HistoryLoading());
      final history = await fetchHistoryUseCase.execute();
      emit(HistorySuccess(history));
    } catch (error) {
      emit(HistoryError("فشل في تحميل السجل"));
    }
  }
}