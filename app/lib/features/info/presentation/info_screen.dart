import 'package:flutter/material.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'Thông tin'),
      body: const Padding(
        key: Key('info_screen'),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ứng dụng Lịch họp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Phiên bản 1.0.0'),
            SizedBox(height: 16),
            Text('Ứng dụng thông báo và quản lý lịch họp nội bộ.'),
          ],
        ),
      ),
    );
  }
}
