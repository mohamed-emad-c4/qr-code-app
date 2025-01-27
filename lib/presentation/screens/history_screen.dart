import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سجل الأكواد")),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistorySuccess) {
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final qrCode = state.history[index];
                return ListTile(
                  title: Text(qrCode.content),
                  subtitle: Text(qrCode.timestamp.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // TODO: إضافة وظيفة الحذف
                    },
                  ),
                );
              },
            );
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("لا يوجد بيانات"));
        },
      ),
    );
  }
}