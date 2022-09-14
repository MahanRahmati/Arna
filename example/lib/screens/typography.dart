import 'package:arna/arna.dart';

import '/screens/settings.dart';
import '/strings.dart';

class Typography extends StatelessWidget {
  const Typography({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaScaffold(
      headerBar: ArnaHeaderBar(
        title: Strings.typography,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: Styles.normal,
          child: SizedBox(
            width: ArnaHelpers.deviceWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.display,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.headline,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.title,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.body,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.button,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.subtitle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    Strings.lorem,
                    style: ArnaTheme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
