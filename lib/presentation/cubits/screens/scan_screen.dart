import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scan_cubit.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مسح QR")),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          if (state is ScanLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ScanSuccess) {
            return Center(child: Text("تم مسح الكود: ${state.qrCode.content}"));
          } else if (state is ScanError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("اضغط لبدء المسح"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: تنفيذ مسح الكود
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}