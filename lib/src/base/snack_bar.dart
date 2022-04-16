import 'package:arna/arna.dart';

/// Specify how an [ArnaSnackBar] was closed.
///
/// The [ArnaScaffoldMessengerState.showSnackBar] function returns an
/// [ArnaScaffoldFeatureController]. The value of the controller's closed
/// property is a Future that resolves to a ArnaSnackBarClosedReason.
/// Applications that need to know how a snackbar was closed can use this
/// value.
///
/// Example:
///
/// ```dart
/// ArnaScaffoldMessenger.of(context).showSnackBar(
///   ArnaSnackBar( ... )
/// ).closed.then((ArnaSnackBarClosedReason reason) {
///    ...
/// });
/// ```
enum ArnaSnackBarClosedReason {
  /// The snack bar was closed after the user tapped a [ArnaSnackBarAction].
  action,

  /// The snack bar was closed through a [SemanticsAction.dismiss].
  dismiss,

  /// The snack bar was closed by a user's swipe.
  swipe,

  /// The snack bar was closed by the [ArnaScaffoldFeatureController] close
  /// callback or by calling [ArnaScaffoldMessengerState.hideCurrentSnackBar]
  /// directly.
  hide,

  /// The snack bar was closed by an call to
  /// [ArnaScaffoldMessengerState.removeCurrentSnackBar].
  remove,

  /// The snack bar was closed because its timer expired.
  timeout,
}

/// A button for an [ArnaSnackBar], known as an "action".
///
/// Snack bar actions are always enabled. If you want to disable a snack bar
/// action, simply don't include it in the snack bar.
///
/// Snack bar actions can only be pressed once. Subsequent presses are ignored.
///
/// See also:
///
///  * [ArnaSnackBar]
class ArnaSnackBarAction extends StatelessWidget {
  /// Creates a button for a [ArnaSnackBar].
  const ArnaSnackBarAction({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  ///
  /// If this callback is null, then the button will be disabled.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is
  /// pressed.
  final String? tooltipMessage;

  /// The type of the button.
  final ButtonType buttonType;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ArnaButton(
      label: label,
      icon: icon,
      onPressed: () {
        if (onPressed != null) onPressed!();
        ArnaScaffoldMessenger.of(context).hideCurrentSnackBar(
          reason: ArnaSnackBarClosedReason.action,
        );
      },
      tooltipMessage: tooltipMessage,
      buttonType: buttonType,
      isFocusable: isFocusable,
      autofocus: autofocus,
      accentColor: accentColor,
      cursor: cursor,
      semanticLabel: semanticLabel,
    );
  }
}

/// A message with an optional action which briefly displays at the bottom of
/// the screen.
///
/// To display a snack bar, call
/// `ArnaScaffoldMessenger.of(context).showSnackBar()`, passing an instance of
/// [ArnaSnackBar] that describes the message.
/// An [ArnaSnackBar] with an action will not time out when TalkBack or
/// VoiceOver are  enabled. This is controlled by
/// [AccessibilityFeatures.accessibleNavigation].
///
/// See also:
///
///  * [ArnaScaffoldMessenger.of], to obtain the current
///    [ArnaScaffoldMessengerState],  which manages the display and animation
///    of snack bars.
///  * [ArnaScaffoldMessengerState.showSnackBar], which displays a
///    [ArnaSnackBar].
///  * [ArnaScaffoldMessengerState.removeCurrentSnackBar], which abruptly hides
///    the currently displayed snack bar, if any, and allows the next to be
///    displayed.
///  * [ArnaSnackBarAction], which is used to specify an [action] button to
///    show on the snack bar.
class ArnaSnackBar extends StatefulWidget {
  /// Creates a snack bar in the Arna style.
  const ArnaSnackBar({
    Key? key,
    required this.message,
    this.action,
    this.animation,
    this.dismissDirection = DismissDirection.down,
  }) : super(key: key);

  /// The message of the snack bar.
  final String message;

  /// (optional) An action that the user can take based on the snack bar.
  ///
  /// For example, the snack bar might let the user undo the operation that
  /// prompted the snackbar. Snack bars can have at most one action.
  ///
  /// The action should not be "dismiss" or "cancel".
  final ArnaSnackBarAction? action;

  /// The animation driving the entrance and exit of the snack bar.
  final Animation<double>? animation;

  /// The direction in which the SnackBar can be dismissed.
  ///
  /// Cannot be null, defaults to [DismissDirection.down].
  final DismissDirection dismissDirection;

  // API for ArnaScaffoldMessengerState.showSnackBar():

  /// Creates an animation controller useful for driving a snack bar's entrance
  /// and exit animation.
  static AnimationController createAnimationController({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaSnackBar',
      vsync: vsync,
    );
  }

  /// Creates a copy of this snack bar but with the animation replaced with the
  /// given animation.
  ///
  /// If the original snack bar lacks a key, the newly created snack bar will
  /// use the given fallback key.
  ArnaSnackBar withAnimation(
    Animation<double> newAnimation, {
    Key? fallbackKey,
  }) {
    return ArnaSnackBar(
      key: key ?? fallbackKey,
      message: message,
      action: action,
      animation: newAnimation,
      dismissDirection: dismissDirection,
    );
  }

  @override
  State<ArnaSnackBar> createState() => _ArnaSnackBarState();
}

/// The [State] for a [ArnaSnackBar].
class _ArnaSnackBarState extends State<ArnaSnackBar> {
  @override
  Widget build(BuildContext context) {
    assert(widget.animation != null);

    Widget snackBar = Semantics(
      container: true,
      liveRegion: true,
      onDismiss: () => ArnaScaffoldMessenger.of(context).removeCurrentSnackBar(
        reason: ArnaSnackBarClosedReason.dismiss,
      ),
      child: Dismissible(
        key: const Key('dismissible'),
        direction: widget.dismissDirection,
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          ArnaScaffoldMessenger.of(context).removeCurrentSnackBar(
            reason: ArnaSnackBarClosedReason.swipe,
          );
        },
        child: Container(
          height: Styles.headerBarHeight,
          color: ArnaDynamicColor.resolve(
            ArnaColors.reverseBackgroundColor,
            context,
          ),
          padding: Styles.largeHorizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.message,
                  style: ArnaTheme.of(context).textTheme.body!.copyWith(
                        color: ArnaDynamicColor.resolve(
                          ArnaColors.primaryTextColorDark,
                          context,
                        ),
                      ),
                ),
              ),
              if (widget.action != null) widget.action!,
            ],
          ),
        ),
      ),
    );

    return Hero(
      tag: '<SnackBar Hero tag - ${widget.message}>',
      child: MediaQuery.of(context).accessibleNavigation
          ? snackBar
          : SizeTransition(
              axisAlignment: -1,
              sizeFactor: CurvedAnimation(
                parent: widget.animation!,
                curve: Styles.basicCurve,
              ),
              child: snackBar,
            ),
    );
  }
}
