import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;
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
    final theme = ref.watch(changeTheme);
    final accentColor = ref.watch(changeColor);
    Brightness? brightness;
    Color? accent;

    switch (theme.theme) {
      case Theme.dark:
        brightness = Brightness.dark;
        break;
      case Theme.light:
        brightness = Brightness.light;
        break;
      default:
        brightness = null;
    }

    switch (accentColor.accent) {
      case AccentColor.green:
        accent = ArnaColors.successColor;
        break;
      case AccentColor.red:
        accent = ArnaColors.errorColor;
        break;
      case AccentColor.orange:
        accent = ArnaColors.warningColor;
        break;
      case AccentColor.white:
        accent = ArnaColors.white;
        break;
      case AccentColor.black:
        accent = ArnaColors.black;
        break;
      default:
        accent = ArnaColors.accentColor;
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
  var showSearch = false;
  TextEditingController controller = TextEditingController();
  var showBanner = true;
  String url = "https://github.com/MahanRahmati/Arna";
  bool showMaster = false;

  @override
  Widget build(BuildContext context) {
    NavigationItem hello = NavigationItem(
      title: "Hello World!",
      icon: Icons.emoji_emotions_outlined,
      headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () => ref.read(counterProvider.state).state++,
      ),
      builder: (_) => const HelloWorld(),
    );

    NavigationItem widgets = NavigationItem(
      headerBarLeading: ArnaIconButton(
        icon: Icons.search_outlined,
        onPressed: () => setState(() {
          showSearch = !showSearch;
          controller.text = "";
        }),
      ),
      title: "Widgets",
      icon: Icons.widgets_outlined,
      searchField: ArnaSearchField(
        showSearch: showSearch,
        controller: controller,
      ),
      banner: ArnaBanner(
        showBanner: showBanner,
        title: "This is an information banner!",
        subtitle: "Hello There!",
        trailing: ArnaIconButton(
          icon: Icons.close_outlined,
          hasBorder: false,
          onPressed: () => setState(() => showBanner = false),
        ),
      ),
      builder: (_) => const Widgets(),
    );

    NavigationItem typography = NavigationItem(
      title: "Typography",
      icon: Icons.font_download_outlined,
      builder: (_) => const Typography(),
    );

    return showMaster
        ? ArnaMasterDetailScaffold(
            title: "Arna Demo",
            items: <MasterNavigationItem>[
              MasterNavigationItem(
                title: "Hello World!",
                leading: const Icon(Icons.emoji_emotions_outlined),
                headerBarLeading: ArnaIconButton(
                  icon: Icons.add_outlined,
                  onPressed: () => ref.read(counterProvider.state).state++,
                ),
                builder: (_) => const HelloWorld(),
              ),
              MasterNavigationItem(
                builder: (_) => const Widgets(),
                title: "Widgets",
                leading: const Icon(Icons.widgets_outlined),
                headerBarLeading: ArnaIconButton(
                  icon: Icons.search_outlined,
                  onPressed: () => setState(() {
                    showSearch = !showSearch;
                    controller.text = "";
                  }),
                ),
                searchField: ArnaSearchField(
                  showSearch: showSearch,
                  controller: controller,
                ),
                banner: ArnaBanner(
                  showBanner: showBanner,
                  title: "This is an information banner!",
                  subtitle: "Hello There!",
                  trailing: ArnaIconButton(
                    icon: Icons.close_outlined,
                    hasBorder: false,
                    onPressed: () => setState(() => showBanner = false),
                  ),
                ),
              ),
              MasterNavigationItem(
                title: "Typography",
                leading: const Icon(Icons.font_download_outlined),
                builder: (_) => const Typography(),
              ),
            ],
            headerBarTrailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ArnaIconButton(
                  icon: Icons.info_outlined,
                  onPressed: () => showArnaDialog(
                    context: context,
                    barrierDismissible: true,
                    dialog: ArnaAlertDialog(
                      title: "Arna Framework",
                      message:
                          "A unique set of widgets for building applications with Flutter.",
                      primary: ArnaTextButton(
                        label: "Source code",
                        onPressed: () async => await launch(url),
                      ),
                      secondary: ArnaTextButton(
                        label: "OK",
                        onPressed: Navigator.of(context).pop,
                      ),
                    ),
                  ),
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
                ),
              ],
            ),
            currentIndex: expanded(context) ? 0 : null,
          )
        : ArnaSideScaffold(
            title: "Arna Demo",
            headerBarTrailing: Row(
              children: <Widget>[
                ArnaIconButton(
                  icon: Icons.info_outlined,
                  onPressed: () => showArnaDialog(
                    context: context,
                    barrierDismissible: true,
                    dialog: ArnaAlertDialog(
                      title: "Arna Framework",
                      message:
                          "A unique set of widgets for building applications with Flutter.",
                      primary: ArnaTextButton(
                        label: "Source code",
                        onPressed: () async => await launch(url),
                      ),
                      secondary: ArnaTextButton(
                        label: "OK",
                        onPressed: Navigator.of(context).pop,
                      ),
                    ),
                  ),
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
                ),
              ],
            ),
            items: <NavigationItem>[hello, widgets, typography],
          );
  }
}
