import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/settings/presentation/settings_controller.dart';

const _fontSizeLabels = {
  FontSizeOption.small: 'Nhỏ',
  FontSizeOption.medium: 'Vừa',
  FontSizeOption.large: 'Lớn',
};

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final _keywordController = TextEditingController(
    text: ref.read(settingsControllerProvider).highlightKeyword,
  );

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        key: const Key('settings_screen'),
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('highlight_keyword_field'),
            decoration: const InputDecoration(labelText: 'Từ khóa highlight'),
            controller: _keywordController,
            onSubmitted: controller.setHighlightKeyword,
          ),
          const SizedBox(height: 16),
          const Text('Cỡ chữ nội dung lịch:'),
          RadioGroup<FontSizeOption>(
            groupValue: settings.fontSize,
            onChanged: (value) {
              if (value != null) controller.setFontSize(value);
            },
            child: Column(
              children: FontSizeOption.values
                  .map(
                    (option) => RadioListTile<FontSizeOption>(
                      title: Text(
                        _fontSizeLabels[option]!,
                        style: TextStyle(fontSize: 14 + option.index * 4),
                      ),
                      value: option,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('logout_button'),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
