import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Theme? themeMode = ref.watch(changeTheme).theme;
    AccentColor? accentColor = ref.watch(changeColor).accent;
    return SingleChildScrollView(
      child: Column(
        children: [
          ArnaGroupedView(
            title: "Theme",
            children: [
              ArnaRadioListTile(
                value: Theme.system,
                groupValue: themeMode,
                title: "System",
                onChanged: (_) => ref.read(changeTheme.notifier).system(),
              ),
              ArnaRadioListTile(
                value: Theme.dark,
                groupValue: themeMode,
                title: "Dark",
                onChanged: (_) => ref.read(changeTheme.notifier).dark(),
              ),
              ArnaRadioListTile(
                value: Theme.light,
                groupValue: themeMode,
                title: "Light",
                onChanged: (_) => ref.read(changeTheme.notifier).light(),
              ),
            ],
          ),
          ArnaGroupedView(
            title: "Accent Color",
            children: [
              ArnaRadioListTile(
                value: AccentColor.blue,
                groupValue: accentColor,
                title: "Blue",
                onChanged: (_) => ref.read(changeColor.notifier).blue(),
              ),
              ArnaRadioListTile(
                value: AccentColor.green,
                groupValue: accentColor,
                title: "Green",
                onChanged: (_) => ref.read(changeColor.notifier).green(),
              ),
              ArnaRadioListTile(
                value: AccentColor.red,
                groupValue: accentColor,
                title: "Red",
                onChanged: (_) => ref.read(changeColor.notifier).red(),
              ),
              ArnaRadioListTile(
                value: AccentColor.orange,
                groupValue: accentColor,
                title: "Orange",
                onChanged: (_) => ref.read(changeColor.notifier).orange(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum Theme { system, dark, light }

final changeTheme = ChangeNotifierProvider.autoDispose(
  (ref) => ChangeThemeState(),
);

class ChangeThemeState extends ChangeNotifier {
  Theme? theme = Theme.system;

  void system() {
    theme = Theme.system;
    notifyListeners();
  }

  void dark() {
    theme = Theme.dark;
    notifyListeners();
  }

  void light() {
    theme = Theme.light;
    notifyListeners();
  }
}

enum AccentColor { blue, green, red, orange }

final changeColor = ChangeNotifierProvider.autoDispose(
  (ref) => ChangeColorState(),
);

class ChangeColorState extends ChangeNotifier {
  AccentColor? accent = AccentColor.blue;

  void blue() {
    accent = AccentColor.blue;
    notifyListeners();
  }

  void green() {
    accent = AccentColor.green;
    notifyListeners();
  }

  void red() {
    accent = AccentColor.red;
    notifyListeners();
  }

  void orange() {
    accent = AccentColor.orange;
    notifyListeners();
  }
}
