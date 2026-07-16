import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/widgets/gradient_app_bar.dart';
import 'package:app/features/auth/presentation/auth_controller.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/settings/presentation/settings_controller.dart';

const _fontSizeLabels = {
  FontSizeOption.small: 'Nhỏ',
  FontSizeOption.medium: 'Vừa',
  FontSizeOption.large: 'Lớn',
};

const _themeModeLabels = {
  ThemeMode.light: 'Sáng',
  ThemeMode.dark: 'Tối',
  ThemeMode.system: 'Theo hệ thống',
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
      appBar: const GradientAppBar(title: 'Cài đặt'),
      body: ListView(
        key: const Key('settings_screen'),
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsCard(
            title: 'Từ khóa highlight',
            children: [
              TextField(
                key: const Key('highlight_keyword_field'),
                decoration: const InputDecoration(
                  hintText: 'VD: quan trọng, gấp...',
                  helperText: 'Từ trùng sẽ được tô màu trong nội dung lịch',
                ),
                controller: _keywordController,
                onChanged: controller.setHighlightKeyword,
              ),
            ],
          ),
          _SettingsCard(
            title: 'Cỡ chữ nội dung lịch',
            children: [
              Slider(
                key: const Key('font_size_slider'),
                value: settings.fontSize.index.toDouble(),
                min: 0,
                max: (FontSizeOption.values.length - 1).toDouble(),
                divisions: FontSizeOption.values.length - 1,
                label: _fontSizeLabels[settings.fontSize],
                onChanged: (value) =>
                    controller.setFontSize(FontSizeOption.values[value.round()]),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nhỏ'),
                    Text('Vừa'),
                    Text('Lớn'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Chữ mẫu xem trước cỡ chữ',
                  style: TextStyle(fontSize: 14 + settings.fontSize.index * 4),
                ),
              ),
            ],
          ),
          _SettingsCard(
            title: 'Hiển thị',
            children: [
              SwitchListTile(
                key: const Key('show_created_date_switch'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Hiện ngày tạo lịch'),
                subtitle: const Text('Hiển thị ngày tạo ở cuối mỗi cuộc họp'),
                value: settings.showCreatedDate,
                onChanged: controller.setShowCreatedDate,
              ),
            ],
          ),
          _SettingsCard(
            title: 'Giao diện',
            children: [
              RadioGroup<ThemeMode>(
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) controller.setThemeMode(value);
                },
                child: Column(
                  children: ThemeMode.values
                      .map(
                        (mode) => RadioListTile<ThemeMode>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_themeModeLabels[mode]!),
                          value: mode,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const Key('logout_button'),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
