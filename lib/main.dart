import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/usecases/scan_qr_code_usecase.dart';
import 'presentation/cubits/scan_cubit.dart';
import 'presentation/cubits/screens/scan_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR App',
      home: BlocProvider(
        create: (context) => ScanCubit(ScanQRCodeUseCase()),
        child: ScanScreen(),
      ),
    );
  }
}