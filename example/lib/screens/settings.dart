import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final accentColor = ref.watch(accentProvider);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ArnaList(
            title: "Theme",
            addDivider: true,
            addBackground: true,
            children: <Widget>[
              ArnaRadioListTile(
                value: Theme.system,
                groupValue: themeMode,
                title: "System",
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.system,
              ),
              ArnaRadioListTile(
                value: Theme.dark,
                groupValue: themeMode,
                title: "Dark",
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.dark,
              ),
              ArnaRadioListTile(
                value: Theme.light,
                groupValue: themeMode,
                title: "Light",
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.light,
              ),
            ],
          ),
          ArnaList(
            title: "Accent",
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            addBackground: true,
            children: <Widget>[
              ArnaColorButton(
                value: AccentColor.blue,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = AccentColor.blue,
                color: ArnaColors.blue,
              ),
              ArnaColorButton(
                value: AccentColor.green,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = AccentColor.green,
                color: ArnaColors.green,
              ),
              ArnaColorButton(
                value: AccentColor.red,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = AccentColor.red,
                color: ArnaColors.red,
              ),
              ArnaColorButton(
                value: AccentColor.orange,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = AccentColor.orange,
                color: ArnaColors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum Theme { system, dark, light }

final themeProvider = StateProvider.autoDispose<Theme>((ref) => Theme.system);

enum AccentColor { blue, green, red, orange }

final accentProvider = StateProvider.autoDispose<AccentColor>((ref) => AccentColor.blue);
