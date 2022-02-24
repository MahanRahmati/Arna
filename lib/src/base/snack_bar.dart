import 'package:arna/arna.dart';

/// An Arna-styled snack bar.
///
/// The ArnaSnackBar displays [title] and [trailing] widget.
/// [title] is in the left, the [trailing] is in the right.
/// See also:
///
///  * [ArnaScaffold], which displays the [ArnaSnackBar].
class ArnaSnackBar extends StatefulWidget {
  /// Creates a snack bar in the Arna style.
  const ArnaSnackBar({
    Key? key,
    required this.message,
    this.trailing,
  }) : super(key: key);

  /// The message of the snack bar.
  final String message;

  /// The trailing widget laid out within the snack bar.
  final Widget? trailing;

  @override
  State<ArnaSnackBar> createState() => ArnaSnackBarState();
}

class ArnaSnackBarState extends State<ArnaSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Styles.basicDuration,
      vsync: this,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildChild(BuildContext context) {
    final List<Widget> children = [];
    children.add(
      Flexible(
        child: Text(
          widget.message,
          style: ArnaTheme.of(context).textTheme.textStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.reversePrimaryTextColor,
                  context,
                ),
              ),
        ),
      ),
    );
    if (widget.trailing != null) {
      children.add(const SizedBox(width: Styles.largePadding));
      children.add(widget.trailing!);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(controller),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: controller,
            curve: Styles.basicCurve,
          ),
          child: Padding(
            padding: Styles.large,
            child: Container(
              height: Styles.headerBarHeight,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                color: ArnaDynamicColor.resolve(
                  ArnaColors.reverseBackgroundColor,
                  context,
                ),
              ),
              padding: Styles.largeHorizontal,
              child: _buildChild(context),
            ),
          ),
        ),
      ),
    );
  }
}

/// Show ArnaSnackbar.
OverlayEntry showArnaSnackbar({
  required BuildContext context,
  required String message,
  Widget? trailing,
}) {
  final GlobalKey<ArnaSnackBarState> snackBarKey =
      GlobalKey<ArnaSnackBarState>();
  final _overlayEntry = OverlayEntry(
    builder: (context) => ArnaSnackBar(
      key: snackBarKey,
      message: message,
      trailing: trailing,
    ),
  );
  Overlay.of(context)!.insert(_overlayEntry);
  Future.delayed(Styles.snackbarDuration).then((value) async {
    if (_overlayEntry.mounted) {
      await snackBarKey.currentState?.controller.reverse();
    }
    if (_overlayEntry.mounted) _overlayEntry.remove();
  });
  return _overlayEntry;
}
