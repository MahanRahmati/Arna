import 'package:arna/arna.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays an [ArnaAboutDialog], which describes the application and provides a button to show licenses for software
/// used by the application.
///
/// The arguments correspond to the properties on [ArnaAboutDialog].
///
/// The licenses shown on the [ArnaLicensePage] are those returned by the [LicenseRegistry] API, which can be used to
/// add more licenses to the list.
///
/// The [context], [useRootNavigator], [routeSettings] and [anchorPoint] arguments are passed to [showArnaDialog], the
/// documentation for which discusses how it is used.
void showArnaAboutDialog({
  required BuildContext context,
  Widget? applicationIcon,
  String? applicationName,
  String? developerName,
  String? applicationVersion,
  Uri? applicationUri,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  showArnaPopupDialog<void>(
    context: context,
    title: 'About',
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return ArnaAboutDialog(
        applicationIcon: applicationIcon,
        applicationName: applicationName,
        developerName: developerName,
        applicationVersion: applicationVersion,
        applicationUri: applicationUri,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

/// An about box. This is a dialog box with the application's icon, name, version number, and copyright, plus a button
/// to show licenses for software used by the application.
///
/// To show an [ArnaAboutDialog], use [showArnaAboutDialog].
///
/// The [ArnaAboutDialog] shown by [showArnaAboutDialog] includes a button that calls [showArnaLicensePage].
///
/// The licenses shown on the [ArnaLicensePage] are those returned by the [LicenseRegistry] API, which can be used to
/// add more licenses to the list.
class ArnaAboutDialog extends StatelessWidget {
  /// Creates an about box.
  const ArnaAboutDialog({
    super.key,
    this.applicationIcon,
    this.applicationName,
    this.developerName,
    this.applicationVersion,
    this.applicationUri,
  });

  /// The icon of the application.
  final Widget? applicationIcon;

  /// The name of the application.
  final String? applicationName;

  /// The name of the application's developer.
  final String? developerName;

  /// The version of this build of the application.
  final String? applicationVersion;

  /// The uri of the application.
  final Uri? applicationUri;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (applicationIcon != null) applicationIcon!,
        if (applicationName != null) ...<Widget>[
          const SizedBox(height: Styles.padding),
          Text(applicationName!, style: ArnaTheme.of(context).textTheme.display),
          const SizedBox(height: Styles.padding),
        ],
        if (developerName != null) ...<Widget>[
          const SizedBox(height: Styles.padding),
          Text(developerName!, style: ArnaTheme.of(context).textTheme.body),
          const SizedBox(height: Styles.padding),
        ],
        if (applicationVersion != null) ArnaBadge(label: applicationVersion!),
        ArnaList(
          showDividers: true,
          showBackground: true,
          children: <Widget>[
            if (applicationUri != null)
              ArnaListTile(
                title: 'Report an Issue',
                trailing: Padding(
                  padding: Styles.horizontal,
                  child: Icon(
                    Icons.launch_outlined,
                    size: Styles.iconSize,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                ),
                onTap: () async => launchUrl(
                  applicationUri!,
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ArnaListTile(
              title: 'Licenses',
              trailing: Padding(
                padding: Styles.horizontal,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: Styles.iconSize,
                  color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                ),
              ),
              onTap: () => showArnaLicensePage(context: context),
            ),
          ],
        ),
      ],
    );
  }
}
