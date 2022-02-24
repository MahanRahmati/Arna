import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Theme? themeMode = ref.watch(changeTheme).theme;
    return ArnaList(
      title: "Theme mode",
      items: [
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
    );
  }
}

enum Theme { system, dark, light }

final changeTheme =
    ChangeNotifierProvider.autoDispose((ref) => ChangeThemeState());

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
