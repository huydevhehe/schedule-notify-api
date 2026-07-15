import 'package:flutter/material.dart';
import 'package:app/features/meetings/presentation/meetings_list_screen.dart';
import 'package:app/features/units/presentation/units_screen.dart';
import 'package:app/features/settings/presentation/settings_screen.dart';
import 'package:app/features/info/presentation/info_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [
    MeetingsListScreen(),
    UnitsScreen(),
    SettingsScreen(),
    InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Lịch họp'),
          NavigationDestination(icon: Icon(Icons.apartment), label: 'Đơn vị'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Cài đặt'),
          NavigationDestination(icon: Icon(Icons.info), label: 'Thông tin'),
        ],
      ),
    );
  }
}
