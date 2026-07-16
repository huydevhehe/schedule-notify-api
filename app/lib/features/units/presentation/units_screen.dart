import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/units/presentation/units_controller.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);

    if (user == null || user.units.isEmpty) {
      return const Scaffold(body: Center(child: Text('Không có đơn vị nào')));
    }

    return Scaffold(
      appBar: const GradientAppBar(title: 'Đơn vị'),
      body: RadioGroup<int>(
        groupValue: selectedUnitId,
        onChanged: (value) {
          if (value != null) {
            ref.read(selectedUnitIdProvider.notifier).select(value);
          }
        },
        child: ListView(
          key: const Key('units_screen'),
          children: user.units
              .map((unit) => RadioListTile<int>(title: Text(unit.name), value: unit.id))
              .toList(),
        ),
      ),
    );
  }
}
