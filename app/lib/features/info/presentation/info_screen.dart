import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(key: Key('info_screen'), child: Text('Thông tin')));
  }
}
