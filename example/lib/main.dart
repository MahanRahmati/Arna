import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/hello.dart';
import '/screens/settings.dart';
import '/screens/typography.dart';
import '/screens/widgets.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final accentColor = ref.watch(accentProvider);
    Brightness? brightness;
    Color? accent;

    switch (theme) {
      case Theme.dark:
        brightness = Brightness.dark;
        break;
      case Theme.light:
        brightness = Brightness.light;
        break;
      default:
        brightness = null;
    }

    switch (accentColor) {
      case AccentColor.green:
        accent = ArnaColors.green;
        break;
      case AccentColor.red:
        accent = ArnaColors.red;
        break;
      case AccentColor.orange:
        accent = ArnaColors.orange;
        break;
      default:
        accent = ArnaColors.blue;
    }

    return ArnaApp(
      debugShowCheckedModeBanner: false,
      theme: ArnaThemeData(
        brightness: brightness,
        accentColor: accent,
      ),
      home: const Home(),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Uri url = Uri(scheme: 'https', host: 'github.com', path: 'MahanRahmati/Arna');
  bool showMaster = false;

  @override
  Widget build(BuildContext context) {
    NavigationItem hello = NavigationItem(
      title: "Hello World!",
      icon: Icons.emoji_emotions_outlined,
      selectedIcon: Icons.emoji_emotions,
      headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () => ref.read(counterProvider.state).state++,
        tooltipMessage: "Add",
      ),
      builder: (_) => const HelloWorld(),
    );

    NavigationItem widgets = NavigationItem(
      title: "Widgets",
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
      builder: (_) => const Widgets(),
    );

    NavigationItem typography = NavigationItem(
      title: "Typography",
      icon: Icons.font_download_outlined,
      selectedIcon: Icons.font_download,
      builder: (_) => const Typography(),
    );

    return showMaster
        ? ArnaMasterDetailScaffold(
            title: "Arna Demo",
            actions: <Widget>[
              ArnaIconButton(
                icon: Icons.info_outlined,
                onPressed: () => showArnaDialog(
                  context: context,
                  barrierDismissible: true,
                  dialog: ArnaAlertDialog(
                    title: "Arna Framework",
                    message: "A unique set of widgets for building applications with Flutter.",
                    primary: ArnaTextButton(
                      label: "Source code",
                      onPressed: () async => await launchUrl(url),
                    ),
                    secondary: ArnaTextButton(
                      label: "OK",
                      onPressed: Navigator.of(context).pop,
                    ),
                  ),
                ),
                tooltipMessage: "About",
              ),
              ArnaIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  showArnaPopupDialog(
                    context: context,
                    title: "Settings",
                    body: const Settings(),
                  );
                },
                tooltipMessage: "Settings",
              ),
            ],
            leading: const Padding(
              padding: Styles.normal,
              child: FlutterLogo(size: Styles.base * 5),
            ),
            items: <MasterNavigationItem>[
              MasterNavigationItem(
                title: "Hello World!",
                leading: const Icon(Icons.emoji_emotions_outlined),
                headerBarLeading: ArnaIconButton(
                  icon: Icons.add_outlined,
                  onPressed: () => ref.read(counterProvider.state).state++,
                  tooltipMessage: "Add",
                ),
                builder: (_) => const HelloWorld(),
              ),
              MasterNavigationItem(
                builder: (_) => const Widgets(),
                title: "Widgets",
                leading: const Icon(Icons.widgets_outlined),
              ),
              MasterNavigationItem(
                title: "Typography",
                leading: const Icon(Icons.font_download_outlined),
                builder: (_) => const Typography(),
              ),
            ],
          )
        : ArnaSideScaffold(
            title: "Arna Demo",
            actions: <Widget>[
              ArnaIconButton(
                icon: Icons.info_outlined,
                onPressed: () => showArnaDialog(
                  context: context,
                  barrierDismissible: true,
                  dialog: ArnaAlertDialog(
                    title: "Arna Framework",
                    message: "A unique set of widgets for building applications with Flutter.",
                    primary: ArnaTextButton(
                      label: "Source code",
                      onPressed: () async => await launchUrl(url),
                    ),
                    secondary: ArnaTextButton(
                      label: "OK",
                      onPressed: Navigator.of(context).pop,
                    ),
                  ),
                ),
                tooltipMessage: "About",
              ),
              ArnaIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  showArnaPopupDialog(
                    context: context,
                    title: "Settings",
                    body: const Settings(),
                  );
                },
                tooltipMessage: "Settings",
              ),
            ],
            leading: const Padding(
              padding: Styles.normal,
              child: FlutterLogo(size: Styles.base * 5),
            ),
            items: <NavigationItem>[hello, widgets, typography],
          );
  }
}
