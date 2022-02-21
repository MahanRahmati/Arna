import 'package:arna/arna.dart';

class ArnaBanner extends StatefulWidget {
  const ArnaBanner({
    Key? key,
    required this.showBanner,
    required this.message,
    this.trailing,
    this.accentColor,
  }) : super(key: key);

  /// Whether to show banner or not.
  final bool showBanner;

  /// The message of the banner.
  final String message;

  /// The trailing widget laid out within the banner.
  final Widget? trailing;

  /// The indicator color of the banner.
  final Color? accentColor;

  @override
  _ArnaBannerState createState() => _ArnaBannerState();
}

class _ArnaBannerState extends State<ArnaBanner> {
  Widget _buildChild(BuildContext context) {
    final List<Widget> children = [];
    children.add(
      Flexible(
        child: Text(
          widget.message,
          style: ArnaTheme.of(context).textTheme.textStyle,
        ),
      ),
    );
    children.add(
      widget.trailing != null ? widget.trailing! : const SizedBox.shrink(),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.showBanner
        ? Column(
            children: [
              AnimatedContainer(
                height: widget.showBanner ? Styles.headerBarHeight : 0,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                color: ArnaDynamicColor.resolve(
                  widget.accentColor ?? ArnaTheme.of(context).accentColor,
                  context,
                ).withAlpha(56),
                child: Padding(
                  padding: Styles.horizontal,
                  child: _buildChild(context),
                ),
              ),
              if (widget.showBanner) const ArnaHorizontalDivider(),
            ],
          )
        : const SizedBox.shrink();
  }
}
