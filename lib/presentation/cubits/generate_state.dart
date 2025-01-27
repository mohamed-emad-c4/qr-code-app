part of 'generate_cubit.dart';

abstract class GenerateState {}

class GenerateInitial extends GenerateState {}

class GenerateLoading extends GenerateState {}

class GenerateSuccess extends GenerateState {
  final QRCode qrCode;

  GenerateSuccess(this.qrCode);
}

class GenerateError extends GenerateState {
  final String message;

  GenerateError(this.message);
}