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
          ArnaList(
            title: "Accent",
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            addBackground: true,
            children: <Widget>[
              ArnaColorButton(
                value: AccentColor.blue,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).blue(),
                color: ArnaColors.accentColor,
              ),
              ArnaColorButton(
                value: AccentColor.green,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).green(),
                color: ArnaColors.successColor,
              ),
              ArnaColorButton(
                value: AccentColor.red,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).red(),
                color: ArnaColors.errorColor,
              ),
              ArnaColorButton(
                value: AccentColor.orange,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).orange(),
                color: ArnaColors.warningColor,
              ),
              ArnaColorButton(
                value: AccentColor.white,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).white(),
                color: ArnaColors.white,
              ),
              ArnaColorButton(
                value: AccentColor.black,
                groupValue: accentColor,
                onPressed: () => ref.read(changeColor.notifier).black(),
                color: ArnaColors.black,
              ),
            ],
          ),
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

enum AccentColor { blue, green, red, orange, white, black }

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

  void white() {
    accent = AccentColor.white;
    notifyListeners();
  }

  void black() {
    accent = AccentColor.black;
    notifyListeners();
  }
}
