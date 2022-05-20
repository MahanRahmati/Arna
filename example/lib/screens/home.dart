import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/screens/hello.dart';
import '/screens/settings.dart';
import '/screens/typography.dart';
import '/screens/widgets.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Uri url = Uri(scheme: 'https', host: 'github.com', path: 'MahanRahmati/Arna');

  @override
  Widget build(BuildContext context) {
    final NavigationItem hello = NavigationItem(
      title: 'Hello World!',
      icon: Icons.emoji_emotions_outlined,
      selectedIcon: Icons.emoji_emotions,
      headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () => ref.read(counterProvider.state).state++,
        tooltipMessage: 'Add',
      ),
      builder: (_) => const HelloWorld(),
    );

    final NavigationItem widgets = NavigationItem(
      title: 'Widgets',
      icon: Icons.widgets_outlined,
      selectedIcon: Icons.widgets,
      builder: (_) => const Widgets(),
    );

    final NavigationItem typography = NavigationItem(
      title: 'Typography',
      icon: Icons.font_download_outlined,
      selectedIcon: Icons.font_download,
      builder: (_) => const Typography(),
    );

    final Widget dialog = ArnaAlertDialog(
      title: 'Arna Framework',
      content: Text(
        'A unique set of widgets for building applications with Flutter.',
        style: ArnaTheme.of(context).textTheme.body,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        ArnaTextButton(
          label: 'Source code',
          onPressed: () async => launchUrl(url),
        ),
        ArnaTextButton(
          label: 'OK',
          onPressed: Navigator.of(context).pop,
        )
      ],
    );

    return ref.watch(masterProvider)
        ? ArnaMasterDetailScaffold(
            title: 'Arna Demo',
            actions: <Widget>[
              ArnaIconButton(
                icon: Icons.info_outlined,
                onPressed: () => showArnaDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => dialog,
                ),
                tooltipMessage: 'About',
              ),
              ArnaIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  showArnaPopupDialog(
                    context: context,
                    title: 'Settings',
                    builder: (BuildContext context) => const Settings(),
                  );
                },
                tooltipMessage: 'Settings',
              ),
            ],
            leading: const Padding(
              padding: Styles.normal,
              child: FlutterLogo(size: Styles.base * 5),
            ),
            items: <MasterNavigationItem>[
              MasterNavigationItem(
                title: 'Hello World!',
                leading: const Icon(Icons.emoji_emotions_outlined),
                headerBarLeading: ArnaIconButton(
                  icon: Icons.add_outlined,
                  onPressed: () => ref.read(counterProvider.state).state++,
                  tooltipMessage: 'Add',
                ),
                builder: (_) => const HelloWorld(),
              ),
              MasterNavigationItem(
                builder: (_) => const Widgets(),
                title: 'Widgets',
                leading: const Icon(Icons.widgets_outlined),
              ),
              MasterNavigationItem(
                title: 'Typography',
                leading: const Icon(Icons.font_download_outlined),
                builder: (_) => const Typography(),
              ),
            ],
          )
        : ArnaSideScaffold(
            title: 'Arna Demo',
            actions: <Widget>[
              ArnaIconButton(
                icon: Icons.info_outlined,
                onPressed: () => showArnaDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => dialog,
                ),
                tooltipMessage: 'About',
              ),
              ArnaIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {
                  showArnaPopupDialog(
                    context: context,
                    title: 'Settings',
                    builder: (BuildContext context) => const Settings(),
                  );
                },
                tooltipMessage: 'Settings',
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
