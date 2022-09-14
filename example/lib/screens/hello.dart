import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/settings.dart';
import '/strings.dart';

final StateProvider<int> counterProvider =
    StateProvider<int>((StateProviderRef<int> ref) => 0);

class HelloWorld extends ConsumerWidget {
  const HelloWorld({super.key});

  void add(WidgetRef ref) => ref.read(counterProvider.state).state++;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArnaScaffold(
      headerBar: ArnaHeaderBar(
        title: Strings.hello,
        leading: ArnaButton.icon(
          icon: Icons.add_outlined,
          buttonType: ButtonType.borderless,
          onPressed: () => ref.read(counterProvider.state).state++,
          tooltipMessage: Strings.add,
        ),
        actions: <ArnaHeaderBarItem>[
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
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.buttonPushed,
              style: ArnaTheme.of(context).textTheme.body,
            ),
            const SizedBox(height: Styles.padding),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, _) => Text(
                '${ref.watch(counterProvider.state).state}',
                style: ArnaTheme.of(context).textTheme.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
