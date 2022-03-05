import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;
import 'package:flutter/rendering.dart';

/// A base class for entries in popup menu.
///
/// The popup menu widget uses this interface to interact with the menu items.
/// To show a popup menu, use the [showArnaMenu] function. To create a button
/// that shows a popup menu, consider using [ArnaPopupMenuButton].
///
/// The type `T` is the type of the value(s) the entry represents. All the
/// entries in a given menu must represent values with consistent types.
///
/// An [ArnaPopupMenuEntry] may represent multiple values, for example a row
/// with several icons, or a single entry, for example a menu item with an icon
/// (see [ArnaPopupMenuItem]), or no value at all (for example,
/// [ArnaPopupMenuDivider]).
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given location.
///  * [ArnaPopupMenuButton], an [ArnaIconButton] that automatically shows a menu when
///    it is tapped.
abstract class ArnaPopupMenuEntry<T> extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ArnaPopupMenuEntry({Key? key}) : super(key: key);

  /// The amount of vertical space occupied by this entry.
  ///
  /// This value is used at the time the [showArnaMenu] method is called, if the
  /// `initialValue` argument is provided, to determine the position of this
  /// entry when aligning the selected entry over the given `position`. It is
  /// otherwise ignored.
  double get height;

  /// Whether this entry represents a particular value.
  ///
  /// This method is used by [showArnaMenu], when it is called, to align the entry
  /// representing the `initialValue`, if any, to the given `position`, and then
  /// later is called on each entry to determine if it should be highlighted.
  /// If `initialValue` is null, then this method is not called.
  ///
  /// If the [ArnaPopupMenuEntry] represents a single value, this should return true
  /// if the argument matches that value. If it represents multiple values, it
  /// should return true if the argument matches any of them.
  bool represents(T? value);
}

/// A horizontal divider in popup menu.
///
/// This widget adapts the [ArnaHorizontalSeparator] for use in popup menus.
///
/// See also:
///
///  * [ArnaPopupMenuItem], for the kinds of items that this widget divides.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given
///    location.
///  * [ArnaPopupMenuButton], an [ArnaIconButton] that automatically shows a
///    menu when it is tapped.
class ArnaPopupMenuDivider extends ArnaPopupMenuEntry<Never> {
  /// Creates a horizontal divider for a popup menu.
  const ArnaPopupMenuDivider({
    Key? key,
  })  : height = (Styles.smallPadding * 2) + 1,
        super(key: key);

  /// The height of the divider entry.
  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<ArnaPopupMenuDivider> createState() => _ArnaPopupMenuDividerState();
}

class _ArnaPopupMenuDividerState extends State<ArnaPopupMenuDivider> {
  @override
  Widget build(BuildContext context) => const ArnaHorizontalSeparator();
}

// This widget only exists to enable _PopupMenuRoute to save the sizes of
// each menu item. The sizes are used by _PopupMenuRouteLayout to compute the
// y coordinate of the menu's origin so that the center of selected menu
// item lines up with the center of its PopupMenuButton.
class _ArnaMenuItem extends SingleChildRenderObjectWidget {
  const _ArnaMenuItem({
    Key? key,
    required this.onLayout,
    required Widget? child,
  }) : super(key: key, child: child);

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderArnaMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderArnaMenuItem renderObject,
  ) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderArnaMenuItem extends RenderShiftedBox {
  _RenderArnaMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) return Size.zero;
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

/// An item in popup menu.
///
/// To show a popup menu, use the [showArnaMenu] function. To create a button
/// that shows a popup menu, consider using [ArnaPopupMenuButton].
///
/// Typically the [child] of a [ArnaPopupMenuItem] is a [Text] widget.
///
/// {@tool snippet}
///
/// Here, a [Text] widget is used with a popup menu item. The `WhyFarther` type
/// is an enum, not shown here.
///
/// ```dart
/// const ArnaPopupMenuItem<WhyFarther>(
///   value: WhyFarther.harder,
///   child: Text('Working a lot harder'),
/// )
/// ```
/// {@end-tool}
///
/// See the example at [ArnaPopupMenuButton] for how this example could be used in a
/// complete menu.
///
/// See also:
///
///  * [ArnaPopupMenuDivider], which can be used to divide items from each other.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given location.
///  * [ArnaPopupMenuButton], an [ArnaIconButton] that automatically shows a menu when
///    it is tapped.
class ArnaPopupMenuItem<T> extends ArnaPopupMenuEntry<T> {
  /// Creates an item for a popup menu.
  ///
  /// By default, the item is [enabled].
  ///
  /// The `enabled` and `height` arguments must not be null.
  const ArnaPopupMenuItem({
    Key? key,
    this.value,
    this.onTap,
    this.enabled = true,
    this.selected = false,
    this.height = Styles.menuItemSize,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    required this.child,
  }) : super(key: key);

  /// The value that will be returned by [showArnaMenu] if this entry is selected.
  final T? value;

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Whether the user is permitted to select this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  /// Whether the menu item is selected or not.
  ///
  /// Defaults to false.
  final bool selected;

  /// The minimum height of the menu item.
  @override
  final double height;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// menu item.
  final MouseCursor cursor;

  /// The widget below this widget in the tree.
  ///
  /// Typically a single-line [ArnaListTile] (for menus with icons) or a [Text].
  /// The text should be short enough that it won't wrap.
  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  ArnaPopupMenuItemState<T, ArnaPopupMenuItem<T>> createState() =>
      ArnaPopupMenuItemState<T, ArnaPopupMenuItem<T>>();
}

// The [State] for [ArnaPopupMenuItem] subclasses.
///
/// The [buildChild] method can be overridden to adjust exactly what gets placed
/// in the menu. By default it returns [ArnaPopupMenuItem.child].
///
/// The [handleTap] method can be overridden to adjust exactly what happens when
/// the item is tapped. By default, it uses [Navigator.pop] to return the
/// [PopupMenuItem.value] from the menu route.
///
/// This class takes two type arguments. The second, `W`, is the exact type of
/// the [Widget] that is using this [State]. It must be a subclass of
/// [ArnaPopupMenuItem]. The first, `T`, must match the type argument of that widget
/// class, and is the type of values returned from this menu.
class ArnaPopupMenuItemState<T, W extends ArnaPopupMenuItem<T>>
    extends State<W> {
  /// The menu item contents.
  ///
  /// Used by the [build] method.
  ///
  /// By default, this returns [ArnaPopupMenuItem.child]. Override this to put
  /// something else in the menu entry.
  @protected
  Widget? buildChild() => widget.child;

  /// The handler for when the user selects the menu item.
  ///
  /// By default, uses [Navigator.pop] to return the [ArnaPopupMenuItem.value] from
  /// the menu route.
  @protected
  void handleTap() {
    widget.onTap?.call();
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;
    return ArnaBaseButton(
      builder: (context, enabled, hover, focused, pressed, selected) {
        enabled = widget.enabled;
        selected = widget.selected;
        return AnimatedContainer(
          height: widget.height,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: Styles.borderRadius,
            border: Border.all(
              color: ArnaDynamicColor.resolve(
                selected ? accent : ArnaColors.color00,
                context,
              ),
            ),
            color: ArnaDynamicColor.resolve(
              !enabled
                  ? ArnaColors.backgroundColor
                  : pressed
                      ? ArnaColors.cardPressedColor
                      : hover
                          ? ArnaColors.cardHoverColor
                          : ArnaColors.cardColor,
              context,
            ),
          ),
          padding: Styles.horizontal,
          child: Center(child: buildChild()),
        );
      },
      showAnimation: false,
      onPressed: widget.enabled ? handleTap : null,
    );
  }
}

class _ArnaPopupMenu<T> extends StatelessWidget {
  const _ArnaPopupMenu({
    Key? key,
    required this.route,
    required this.semanticLabel,
  }) : super(key: key);

  final _ArnaPopupMenuRoute<T> route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final double unit = 1.0 /
        (route.items.length +
            1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < route.items.length; i += 1) {
      final double start = (i + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );
      children.add(
        _ArnaMenuItem(
          onLayout: (Size size) => route.itemSizes[i] = size,
          child: FadeTransition(opacity: opacity, child: route.items[i]),
        ),
      );
    }

    final CurveTween opacity = CurveTween(
      curve: const Interval(0.0, 1.0 / 3.0),
    );
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height = CurveTween(
      curve: Interval(0.0, unit * route.items.length),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.03),
            end: Offset.zero,
          ).animate(route.animation!),
          child: FadeTransition(
            opacity: opacity.animate(route.animation!),
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(route.animation!),
              heightFactor: height.evaluate(route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: Styles.menuMinWidth,
          maxWidth: Styles.menuMaxWidth,
        ),
        child: IntrinsicWidth(
          stepWidth: Styles.menuItemSize,
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: semanticLabel,
            child: AnimatedContainer(
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: Styles.borderRadius,
                border: Border.all(
                  color: ArnaDynamicColor.resolve(
                    ArnaColors.borderColor,
                    context,
                  ),
                ),
                color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
              ),
              child: SingleChildScrollView(
                padding: Styles.small,
                child: ListBody(children: children),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Positioning of the menu on the screen.
class _ArnaPopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _ArnaPopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.selectedItemIndex,
    this.textDirection,
    this.padding,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // The index of the selected item, or null if ArnaPopupMenuButton.initialValue
  // was not specified.
  final int? selectedItemIndex;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by [Styles.padding].
  // If necessary, we adjust the child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus [Styles.padding]
    // pixels in each direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(Styles.padding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    final double buttonHeight = size.height - position.top - position.bottom;
    // Find the ideal vertical position.
    double y = position.top;
    if (selectedItemIndex != null) {
      double selectedItemOffset = Styles.padding;
      for (int index = 0; index < selectedItemIndex!; index += 1) {
        selectedItemOffset += itemSizes[index]!.height;
      }
      selectedItemOffset += itemSizes[selectedItemIndex!]!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    // Avoid going outside an area defined as the rectangle [Styles.padding]
    // pixels from the edge of the screen in every direction.
    if (x < Styles.padding + padding.left) {
      x = Styles.padding + padding.left;
    } else if (x + childSize.width >
        size.width - Styles.padding - padding.right) {
      x = size.width - childSize.width - Styles.padding - padding.right;
    }
    if (y < Styles.padding + padding.top) {
      y = Styles.padding + padding.top;
    } else if (y + childSize.height >
        size.height - Styles.padding - padding.bottom) {
      y = size.height - padding.bottom - Styles.padding - childSize.height;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_ArnaPopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        selectedItemIndex != oldDelegate.selectedItemIndex ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding;
  }
}

class _ArnaPopupMenuRoute<T> extends PopupRoute<T> {
  _ArnaPopupMenuRoute({
    required this.position,
    required this.items,
    this.initialValue,
    required this.barrierLabel,
    this.semanticLabel,
    this.color,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<ArnaPopupMenuEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final String? semanticLabel;
  final Color? color;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Styles.basicCurve,
    );
  }

  @override
  Duration get transitionDuration => Styles.basicDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0;
          selectedItemIndex == null && index < items.length;
          index += 1) {
        if (items[index].represents(initialValue)) selectedItemIndex = index;
      }
    }

    final Widget menu = _ArnaPopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _ArnaPopupMenuRouteLayout(
              position,
              itemSizes,
              selectedItemIndex,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: menu,
          );
        },
      ),
    );
  }
}

/// Show a popup menu that contains the `items` at `position`.
///
/// `items` should be non-null and not empty.
///
/// If `initialValue` is specified then the first item with a matching value
/// will be highlighted and the value of `position` gives the rectangle whose
/// vertical center will be aligned with the vertical center of the highlighted
/// item (when possible).
///
/// If `initialValue` is not specified then the top of the menu will be aligned
/// with the top of the `position` rectangle.
///
/// In both cases, the menu position will be adjusted if necessary to fit on the
/// screen.
///
/// Horizontally, the menu is positioned so that it grows in the direction that
/// has the most room. For example, if the `position` describes a rectangle on
/// the left edge of the screen, then the left edge of the menu is aligned with
/// the left edge of the `position`, and the menu grows to the right. If both
/// edges of the `position` are equidistant from the opposite edge of the
/// screen, then the ambient [Directionality] is used as a tie-breaker,
/// preferring to grow in the reading direction.
///
/// The positioning of the `initialValue` at the `position` is implemented by
/// iterating over the `items` to find the first whose
/// [ArnaPopupMenuEntry.represents] method returns true for `initialValue`, and then
/// summing the values of [ArnaPopupMenuEntry.height] for all the preceding widgets
/// in the list.
///
/// The `context` argument is used to look up the [Navigator] for the menu.
/// It is only used when the method is called. Its corresponding widget can be
/// safely removed from the tree before the popup menu is closed.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// menu to the [Navigator] furthest from or nearest to the given `context`. It
/// is `false` by default.
///
/// The `semanticLabel` argument is used by accessibility frameworks to
/// announce screen transitions when the menu is opened and closed. If this
/// label is not provided, it will default to
/// [MaterialLocalizations.popupMenuLabel].
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [ArnaPopupMenuButton], which provides an [ArnaIconButton] that shows a menu by
///    calling this method automatically.
///  * [SemanticsConfiguration.namesRoute], for a description of edge triggered
///    semantics.
Future<T?> showArnaMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<ArnaPopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
}) {
  assert(items.isNotEmpty);

  semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;

  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  return navigator.push(
    _ArnaPopupMenuRoute<T>(
      position: position,
      items: items,
      initialValue: initialValue,
      semanticLabel: semanticLabel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      color: color,
    ),
  );
}

/// Signature for the callback invoked when a menu item is selected. The
/// argument is the value of the [ArnaPopupMenuItem] that caused its menu to be
/// dismissed.
///
/// Used by [ArnaPopupMenuButton.onSelected].
typedef ArnaPopupMenuItemSelected<T> = void Function(T value);

/// Signature for the callback invoked when a [ArnaPopupMenuButton] is dismissed
/// without selecting an item.
///
/// Used by [ArnaPopupMenuButton.onCanceled].
typedef ArnaPopupMenuCanceled = void Function();

/// Signature used by [ArnaPopupMenuButton] to lazily construct the items shown when
/// the button is pressed.
///
/// Used by [ArnaPopupMenuButton.itemBuilder].
typedef ArnaPopupMenuItemBuilder<T> = List<ArnaPopupMenuEntry<T>> Function(
  BuildContext context,
);
