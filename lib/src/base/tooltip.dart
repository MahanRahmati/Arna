import 'dart:async';

import 'package:arna/arna.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show PointerEnterEventListener, PointerExitEventListener;

/// The method of interaction that will trigger a tooltip.
/// Used in [ArnaTooltip.triggerMode].
enum ArnaTooltipTriggerMode {
  /// Tooltip will only be shown by calling `ensureTooltipVisible`.
  manual,

  /// Tooltip will be shown after a long press.
  ///
  /// See also:
  ///
  ///   * [GestureDetector.onLongPress], the event that is used for trigger.
  longPress,

  /// Tooltip will be shown after a single tap.
  ///
  /// See also:
  ///
  ///   * [GestureDetector.onTap], the event that is used for trigger.
  tap,
}

/// An Arna-styled tooltip.
///
/// Tooltips provide text labels which help explain the function of a button or
/// other user interface action. Wrap the button in a [ArnaTooltip] widget and provide
/// a message which will be shown when the widget is long pressed.
///
/// Many widgets, such as [ArnaButton], [ArnaIconButton], and
/// [ArnaTextButton] have a `tooltipMessage` property that, when non-null, causes the
/// widget to include a [ArnaTooltip] in its build.
///
/// Tooltips improve the accessibility of visual widgets by proving a textual
/// representation of the widget, which, for example, can be vocalized by a
/// screen reader.
class ArnaTooltip extends StatefulWidget {
  /// Creates a tooltip.
  /// Only one of [message] and [richMessage] may be non-null.
  const ArnaTooltip({
    Key? key,
    this.message,
    this.richMessage,
    this.preferBelow,
    this.excludeFromSemantics,
    this.triggerMode,
    required this.child,
  }) : super(key: key);

  /// The text to display in the tooltip.
  ///
  /// Only one of [message] and [richMessage] may be non-null.
  final String? message;

  /// The rich text to display in the tooltip.
  ///
  /// Only one of [message] and [richMessage] may be non-null.
  final InlineSpan? richMessage;

  /// Whether the tooltip defaults to being displayed below the widget.
  ///
  /// Defaults to true. If there is insufficient space to display the tooltip
  /// in the preferred direction, the tooltip will be displayed in the opposite
  /// direction.
  final bool? preferBelow;

  /// Whether the tooltip's [message] or [richMessage] should be excluded from
  /// the semantics tree.
  ///
  /// Defaults to false. A tooltip will add a [Semantics] label that is set to
  /// [ArnaTooltip.message] if non-null, or the plain text value of
  /// [ArnaTooltip.richMessage] otherwise. Set this property to true if the app
  /// is going to provide its own custom semantics label.
  final bool? excludeFromSemantics;

  /// The [ArnaTooltipTriggerMode] that will show the tooltip.
  /// the default mode is [ArnaTooltipTriggerMode.longPress].
  final ArnaTooltipTriggerMode? triggerMode;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  static final List<_ArnaTooltipState> _openedTooltips = <_ArnaTooltipState>[];

  // Causes any current tooltips to be concealed. Only called for mouse hover enter
  // detections. Won't conceal the supplied tooltip.
  static void _concealOtherTooltips(_ArnaTooltipState current) {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<_ArnaTooltipState> openedTooltips = _openedTooltips.toList();
      for (final _ArnaTooltipState state in openedTooltips) {
        if (state == current) {
          continue;
        }
        state._concealTooltip();
      }
    }
  }

  // Causes the most recently concealed tooltip to be revealed. Only called for mouse
  // hover exit detections.
  static void _revealLastTooltip() {
    if (_openedTooltips.isNotEmpty) {
      _openedTooltips.last._revealTooltip();
    }
  }

  /// Dismiss all of the tooltips that are currently shown on the screen.
  ///
  /// This method returns true if it successfully dismisses the tooltips. It
  /// returns false if there is no tooltip shown on the screen.
  static bool dismissAllToolTips() {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<_ArnaTooltipState> openedTooltips = _openedTooltips.toList();
      for (final _ArnaTooltipState state in openedTooltips) {
        state._dismissTooltip(immediately: true);
      }
      return true;
    }
    return false;
  }

  @override
  State<ArnaTooltip> createState() => _ArnaTooltipState();
}

class _ArnaTooltipState extends State<ArnaTooltip>
    with SingleTickerProviderStateMixin {
  late bool preferBelow;
  late bool excludeFromSemantics;
  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _dismissTimer;
  Timer? _showTimer;
  late bool _mouseIsConnected;
  bool _pressActivated = false;
  late ArnaTooltipTriggerMode triggerMode;
  late bool _isConcealed;
  late bool _forceRemoval;
  late bool _visible;

  /// The plain text message for this tooltip.
  ///
  /// This value will either come from [widget.message] or [widget.richMessage].
  String get _tooltipMessage =>
      widget.message ?? widget.richMessage!.toPlainText();

  @override
  void initState() {
    super.initState();
    _isConcealed = false;
    _forceRemoval = false;
    _mouseIsConnected = RendererBinding.instance!.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: Styles.basicDuration,
      reverseDuration: Styles.tooltipReverseDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
    // Listen to see when a mouse is added.
    RendererBinding.instance!.mouseTracker.addListener(
      _handleMouseTrackerChange,
    );
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on.
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = ArnaTooltipVisibility.of(context);
  }

  // Forces a rebuild if a mouse has been added or removed.
  void _handleMouseTrackerChange() {
    if (!mounted) return;
    final bool mouseIsConnected =
        RendererBinding.instance!.mouseTracker.mouseIsConnected;
    if (mouseIsConnected != _mouseIsConnected) {
      setState(() => _mouseIsConnected = mouseIsConnected);
    }
  }

  void _handleStatusChanged(AnimationStatus status) {
    // If this tip is concealed, don't remove it, even if it is dismissed, so that we can
    // reveal it later, unless it has explicitly been hidden with _dismissTooltip.
    if (status == AnimationStatus.dismissed &&
        (_forceRemoval || !_isConcealed)) {
      _removeEntry();
    }
  }

  void _dismissTooltip({bool immediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;
    if (immediately) {
      _removeEntry();
      return;
    }
    // So it will be removed when it's done reversing, regardless of whether it is
    // still concealed or not.
    _forceRemoval = true;
    if (_pressActivated) {
      _dismissTimer ??= Timer(Styles.tooltipDuration, _controller.reverse);
    } else {
      _dismissTimer ??=
          Timer(Styles.tooltipHoverShowDuration, _controller.reverse);
    }
    _pressActivated = false;
  }

  void _showTooltip({bool immediately = false}) {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (immediately) {
      ensureTooltipVisible();
      return;
    }
    _showTimer ??= Timer(Styles.tooltipWaitDuration, ensureTooltipVisible);
  }

  void _concealTooltip() {
    if (_isConcealed || _forceRemoval) {
      // Already concealed, or it's being removed.
      return;
    }
    _isConcealed = true;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (_entry != null) _entry!.remove();
    _controller.reverse();
  }

  void _revealTooltip() {
    if (!_isConcealed) {
      // Already uncovered.
      return;
    }
    _isConcealed = false;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (!_entry!.mounted) {
      final OverlayState overlayState = Overlay.of(
        context,
        debugRequiredFor: widget,
      )!;
      overlayState.insert(_entry!);
    }
    SemanticsService.tooltip(_tooltipMessage);
    _controller.forward();
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// Returns `false` when the tooltip shouldn't be shown or when the tooltip
  /// was already visible.
  bool ensureTooltipVisible() {
    if (!_visible) return false;
    _showTimer?.cancel();
    _showTimer = null;
    _forceRemoval = false;
    if (_isConcealed) {
      if (_mouseIsConnected) {
        ArnaTooltip._concealOtherTooltips(this);
      }
      _revealTooltip();
      return true;
    }
    if (_entry != null) {
      // Stop trying to hide, if we were.
      _dismissTimer?.cancel();
      _dismissTimer = null;
      _controller.forward();
      return false; // Already visible.
    }
    _createNewEntry();
    _controller.forward();
    return true;
  }

  static final Set<_ArnaTooltipState> _mouseIn = <_ArnaTooltipState>{};

  void _handleMouseEnter() => _showTooltip();

  void _handleMouseExit({bool immediately = false}) {
    // If the tip is currently covered, we can just remove it without waiting.
    _dismissTooltip(immediately: _isConcealed || immediately);
  }

  void _createNewEntry() {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    )!;

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    // We create this widget outside of the overlay entry's builder to prevent
    // updated values from happening to leak into the overlay when the overlay
    // rebuilds.
    final Widget overlay = Directionality(
      textDirection: Directionality.of(context),
      child: _ArnaTooltipOverlay(
        richMessage: widget.richMessage ?? TextSpan(text: widget.message),
        onEnter: _mouseIsConnected ? (_) => _handleMouseEnter() : null,
        onExit: _mouseIsConnected ? (_) => _handleMouseExit() : null,
        animation:
            CurvedAnimation(parent: _controller, curve: Styles.basicCurve),
        target: target,
        preferBelow: preferBelow,
      ),
    );
    _entry = OverlayEntry(builder: (BuildContext context) => overlay);
    _isConcealed = false;
    overlayState.insert(_entry!);
    SemanticsService.tooltip(_tooltipMessage);
    if (_mouseIsConnected) {
      // Hovered tooltips shouldn't show more than one at once. For example, a chip with
      // a delete icon shouldn't show both the delete icon tooltip and the chip tooltip
      // at the same time.
      ArnaTooltip._concealOtherTooltips(this);
    }
    assert(!ArnaTooltip._openedTooltips.contains(this));
    ArnaTooltip._openedTooltips.add(this);
  }

  void _removeEntry() {
    ArnaTooltip._openedTooltips.remove(this);
    _mouseIn.remove(this);
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (!_isConcealed) _entry?.remove();
    _isConcealed = false;
    _entry = null;
    if (_mouseIsConnected) ArnaTooltip._revealLastTooltip();
  }

  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) return;
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _handleMouseExit();
    } else if (event is PointerDownEvent) {
      _handleMouseExit(immediately: true);
    }
  }

  @override
  void deactivate() {
    if (_entry != null) _dismissTooltip(immediately: true);
    _showTimer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    GestureBinding.instance!.pointerRouter.removeGlobalRoute(
      _handlePointerEvent,
    );
    RendererBinding.instance!.mouseTracker.removeListener(
      _handleMouseTrackerChange,
    );
    _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() => _pressActivated = true;

  Widget _buildChild() {
    preferBelow = widget.preferBelow ?? true;
    excludeFromSemantics = widget.excludeFromSemantics ?? false;
    triggerMode = widget.triggerMode ?? ArnaTooltipTriggerMode.longPress;
    Widget result = Semantics(
      label: excludeFromSemantics ? null : _tooltipMessage,
      child: widget.child,
    );

    // Only check for gestures if tooltip should be visible.
    if (_visible) {
      result = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: (triggerMode == ArnaTooltipTriggerMode.longPress)
            ? _handlePress
            : null,
        onTap:
            (triggerMode == ArnaTooltipTriggerMode.tap) ? _handlePress : null,
        excludeFromSemantics: true,
        child: result,
      );
      // Only check for hovering if there is a mouse connected.
      if (_mouseIsConnected) {
        result = MouseRegion(
          onEnter: (_) => _handleMouseEnter(),
          onExit: (_) => _handleMouseExit(),
          child: result,
        );
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // If message is empty then no need to create a tooltip overlay to show
    // the empty black container so just return the wrapped child as is or
    // empty container if child is not specified.
    return (widget.message == null && widget.richMessage == null)
        ? widget.child
        : _buildChild();
  }
}

/// A delegate for computing the layout of a tooltip to be displayed above or
/// bellow a target specified in the global coordinate system.
class _ArnaTooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _ArnaTooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_ArnaTooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class _ArnaTooltipOverlay extends StatelessWidget {
  const _ArnaTooltipOverlay({
    Key? key,
    required this.richMessage,
    required this.animation,
    required this.target,
    required this.preferBelow,
    this.onEnter,
    this.onExit,
  }) : super(key: key);

  final InlineSpan richMessage;
  final Animation<double> animation;
  final Offset target;
  final bool preferBelow;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  @override
  Widget build(BuildContext context) {
    Widget result = IgnorePointer(
        child: FadeTransition(
      opacity: animation,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: Styles.tooltipHeight),
        child: DefaultTextStyle(
          style: ArnaTheme.of(context).textTheme.captionTextStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.reversePrimaryTextColor,
                  context,
                ),
              ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              color: ArnaDynamicColor.resolve(
                ArnaColors.reverseBackgroundColor,
                context,
              ),
            ),
            padding: Styles.tooltipPadding,
            margin: Styles.normal,
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text.rich(
                richMessage,
                style:
                    ArnaTheme.of(context).textTheme.captionTextStyle.copyWith(
                          color: ArnaDynamicColor.resolve(
                            ArnaColors.reversePrimaryTextColor,
                            context,
                          ),
                        ),
              ),
            ),
          ),
        ),
      ),
    ));
    if (onEnter != null || onExit != null) {
      result = MouseRegion(onEnter: onEnter, onExit: onExit, child: result);
    }
    return Positioned.fill(
      child: CustomSingleChildLayout(
        delegate: _ArnaTooltipPositionDelegate(
          target: target,
          verticalOffset: Styles.tooltipOffset,
          preferBelow: preferBelow,
        ),
        child: result,
      ),
    );
  }
}

class _ArnaTooltipVisibilityScope extends InheritedWidget {
  const _ArnaTooltipVisibilityScope({
    Key? key,
    required Widget child,
    required this.visible,
  }) : super(key: key, child: child);

  final bool visible;

  @override
  bool updateShouldNotify(_ArnaTooltipVisibilityScope old) {
    return old.visible != visible;
  }
}

/// Overrides the visibility of descendant [ArnaTooltip] widgets.
///
/// If disabled, the descendant [ArnaTooltip] widgets will not display a tooltip
/// when tapped, long-pressed, hovered by the mouse, or when
/// `ensureTooltipVisible` is called. This only visually disables tooltips but
/// continues to provide any semantic information that is provided.
class ArnaTooltipVisibility extends StatelessWidget {
  /// Creates a widget that configures the visibility of [ArnaTooltip].
  ///
  /// Both arguments must not be null.
  const ArnaTooltipVisibility({
    Key? key,
    required this.visible,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// The entire app can be wrapped in this widget to globally control [ArnaTooltip]
  /// visibility.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Determines the visibility of [ArnaTooltip] widgets that inherit from this widget.
  final bool visible;

  /// The [visible] of the closest instance of this class that encloses the
  /// given context. Defaults to `true` if none are found.
  static bool of(BuildContext context) {
    final _ArnaTooltipVisibilityScope? visibility = context
        .dependOnInheritedWidgetOfExactType<_ArnaTooltipVisibilityScope>();
    return visibility?.visible ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return _ArnaTooltipVisibilityScope(visible: visible, child: child);
  }
}
