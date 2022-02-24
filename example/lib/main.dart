import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/hello.dart';
import '/screens/indicators.dart';
import '/screens/settings.dart';
import '/screens/typography.dart';
import '/screens/widgets.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(changeTheme);
    Brightness? brightness;

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

    return ArnaApp(
      debugShowCheckedModeBanner: false,
      theme: ArnaThemeData(brightness: brightness),
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
        message: "Hello There!",
        trailing: ArnaIconButton(
          icon: Icons.close_outlined,
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

    NavigationItem indicators = NavigationItem(
      title: "Indicators",
      icon: Icons.refresh_outlined,
      builder: (_) => const Indicators(),
    );

    return showMaster
        ? ArnaMasterDetailScaffold(
            items: [
              MasterNavigationItem(
                builder: (context) => Container(),
                title: "Title",
                subtitle: "Subtitle",
              ),
            ],
            currentIndex: 0,
            emptyBody: Container(),
          )
        : ArnaSideScaffold(
            title: "Arna Demo",
            headerBarTrailing: Row(
              children: [
                ArnaIconButton(
                  icon: Icons.info_outlined,
                  onPressed: () => showArnaDialog(
                    context: context,
                    barrierDismissible: true,
                    dialog: ArnaAlertDialog(
                      title: "Arna Framework",
                      message:
                          "A unique set of widgets for building applications with Flutter",
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
            items: [
              hello,
              widgets,
              typography,
              indicators,
            ],
          );
  }
}
