import 'package:arna/arna.dart';

/// Banner types.
enum BannerType { information, warning, error, success, colored }

class ArnaBanner extends StatefulWidget {
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

  Widget _buildChild() {
    final List<Widget> children = [];
    Color accent;
    IconData icon = Icons.info;
    switch (widget.bannerType) {
      case BannerType.warning:
        accent = ArnaColors.warningColor;
        icon = Icons.warning;
        break;
      case BannerType.error:
        accent = ArnaColors.errorColor;
        icon = Icons.error;
        break;
      case BannerType.success:
        accent = ArnaColors.successColor;
        icon = Icons.check_circle;
        break;
      case BannerType.colored:
        accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
        break;
      default:
        accent = ArnaColors.accentColor;
    }
    children.add(
      Icon(
        icon,
        color: ArnaDynamicColor.resolve(accent, context),
      ),
    );
    children.add(const SizedBox(width: Styles.padding));
    children.add(
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: (widget.subtitle != null)
                  ? const EdgeInsets.fromLTRB(
                      Styles.padding,
                      Styles.smallPadding,
                      Styles.padding,
                      Styles.smallerPadding,
                    )
                  : Styles.tileTextPadding,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.title,
                      style: ArnaTheme.of(context).textTheme.textStyle.copyWith(
                            color: ArnaDynamicColor.resolve(
                              ArnaColors.primaryTextColor,
                              context,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.subtitle != null)
              Padding(
                padding: Styles.tileSubtitleTextPadding,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.subtitle!,
                        style: ArnaTheme.of(context)
                            .textTheme
                            .subtitleTextStyle
                            .copyWith(
                              color: ArnaDynamicColor.resolve(
                                ArnaColors.secondaryTextColor,
                                context,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (widget.trailing != null) {
      children.add(Padding(padding: Styles.normal, child: widget.trailing));
    }
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: _expandAnimation,
      child: Column(
        children: [
          AnimatedContainer(
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            color: ArnaDynamicColor.resolve(
              ArnaColors.headerColor,
              context,
            ),
            padding: Styles.tilePadding,
            child: _buildChild(),
          ),
          if (widget.showBanner) const ArnaHorizontalDivider(),
        ],
      ),
    );
  }
}
