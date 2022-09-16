import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers.dart';
import '/screens/hello.dart';
import '/screens/settings.dart';
import '/screens/tabs.dart';
import '/screens/typography.dart';
import '/screens/widgets.dart';
import '/strings.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    // final bool showSearch = ref.watch(searchProvider);

    final NavigationItem hello = NavigationItem(
      title: Strings.hello,
      icon: Icons.emoji_emotions_outlined,
      selectedIcon: Icons.emoji_emotions,
      builder: (_) => const HelloWorld(),
    );

    final MasterNavigationItem helloMaster = MasterNavigationItem(
      title: Strings.hello,
      leading: const Icon(Icons.emoji_emotions_outlined),
      builder: (_) => const HelloWorld(),
    );

    final NavigationItem widgets = NavigationItem(
      title: Strings.widgets,
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
      // headerBarLeading: ArnaButton.icon(
      //   icon: Icons.search_outlined,
      //   onPressed: () => ref.read(searchProvider.notifier).state = !showSearch,
      //   tooltipMessage: Strings.search,
      // ),
      builder: (_) => const Widgets(),
    );

    final MasterNavigationItem widgetsMaster = MasterNavigationItem(
      title: Strings.widgets,
      leading: const Icon(Icons.widgets_outlined),
      // headerBarLeading: ArnaButton.icon(
      //   icon: Icons.search_outlined,
      //   onPressed: () => ref.read(searchProvider.notifier).state = !showSearch,
      //   tooltipMessage: Strings.search,
      // ),
      builder: (_) => const Widgets(),
    );

    final NavigationItem typography = NavigationItem(
      title: Strings.typography,
      icon: Icons.font_download_outlined,
      selectedIcon: Icons.font_download,
      builder: (_) => const Typography(),
    );

    final MasterNavigationItem typographyMaster = MasterNavigationItem(
      title: Strings.typography,
      leading: const Icon(Icons.font_download_outlined),
      builder: (_) => const Typography(),
    );

    final NavigationItem tabs = NavigationItem(
      title: Strings.tabs,
      icon: Icons.tab_outlined,
      selectedIcon: Icons.tab,
      builder: (_) => const Tabs(),
    );

    final MasterNavigationItem tabsMaster = MasterNavigationItem(
      title: Strings.tabs,
      leading: const Icon(Icons.tab_outlined),
      builder: (_) => const Tabs(),
    );

    final List<ArnaHeaderBarItem> actions = <ArnaHeaderBarItem>[
      ArnaHeaderBarButton(
        icon: Icons.info_outlined,
        label: Strings.about,
        onPressed: () => showArnaAboutDialog(
          context: context,
          applicationIcon: const ArnaLogo(size: Styles.base * 30),
          applicationName: Strings.appName,
          developerName: 'Mahan Rahmati',
          applicationVersion: Strings.version,
          applicationUri: Uri(
            scheme: 'https',
            host: 'github.com',
            path: 'MahanRahmati/Arna/issues',
          ),
        ),
      ),
      ArnaHeaderBarButton(
        icon: Icons.settings_outlined,
        label: Strings.settings,
        onPressed: () => showArnaPopupDialog(
          context: context,
          title: Strings.settings,
          builder: (BuildContext context) => const Settings(),
        ),
      ),
    ];

    const Widget leadingWidget = ArnaLogo(size: Styles.base * 10);

    return ref.watch(masterProvider)
        ? ArnaMasterDetailScaffold(
            title: Strings.appName,
            actions: actions,
            leading: leadingWidget,
            items: <MasterNavigationItem>[
              helloMaster,
              widgetsMaster,
              typographyMaster,
              tabsMaster,
            ],
          )
        : ArnaSideScaffold(
            title: Strings.appName,
            actions: actions,
            leading: leadingWidget,
            items: <NavigationItem>[
              hello,
              widgets,
              typography,
              tabs,
            ],
          );
  }
}
