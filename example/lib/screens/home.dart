import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/providers.dart';
import '/screens/hello.dart';
import '/screens/settings.dart';
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
    final bool showSearch = ref.watch(searchProvider);
    final bool showBlur = ref.watch(blurProvider);

    final NavigationItem hello = NavigationItem(
      title: Strings.hello,
      icon: Icons.emoji_emotions_outlined,
      selectedIcon: Icons.emoji_emotions,
      headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () => ref.read(counterProvider.state).state++,
        tooltipMessage: Strings.add,
      ),
      builder: (_) => const HelloWorld(),
    );

    final MasterNavigationItem helloMaster = MasterNavigationItem(
      title: Strings.hello,
      leading: const Icon(Icons.emoji_emotions_outlined),
      headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () => ref.read(counterProvider.state).state++,
        tooltipMessage: Strings.add,
      ),
      builder: (_) => const HelloWorld(),
    );

    final NavigationItem widgets = NavigationItem(
      title: Strings.widgets,
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
      headerBarLeading: ArnaIconButton(
        icon: Icons.search_outlined,
        onPressed: () => ref.read(searchProvider.notifier).state = !showSearch,
        tooltipMessage: Strings.search,
      ),
      builder: (_) => const Widgets(),
    );

    final MasterNavigationItem widgetsMaster = MasterNavigationItem(
      title: Strings.widgets,
      leading: const Icon(Icons.widgets_outlined),
      headerBarLeading: ArnaIconButton(
        icon: Icons.search_outlined,
        onPressed: () => ref.read(searchProvider.notifier).state = !showSearch,
        tooltipMessage: Strings.search,
      ),
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

    final Widget dialog = ArnaAlertDialog(
      title: Strings.arna,
      content: Text(
        Strings.description,
        style: ArnaTheme.of(context).textTheme.body,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
      actions: <Widget>[
        ArnaTextButton(
          label: Strings.source,
          onPressed: () async => launchUrl(
            Uri(scheme: 'https', host: 'github.com', path: 'MahanRahmati/Arna'),
          ),
        ),
        ArnaTextButton(
          label: Strings.licenses,
          onPressed: () => showArnaLicensePage(context: context),
        ),
        ArnaTextButton(
          label: Strings.ok,
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );

    final List<Widget> actions = <Widget>[
      ArnaIconButton(
        icon: Icons.info_outlined,
        onPressed: () => showArnaDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => dialog,
          useBlur: showBlur,
        ),
        tooltipMessage: Strings.about,
      ),
      ArnaIconButton(
        icon: Icons.settings_outlined,
        onPressed: () {
          showArnaPopupDialog(
            context: context,
            title: Strings.settings,
            builder: (BuildContext context) => const Settings(),
            useBlur: showBlur,
          );
        },
        tooltipMessage: Strings.settings,
      )
    ];

    const Widget leadingWidget = ArnaLogo(size: Styles.base * 10);

    return ref.watch(masterProvider)
        ? ArnaMasterDetailScaffold(
            title: Strings.appName,
            actions: actions,
            leading: leadingWidget,
            items: <MasterNavigationItem>[helloMaster, widgetsMaster, typographyMaster],
          )
        : ArnaSideScaffold(
            title: Strings.appName,
            actions: actions,
            leading: leadingWidget,
            items: <NavigationItem>[hello, widgets, typography],
          );
  }
}
