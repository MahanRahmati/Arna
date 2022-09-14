import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers.dart';
import '/screens/settings.dart';
import '/strings.dart';
import '/widgets/banners.dart';
import '/widgets/buttons.dart';
import '/widgets/checkbox.dart';
import '/widgets/indicators.dart';
import '/widgets/linked_buttons.dart';
import '/widgets/list_tile.dart';
import '/widgets/pickers.dart';
import '/widgets/radios.dart';
import '/widgets/segmented_control.dart';
import '/widgets/sliders.dart';
import '/widgets/switches.dart';
import '/widgets/text_field.dart';

class Widgets extends ConsumerWidget {
  const Widgets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArnaScaffold(
      headerBar: ArnaHeaderBar(
        title: Strings.widgets,
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ArnaBanner(
            showBanner: ref.watch(bannerProvider),
            title: Strings.bannerTitle,
            subtitle: Strings.subtitle,
            actions: <Widget>[
              ArnaCloseButton(
                onPressed: () =>
                    ref.read(bannerProvider.notifier).state = false,
              ),
            ],
          ),
          const Flexible(
            child: SingleChildScrollView(
              child: ArnaList(
                children: <Widget>[
                  Buttons(),
                  LinkedButtons(),
                  SegmentedControl(),
                  CheckBoxs(),
                  Radios(),
                  Switches(),
                  ListTiles(),
                  Sliders(),
                  Indicators(),
                  TextField(),
                  Banners(),
                  Pickers(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
