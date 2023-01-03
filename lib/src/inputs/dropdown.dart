import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// Painter of [_ArnaDropdownMenu].
class _ArnaDropdownMenuPainter extends CustomPainter {
  /// Creates an ArnaDropdownMenu painter.
  _ArnaDropdownMenuPainter({
    this.selectedIndex,
    required this.resize,
    required this.getSelectedItemOffset,
  })  : _painter = BoxDecoration(
          // If you add an image here, you must provide a real configuration in the paint() function and you must
          // provide some sort of onChanged callback here.
          borderRadius: Styles.borderRadius,
        ).createBoxPainter(),
        super(repaint: resize);

  final int? selectedIndex;
  final Animation<double> resize;
  final ValueGetter<double> getSelectedItemOffset;
  final BoxPainter _painter;

  @override
  void paint(final Canvas canvas, final Size size) {
    final double selectedItemOffset = getSelectedItemOffset();
    final Tween<double> top = Tween<double>(
      begin: selectedItemOffset.clamp(
        0.0,
        math.max(size.height - Styles.menuItemSize, 0.0),
      ),
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: (top.begin! + Styles.menuItemSize).clamp(
        math.min(Styles.menuItemSize, size.height),
        size.height,
      ),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(
      0.0,
      top.evaluate(resize),
      size.width,
      bottom.evaluate(resize),
    );

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(final _ArnaDropdownMenuPainter oldPainter) {
    return oldPainter.selectedIndex != selectedIndex ||
        oldPainter.resize != resize;
  }
}

/// The widget that is the button wrapping the menu items.
class _ArnaDropdownMenuItemButton<T> extends StatefulWidget {
  /// Creates a widget that is the button wrapping the menu items.
  const _ArnaDropdownMenuItemButton({
    super.key,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
    required this.accentColor,
    required this.enableFeedback,
  });

  final _ArnaDropdownRoute<T> route;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;
  final Color accentColor;
  final bool enableFeedback;

  @override
  State<_ArnaDropdownMenuItemButton<T>> createState() =>
      _ArnaDropdownMenuItemButtonState<T>();
}

/// The [State] for an [_ArnaDropdownMenuItemButton].
class _ArnaDropdownMenuItemButtonState<T>
    extends State<_ArnaDropdownMenuItemButton<T>> {
  void _handleOnTap() {
    final ArnaDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;
    dropdownMenuItem.onTap?.call();
    Navigator.pop(context, _ArnaDropdownRouteResult<T>(dropdownMenuItem.value));
  }

  // On the web, up/down don't change focus, *except* in a <select> element, which is what a dropdown emulates.
  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
      TraversalDirection.down,
    ),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
      TraversalDirection.up,
    ),
  };

  @override
  Widget build(final BuildContext context) {
    final Color cardColor = ArnaColors.cardColor.resolveFrom(context);
    final Color disabledColor = ArnaColors.disabledColor.resolveFrom(context);
    TextStyle style = ArnaTheme.of(context).textTheme.button!;
    final ArnaDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;
    final CurvedAnimation opacity;
    final double unit = 0.5 / (widget.route.items.length + 1.5);

    if (widget.itemIndex == widget.route.selectedIndex) {
      opacity = CurvedAnimation(
        parent: widget.route.animation!,
        curve: const Threshold(0.0),
      );
    } else {
      final double start =
          (0.5 + (widget.itemIndex + 1) * unit).clamp(0.0, 1.0);
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      opacity = CurvedAnimation(
        parent: widget.route.animation!,
        curve: Interval(start, end),
      );
    }

    if (!dropdownMenuItem.enabled) {
      style = style.copyWith(color: disabledColor);
    }

    Widget child = FadeTransition(
      opacity: opacity,
      child: Padding(
        padding: Styles.small,
        child: ArnaBaseWidget(
          builder: (
            final BuildContext context,
            bool enabled,
            final bool hover,
            final bool focused,
            final bool pressed,
            bool selected,
          ) {
            enabled = dropdownMenuItem.enabled;
            selected = widget.itemIndex == widget.route.selectedIndex;
            return AnimatedContainer(
              height: Styles.menuItemSize,
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                color: !enabled
                    ? cardColor
                    : pressed || hover || focused
                        ? selected
                            ? ArnaDynamicColor.applyOverlay(widget.accentColor)
                            : ArnaDynamicColor.applyOverlay(cardColor)
                        : selected
                            ? widget.accentColor
                            : cardColor,
              ),
              child: AnimatedDefaultTextStyle(
                style: style,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                child: Container(
                  height: Styles.menuItemSize,
                  alignment: AlignmentDirectional.centerStart,
                  padding: Styles.largeHorizontal,
                  child: widget.route.items[widget.itemIndex],
                ),
              ),
            );
          },
          onPressed: _handleOnTap,
          autofocus: widget.itemIndex == widget.route.selectedIndex,
          enableFeedback: widget.enableFeedback,
        ),
      ),
    );

    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(shortcuts: _webShortcuts, child: child);
    }
    return child;
  }
}

/// _ArnaDropdownMenu class.
class _ArnaDropdownMenu<T> extends StatefulWidget {
  /// Creates an ArnaDropdownMenu.
  const _ArnaDropdownMenu({
    super.key,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.accentColor,
    required this.enableFeedback,
  });

  final _ArnaDropdownRoute<T> route;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color accentColor;
  final bool enableFeedback;

  @override
  State<_ArnaDropdownMenu<T>> createState() => _ArnaDropdownMenuState<T>();
}

/// The [State] for an [_ArnaDropdownMenu].
class _ArnaDropdownMenuState<T> extends State<_ArnaDropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve direction. When the route's animation reverses,
    // if we were to recreate the CurvedAnimation objects in build, we'd lose CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  Widget build(final BuildContext context) {
    // The menu is shown in three stages (unit timing in brackets):
    // [0s - 0.25s] - Fade in a rect-sized menu container with the selected item.
    // [0.25s - 0.5s] - Grow the otherwise empty menu container from the center until it's big enough for as many items
    //   as we're going to show.
    // [0.5s - 1.0s] Fade in the remaining visible items from top to bottom.
    //
    // When the menu is dismissed we just fade the entire thing out in the first 0.25s.
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _ArnaDropdownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _ArnaDropdownMenuItemButton<T>(
          route: widget.route,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
          accentColor: widget.accentColor,
          enableFeedback: widget.enableFeedback,
        ),
    ];
    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _ArnaDropdownMenuPainter(
          selectedIndex: route.selectedIndex,
          resize: _resize,
          // This offset is passed as a callback, not a value, because it must be retrieved at paint time
          // (after layout), not at build time.
          getSelectedItemOffset: () => route.getItemOffset(route.selectedIndex),
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: ArnaCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: Styles.borderRadius,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                ),
                child: PrimaryScrollController(
                  controller: widget.route.scrollController!,
                  child: ArnaScrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      shrinkWrap: true,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// _ArnaDropdownMenuRouteLayout class.
class _ArnaDropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  /// Creates an ArnaDropdownMenuRouteLayout.
  _ArnaDropdownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final _ArnaDropdownRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(final BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than the view height. This ensures a
    // tappable area outside of the simple menu with which to dismiss the menu.
    final double maxHeight = math.max(
      0.0,
      constraints.maxHeight - 2 * Styles.menuItemSize,
    );

    // The width of a menu should be at most the view width. This ensures that the menu does not extend past the left
    // and right edges of the screen.
    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(final Size size, final Size childSize) {
    final _ArnaMenuLimits menuLimits = route.getMenuLimits(
      buttonRect,
      size.height,
      route.selectedIndex,
    );

    assert(
      () {
        final Rect container = Offset.zero & size;
        if (container.intersect(buttonRect) == buttonRect) {
          // If the button was entirely on-screen, then verify that the menu is also on-screen.
          // If the button was a bit off-screen, then, oh well.
          assert(menuLimits.top >= 0.0);
          assert(menuLimits.top + menuLimits.height <= size.height);
        }
        return true;
      }(),
    );
    assert(textDirection != null);
    final double left;
    switch (textDirection!) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(final _ArnaDropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

/// We box the return value so that the return value can be null. Otherwise, canceling the route (which returns null)
/// would get confused with actually returning a real null value.
@immutable
class _ArnaDropdownRouteResult<T> {
  const _ArnaDropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(final Object other) {
    return other is _ArnaDropdownRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

/// _ArnaMenuLimits class.
class _ArnaMenuLimits {
  const _ArnaMenuLimits(this.top, this.bottom, this.height, this.scrollOffset);
  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

/// The dropdown route class.
class _ArnaDropdownRoute<T> extends PopupRoute<_ArnaDropdownRouteResult<T>> {
  /// Creates an ArnaDropdownRoute.
  _ArnaDropdownRoute({
    required this.items,
    required this.buttonRect,
    required this.selectedIndex,
    required this.accentColor,
    required this.style,
    this.barrierLabel,
    required this.enableFeedback,
  }) : itemHeights = List<double>.filled(items.length, Styles.menuItemSize);

  final List<_ArnaMenuItem<T>> items;
  final Rect buttonRect;
  final int selectedIndex;
  final Color accentColor;
  final TextStyle style;
  final bool enableFeedback;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => Styles.basicDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder: (final BuildContext context, final BoxConstraints constraints) {
        return _ArnaDropdownRoutePage<T>(
          route: this,
          constraints: constraints,
          items: items,
          buttonRect: buttonRect,
          selectedIndex: selectedIndex,
          accentColor: accentColor,
          style: style,
          enableFeedback: enableFeedback,
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(final int index) {
    double offset = 0;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights
          .sublist(0, index)
          .reduce((final double total, final double height) => total + height);
    }
    return offset;
  }

  // Returns the vertical extent of the menu and the initial scrollOffset for the ListView that contains the menu
  // items. The vertical center of the selected item is aligned with the button's vertical center, as far as that's
  // possible given availableHeight.
  _ArnaMenuLimits getMenuLimits(
    final Rect buttonRect,
    final double availableHeight,
    final int index,
  ) {
    final double computedMaxHeight =
        availableHeight - 2.0 * Styles.menuItemSize;
    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);
    final double selectedItemOffset = getItemOffset(index);

    // If the button is placed on the bottom or top of the screen, its top or bottom may be less than
    // [Styles.menuItemSize] from the edge of the screen. In this case, we want to change the menu limits to align with
    // the top or bottom edge of the button.
    final double topLimit = math.min(Styles.menuItemSize, buttonTop);
    final double bottomLimit = math.max(
      availableHeight - Styles.menuItemSize,
      buttonBottom,
    );

    double menuTop = buttonBottom;
    double preferredMenuHeight = Styles.padding;
    if (items.isNotEmpty) {
      preferredMenuHeight += itemHeights
          .reduce((final double total, final double height) => total + height);
    }

    // If there are too many elements in the menu, we need to shrink it down so it is at most the computedMaxHeight.
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    // If the computed top or bottom of the menu are outside of the range specified, we need to bring them into range.
    // If the item height is larger than the button height and the button is at the very bottom or top of the screen,
    // the menu will be aligned with the bottom or top of the button respectively.
    if (menuTop < topLimit) {
      menuTop = math.min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIndex] / 2.0 <
        buttonBottom - buttonRect.height / 2.0) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // If all of the menu items will not fit within availableHeight then compute the scroll offset that will line the
    // selected menu item up with the select item. This is only done when the menu is first shown - subsequently we
    // leave the scroll offset where the user left it. This scroll offset is only accurate for fixed height menu items
    // (the default).
    if (preferredMenuHeight > computedMaxHeight) {
      // The offset should be zero if the selected item is in view at the beginning of the menu. Otherwise, the scroll
      // offset should center the item if possible.
      scrollOffset = math.max(0.0, selectedItemOffset - (buttonTop - menuTop));
      // If the selected item's scroll offset is greater than the maximum scroll offset, set it instead to the maximum
      // allowed scroll offset.
      scrollOffset = math.min(scrollOffset, preferredMenuHeight - menuHeight);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _ArnaMenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }
}

/// The dropdown route page class.
class _ArnaDropdownRoutePage<T> extends StatelessWidget {
  /// Creates an ArnaDropdownRoutePage.
  const _ArnaDropdownRoutePage({
    super.key,
    required this.route,
    required this.constraints,
    this.items,
    required this.buttonRect,
    required this.selectedIndex,
    required this.accentColor,
    required this.style,
    required this.enableFeedback,
  });

  final _ArnaDropdownRoute<T> route;
  final BoxConstraints constraints;
  final List<_ArnaMenuItem<T>>? items;
  final Rect buttonRect;
  final int selectedIndex;
  final Color accentColor;
  final TextStyle style;
  final bool enableFeedback;

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // Computing the initialScrollOffset now, before the items have been laid out.
    if (route.scrollController == null) {
      final _ArnaMenuLimits menuLimits = route.getMenuLimits(
        buttonRect,
        constraints.maxHeight,
        selectedIndex,
      );
      route.scrollController = ScrollController(
        initialScrollOffset: menuLimits.scrollOffset,
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (final BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _ArnaDropdownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              route: route,
              textDirection: Directionality.maybeOf(context),
            ),
            child: _ArnaDropdownMenu<T>(
              route: route,
              buttonRect: buttonRect,
              constraints: constraints,
              accentColor: accentColor,
              enableFeedback: enableFeedback,
            ),
          );
        },
      ),
    );
  }
}

/// This widget enables [_ArnaDropdownRoute] to look up the sizes of each menu item. These sizes are used to compute
/// the offset of the selected item so that [_ArnaDropdownRoutePage] can align the vertical center of the selected item
/// lines up with the vertical center of the dropdown button, as closely as possible.
class _ArnaMenuItem<T> extends SingleChildRenderObjectWidget {
  /// Creates an ArnaMenuItem.
  const _ArnaMenuItem({
    super.key,
    required this.onLayout,
    required this.item,
  }) : super(child: item);

  final ValueChanged<Size> onLayout;
  final ArnaDropdownMenuItem<T>? item;

  @override
  RenderObject createRenderObject(final BuildContext context) {
    return _RenderArnaMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    final BuildContext context,
    covariant final _RenderArnaMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

/// _RenderArnaMenuItem class.
class _RenderArnaMenuItem extends RenderProxyBox {
  /// Renders an ArnaMenuItem.
  _RenderArnaMenuItem(
    this.onLayout, [
    final RenderBox? child,
  ]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

/// The container widget for a menu item created by an [ArnaDropdownButton]. It provides the default configuration for
/// [ArnaDropdownMenuItem]s, as well as an [ArnaDropdownButton]'s hint and disabledHint widgets.
class _ArnaDropdownMenuItemContainer extends StatelessWidget {
  /// Creates an item for a dropdown menu.
  ///
  /// The [child] argument is required.
  const _ArnaDropdownMenuItemContainer({
    super.key,
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: Styles.menuItemSize),
      alignment: AlignmentDirectional.centerStart,
      child: child,
    );
  }
}

/// An item in a menu created by an [ArnaDropdownButton].
///
/// The type [T] is the type of the value the entry represents. All the entries in a given menu must represent values
/// with consistent types.
class ArnaDropdownMenuItem<T> extends _ArnaDropdownMenuItemContainer {
  /// Creates an item for a dropdown menu.
  ///
  /// The [child] argument is required.
  const ArnaDropdownMenuItem({
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    required super.child,
  });

  /// Called when the dropdown menu item is tapped.
  final VoidCallback? onTap;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [ArnaDropdownButton.onChanged].
  final T? value;

  /// Whether or not a user can select this menu item.
  ///
  /// Defaults to `true`.
  final bool enabled;
}

/// An Arna-styled button for selecting from a list of items.
///
/// A dropdown button lets the user select from a number of items. The button shows the currently selected item as well
/// as an arrow that opens a menu for selecting another item.
///
/// The type [T] is the type of the [value] that each dropdown item represents. All the entries in a given menu must
/// represent values with consistent types. Typically, an enum is used. Each [ArnaDropdownMenuItem] in [items] must be
/// specialized with that same type argument.
///
/// The [onChanged] callback should update a state variable that defines the dropdown's value. It should also call
/// [State.setState] to rebuild the dropdown with the new value.
///
/// If the [onChanged] callback is null or the list of [items] is null then the dropdown button will be disabled.
/// A disabled button will display the [disabledHint] text if it is non-null. However, if [disabledHint] is null and
/// [hint] is non-null, the [hint] text will instead be displayed.
///
/// See also:
///
///  * [ArnaDropdownMenuItem], the class used to represent the [items].
///  * [ArnaButton] ordinary button that triggers a single action.
class ArnaDropdownButton<T> extends StatefulWidget {
  /// Creates a dropdown button.
  ///
  /// The [items] must have distinct values. If [value] isn't null then it must be equal to one of the
  /// [ArnaDropdownMenuItem] values. If [items] or [onChanged] is null, the button will be disabled.
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed if it is non-null. If
  /// [disabledHint] is null, then [hint] will be displayed if it is non-null.
  ///
  /// The boolean [isExpanded] arguments must not be null.
  ///
  /// The [autofocus] argument must not be null.
  ArnaDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.hint,
    this.disabledHint,
    required this.onChanged,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.enableFeedback,
  }) : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((final ArnaDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [ArnaDropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [ArnaDropdownButton]s were detected '
          'with the same value',
        );

  /// The list of items the user can select.
  ///
  /// If the [onChanged] callback is null or the list of items is null then the dropdown button will be disabled.
  final List<ArnaDropdownMenuItem<T>>? items;

  /// The value of the currently selected [ArnaDropdownMenuItem].
  ///
  /// If [value] is null and the button is enabled, [hint] will be displayed if it is non-null.
  ///
  /// If [value] is null and the button is disabled, [disabledHint] will be displayed if it is non-null. If
  /// [disabledHint] is null, then [hint] will be displayed if it is non-null.
  final T? value;

  /// A placeholder widget that is displayed by the dropdown button.
  ///
  /// If [value] is null and the dropdown is enabled ([items] and [onChanged] are non-null), this widget is displayed
  /// as a placeholder for the dropdown button's value.
  ///
  /// If [value] is null and the dropdown is disabled and [disabledHint] is null, this text is used as the placeholder.
  final Widget? hint;

  /// A preferred placeholder text that is displayed when the dropdown is disabled.
  ///
  /// If [value] is null, the dropdown is disabled ([items] or [onChanged] is null), this text is displayed as a
  /// placeholder for the dropdown button's value.
  final Widget? disabledHint;

  /// Called when the user selects an item.
  ///
  /// If the [onChanged] callback is null or the list of [ArnaDropdownButton.items] is null then the dropdown button
  /// will be disabled. A disabled button will display the [ArnaDropdownButton.disabledHint] widget if it is non-null.
  /// If [ArnaDropdownButton.disabledHint] is also null but [ArnaDropdownButton.hint] is non-null,
  /// [ArnaDropdownButton.hint] will instead be displayed.
  final ValueChanged<T?>? onChanged;

  /// Called when the dropdown button is tapped.
  ///
  /// This is distinct from [onChanged], which is called when the user selects an item from the dropdown.
  ///
  /// The callback will not be invoked if the dropdown button is disabled.
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Whether this button should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the button.
  final MouseCursor cursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// By default, platform-specific feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  @override
  State<ArnaDropdownButton<T>> createState() => _ArnaDropdownButtonState<T>();
}

class _ArnaDropdownButtonState<T> extends State<ArnaDropdownButton<T>>
    with WidgetsBindingObserver {
  int? _selectedIndex;
  _ArnaDropdownRoute<T>? _dropdownRoute;
  Orientation? _lastOrientation;
  FocusNode? _internalNode;
  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  bool _hasPrimaryFocus = false;

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    focusNode!.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeDropdownRoute();
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _removeDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  void _handleFocusChanged() {
    if (_hasPrimaryFocus != focusNode!.hasPrimaryFocus) {
      setState(() => _hasPrimaryFocus = focusNode!.hasPrimaryFocus);
    }
  }

  @override
  void didUpdateWidget(final ArnaDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (widget.focusNode == null) {
        _internalNode ??= _createFocusNode();
      }
      _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      focusNode!.addListener(_handleFocusChanged);
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null &&
            widget.items!
                .where(
                  (final ArnaDropdownMenuItem<T> item) =>
                      item.enabled && item.value == widget.value,
                )
                .isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(
      widget.items!
              .where(
                (final ArnaDropdownMenuItem<T> item) =>
                    item.value == widget.value,
              )
              .length ==
          1,
    );
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  TextStyle? get _textStyle => ArnaTheme.of(context).textTheme.button;

  void _handleTap(final Color accentColor) {
    final TextDirection? textDirection = Directionality.maybeOf(context);

    final List<_ArnaMenuItem<T>> menuItems = <_ArnaMenuItem<T>>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _ArnaMenuItem<T>(
          item: widget.items![index],
          onLayout: (final Size size) {
            // If [_dropdownRoute] is null and onLayout is called, this means that performLayout was called on a
            // [_ArnaDropdownRoute] that has not left the widget tree but is already on its way out.
            //
            // Since onLayout is used primarily to collect the desired heights of each menu item before laying them
            // out, not having the [_ArnaDropdownRoute] collect each item's height to lay out is fine since the route
            // is already on its way out.
            if (_dropdownRoute == null) {
              return;
            }
            _dropdownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator = Navigator.of(context);
    assert(_dropdownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(
          Offset.zero,
          ancestor: navigator.context.findRenderObject(),
        ) &
        itemBox.size;
    _dropdownRoute = _ArnaDropdownRoute<T>(
      items: menuItems,
      buttonRect:
          Styles.menuMargin.resolve(textDirection).inflateRect(itemRect),
      selectedIndex: _selectedIndex ?? 0,
      accentColor: accentColor,
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      enableFeedback: widget.enableFeedback ?? true,
    );

    focusNode?.requestFocus();
    navigator
        .push(_dropdownRoute!)
        .then<void>((final _ArnaDropdownRouteResult<T>? newValue) {
      _removeDropdownRoute();
      if (!mounted || newValue == null) {
        return;
      }
      widget.onChanged?.call(newValue.result);
    });

    widget.onTap?.call();
  }

  bool get _enabled =>
      widget.items != null &&
      widget.items!.isNotEmpty &&
      widget.onChanged != null;

  Orientation _getOrientation(final BuildContext context) {
    Orientation? result = MediaQuery.maybeOf(context)?.orientation;
    if (result == null) {
      // If there's no MediaQuery, then use the window aspect to determine orientation.
      final Size size = WidgetsBinding.instance.window.physicalSize;
      result = size.width > size.height
          ? Orientation.landscape
          : Orientation.portrait;
    }
    return result;
  }

  @override
  Widget build(final BuildContext context) {
    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeDropdownRoute();
      _lastOrientation = newOrientation;
    }

    // The width of the button and the menu are defined by the widest item and the width of the hint.
    // We should explicitly type the items list to be a list of <Widget>, otherwise, no explicit type adding items
    // maybe trigger a crash/failure when hint and selectedItemBuilder are provided.
    final List<Widget> items =
        widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[];

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      Widget displayedHint =
          _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;
      displayedHint = _ArnaDropdownMenuItemContainer(child: displayedHint);

      hintIndex = items.length;
      items.add(
        DefaultTextStyle(
          style: _textStyle!,
          child: IgnorePointer(
            ignoringSemantics: false,
            child: displayedHint,
          ),
        ),
      );
    }

    // If value is null (then _selectedIndex is null) then we display the hint or nothing at all.
    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = Container();
    } else {
      innerItemsWidget = IndexedStack(
        index: _selectedIndex ?? hintIndex,
        alignment: AlignmentDirectional.centerStart,
        children: items.map((final Widget item) {
          return SizedBox(height: Styles.menuItemSize, child: item);
        }).toList(),
      );
    }

    final Color disabledColor = ArnaColors.disabledColor.resolveFrom(context);
    final Color iconColor = ArnaColors.iconColor.resolveFrom(context);
    final Color buttonColor = ArnaColors.buttonColor.resolveFrom(context);
    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;

    return Semantics(
      button: true,
      child: Padding(
        padding: Styles.small,
        child: ArnaBaseWidget(
          builder: (
            final BuildContext context,
            bool enabled,
            final bool hover,
            final bool focused,
            final bool pressed,
            final bool selected,
          ) {
            enabled = _enabled;
            return AnimatedContainer(
              height: Styles.buttonSize,
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                border: Border.all(
                  color: focused
                      ? ArnaDynamicColor.outerColor(accent)
                      : ArnaColors.borderColor.resolveFrom(context),
                ),
                color: !enabled
                    ? ArnaColors.backgroundColor.resolveFrom(context)
                    : pressed || hover
                        ? ArnaDynamicColor.applyOverlay(buttonColor)
                        : buttonColor,
              ),
              padding: Styles.horizontal,
              child: IconTheme(
                data: IconThemeData(color: enabled ? iconColor : disabledColor),
                child: DefaultTextStyle(
                  style: enabled
                      ? _textStyle!
                      : _textStyle!.copyWith(color: disabledColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      innerItemsWidget,
                      const Padding(
                        padding: ArnaEdgeInsets.start(Styles.padding),
                        child: Icon(Icons.arrow_drop_down_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          onPressed: _enabled ? () => _handleTap(accent) : null,
          showAnimation: _enabled,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          cursor: widget.cursor,
          isFocusable: _enabled,
          enableFeedback: false,
        ),
      ),
    );
  }
}
