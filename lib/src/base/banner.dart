import 'package:arna/arna.dart';

/// Banner types.
enum BannerType { information, warning, error, success, colored }

/// An Arna-styled banner.
///
/// A banner displays an important, succinct message, and provides actions for
/// users to address (or dismiss the banner). A user action is required for it
/// to be dismissed.
///
/// They are persistent and non-modal, allowing the user to either ignore them or
/// interact with them at any time.
class ArnaBanner extends StatefulWidget {
  /// Creates a banner in the Arna style.
  const ArnaBanner({
    Key? key,
    required this.showBanner,
    required this.title,
    this.subtitle,
    this.trailing,
    this.accentColor,
    this.bannerType = BannerType.information,
  }) : super(key: key);

  /// Whether to show banner or not.
  final bool showBanner;

  /// The primary content of the banner.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// The trailing widget laid out within the banner.
  final Widget? trailing;

  /// The indicator color of the banner.
  final Color? accentColor;

  /// The type of the banner.
  final BannerType bannerType;

  @override
  _ArnaBannerState createState() => _ArnaBannerState();
}

class _ArnaBannerState extends State<ArnaBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Styles.basicCurve,
    );
    if (widget.showBanner) _controller.forward();
  }

  @override
  void didUpdateWidget(ArnaBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBanner != oldWidget.showBanner) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          widget.showBanner ? _controller.forward() : _controller.reverse();
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.info;
    Color accent;
    switch (widget.bannerType) {
      case BannerType.warning:
        icon = Icons.warning;
        accent = ArnaColors.warningColor;
        break;
      case BannerType.error:
        icon = Icons.error;
        accent = ArnaColors.errorColor;
        break;
      case BannerType.success:
        icon = Icons.check_circle;
        accent = ArnaColors.successColor;
        break;
      case BannerType.colored:
        accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
        break;
      default:
        accent = ArnaColors.accentColor;
    }
    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: _expandAnimation,
      child: Column(
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
              trailing: widget.trailing,
              actionable: false,
            ),
          ),
          if (widget.showBanner) const ArnaHorizontalDivider(),
        ],
      ),
    );
  }
}
