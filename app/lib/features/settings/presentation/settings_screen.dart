import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(key: Key('settings_screen'), child: Text('Cài đặt')));
  }
}
