import 'package:arna/arna.dart';

/// Banner types.
enum BannerType { information, warning, error, success, colored }

/// Specify how an [ArnaBanner] was closed.
///
/// The [ArnaScaffoldMessengerState.showBanner] function returns a
/// [ArnaScaffoldFeatureController]. The value of the controller's closed
/// property is a Future that resolves to an ArnaBannerClosedReason.
/// Applications that need to know how a banner was closed can use this value.
///
/// Example:
///
/// ```dart
/// ArnaScaffoldMessenger.of(context).showBanner(
///   ArnaBanner( ... )
/// ).closed.then((ArnaBannerClosedReason reason) {
///    ...
/// });
/// ```
enum ArnaBannerClosedReason {
  /// The banner was closed through a [SemanticsAction.dismiss].
  dismiss,

  /// The banner was closed by a user's swipe.
  swipe,

  /// The banner was closed by the [ArnaScaffoldFeatureController] close
  /// callback or by calling [ArnaScaffoldMessengerState.hideCurrentBanner]
  /// directly.
  hide,

  /// The banner was closed by a call to
  /// [ArnaScaffoldMessengerState.removeCurrentBanner].
  remove,
}

/// An Arna-styled banner.
///
/// A banner displays an important, succinct message, and provides actions for
/// users to address (or dismiss the banner). A user action is required for it
/// to be dismissed.
///
/// Banners are displayed at the top of the screen, below a header bar. They
/// are persistent and non-modal, allowing the user to either ignore them or
/// interact with them at any time.
class ArnaBanner extends StatefulWidget {
  /// Creates a banner in the Arna style.
  const ArnaBanner({
    Key? key,
    required this.title,
    this.subtitle,
    required this.actions,
    this.animation,
    this.accentColor,
    this.bannerType = BannerType.information,
  }) : super(key: key);

  /// The primary content of the banner.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// The set of actions that are displayed at the trailing side of the banner.
  final List<Widget>? actions;

  /// The animation driving the entrance and exit of the banner when presented
  /// by the [ArnaScaffoldMessenger].
  final Animation<double>? animation;

  /// The indicator color of the banner.
  final Color? accentColor;

  /// The type of the banner.
  final BannerType bannerType;

  // API for ArnaScaffoldMessengerState.showBanner():

  /// Creates an animation controller useful for driving a banner's entrance
  /// and exit animation.
  static AnimationController createAnimationController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaBanner',
      vsync: vsync,
    );
  }

  /// Creates a copy of this banner but with the animation replaced with the
  /// given animation.
  ///
  /// If the original banner lacks a key, the newly created banner will use the
  /// given fallback key.
  ArnaBanner withAnimation(Animation<double> newAnimation, {Key? fallbackKey}) {
    return ArnaBanner(
      key: key ?? fallbackKey,
      title: title,
      subtitle: subtitle,
      actions: actions,
      animation: newAnimation,
      accentColor: accentColor,
      bannerType: bannerType,
    );
  }

  @override
  _ArnaBannerState createState() => _ArnaBannerState();
}

/// The [State] for a [ArnaBanner].
class _ArnaBannerState extends State<ArnaBanner> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    IconData icon;
    Color accent;
    switch (widget.bannerType) {
      case BannerType.information:
        icon = Icons.info;
        accent = ArnaColors.blue;
        break;
      case BannerType.warning:
        icon = Icons.warning;
        accent = ArnaColors.orange;
        break;
      case BannerType.error:
        icon = Icons.error;
        accent = ArnaColors.red;
        break;
      case BannerType.success:
        icon = Icons.check_circle;
        accent = ArnaColors.green;
        break;
      case BannerType.colored:
        icon = Icons.info;
        accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
        break;
    }

    Widget? trailing;
    if (widget.actions != null) {
      trailing = Row(mainAxisSize: MainAxisSize.min, children: widget.actions!);
    }

    Widget banner = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () => ArnaScaffoldMessenger.of(context).removeCurrentBanner(
        reason: ArnaBannerClosedReason.dismiss,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            color: ArnaDynamicColor.resolve(ArnaColors.headerColor, context),
            child: ArnaListTile(
              leading: Icon(
                icon,
                color: ArnaDynamicColor.resolve(accent, context),
              ),
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: trailing,
              actionable: false,
            ),
          ),
          const ArnaHorizontalDivider(),
        ],
      ),
    );

    return Hero(
      tag: '<ArnaBanner Hero tag - ${widget.title}>',
      child: MediaQuery.of(context).accessibleNavigation
          ? banner
          : SizeTransition(
              axisAlignment: 1,
              sizeFactor: CurvedAnimation(
                parent: widget.animation!,
                curve: Styles.basicCurve,
              ),
              child: banner,
            ),
    );
  }
}
