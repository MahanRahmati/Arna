import 'package:arna/arna.dart';

// TODO(Mahan): Refactor ArnaSnackBar.

/// A message with an optional action which briefly displays at the bottom of the screen.
///
/// An [ArnaSnackBar] with an action will not time out when TalkBack or VoiceOver are enabled. This is controlled by
/// [AccessibilityFeatures.accessibleNavigation].
class ArnaSnackBar extends StatefulWidget {
  /// Creates a snack bar in the Arna style.
  const ArnaSnackBar({
    super.key,
    required this.message,
    this.action,
  });

  /// The message of the snack bar.
  final String message;

  /// An action that the user can take based on the snack bar.
  ///
  /// For example, the snack bar might let the user undo the operation that prompted the snackbar.
  final Widget? action;

  @override
  State<ArnaSnackBar> createState() => _ArnaSnackBarState();
}

/// The [State] for an [ArnaSnackBar].
class _ArnaSnackBarState extends State<ArnaSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaSnackBar',
      vsync: this,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final Widget snackBar = Semantics(
      container: true,
      liveRegion: true,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: Styles.large,
          child: Container(
            height: Styles.headerBarHeight,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              color: ArnaColors.reverseBackgroundColor.resolveFrom(context),
            ),
            padding: Styles.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: Styles.padding),
                Flexible(
                  child: Text(
                    widget.message,
                    style: ArnaTheme.of(context).textTheme.body!.copyWith(
                          color: ArnaColors.primaryTextColorDark
                              .resolveFrom(context),
                        ),
                  ),
                ),
                const SizedBox(width: Styles.padding),
                if (widget.action != null) widget.action!,
              ],
            ),
          ),
        ),
      ),
    );

    return Hero(
      tag: '<ArnaSnackBar Hero tag - ${widget.message}>',
      child: MediaQuery.of(context).accessibleNavigation
          ? snackBar
          : SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(controller),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: Styles.basicCurve,
                ),
                child: snackBar,
              ),
            ),
    );
  }
}

/// Shows [ArnaSnackBar].
OverlayEntry showArnaSnackbar({
  required final BuildContext context,
  required final String message,
  final Widget? action,
}) {
  final GlobalKey<_ArnaSnackBarState> snackBarKey =
      GlobalKey<_ArnaSnackBarState>();
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (final BuildContext context) => ArnaSnackBar(
      key: snackBarKey,
      message: message,
      action: action,
    ),
  );
  Overlay.of(context).insert(overlayEntry);
  Future<dynamic>.delayed(Styles.snackbarDuration).then((final _) async {
    if (overlayEntry.mounted) {
      await snackBarKey.currentState?.controller.reverse();
    }
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
  return overlayEntry;
}
