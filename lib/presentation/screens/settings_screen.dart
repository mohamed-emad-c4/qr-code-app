import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإعدادات")),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("الوضع الليلي"),
            value: false, // TODO: ربط مع Cubit لإدارة الوضع الليلي
            onChanged: (value) {
              // TODO: تغيير الوضع الليلي
            },
          ),
          ListTile(
            title: Text("إدارة أذونات الكاميرا"),
            onTap: () {
              // TODO: فتح إعدادات الأذونات
            },
          ),
          ListTile(
            title: Text("مسح السجل"),
            onTap: () {
              // TODO: مسح السجل
            },
          ),
        ],
      ),
    );
  }
}