import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/usecases/fetch_history_usecase.dart';
import 'domain/usecases/generate_qr_code_usecase.dart';
import 'domain/usecases/scan_qr_code_usecase.dart';
import 'presentation/cubits/generate_cubit.dart';
import 'presentation/cubits/history_cubit.dart';
import 'presentation/cubits/scan_cubit.dart';
import 'presentation/screens/generate_screen.dart';
import 'presentation/screens/history_screen.dart';
import 'presentation/screens/scan_screen.dart';
import 'presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScanCubit(ScanQRCodeUseCase()),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(FetchHistoryUseCase()),
        ),
        BlocProvider(
          create: (context) => GenerateCubit(GenerateQRCodeUseCase()),
        ),
      ],
      child: MaterialApp(
        title: 'QR App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => ScanScreen()),
                );
              },
              child: Text("مسح QR Code"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenerateScreen()),
                );
              },
              child: Text("توليد QR Code"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text("سجل الأكواد"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Text("الإعدادات"),
            ),
          ],
        ),
      ),
    );
  }
}