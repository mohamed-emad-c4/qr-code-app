part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<QRCode> history;

  HistorySuccess(this.history);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}