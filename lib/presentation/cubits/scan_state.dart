part of 'scan_cubit.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final QRCode qrCode;

  ScanSuccess(this.qrCode);
}

class ScanError extends ScanState {
  final String message;

  ScanError(this.message);
}