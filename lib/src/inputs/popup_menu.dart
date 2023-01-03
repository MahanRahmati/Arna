import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// Used to configure how the [ArnaPopupMenuButton] positions its popup menu.
enum ArnaPopupMenuPosition {
  /// Menu is positioned over the anchor.
  over,

  /// Menu is positioned under the anchor.
  under,
}

/// A base class for entries in popup menu.
///
/// The popup menu widget uses this interface to interact with the menu items.
/// To show a popup menu, use the [showArnaMenu] function. To create a button
/// that shows a popup menu, consider using [ArnaPopupMenuButton].
///
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal
///    line.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given
///    location.
///  * [ArnaPopupMenuButton], an [ArnaButton.icon] that automatically shows a
///    menu when it is tapped.
abstract class ArnaPopupMenuEntry extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to
  /// provide const constructors so that they can be used in const expressions.
  const ArnaPopupMenuEntry({super.key});
}

/// A horizontal divider in popup menu.
///
/// This widget adapts the [ArnaDivider] for use in popup menus.
///
/// See also:
///
///  * [ArnaPopupMenuItem], for the kinds of items that this widget divides.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given
///    location.
///  * [ArnaPopupMenuButton], an [ArnaButton.icon] that automatically shows a
///    menu when it is tapped.
class ArnaPopupMenuDivider extends ArnaPopupMenuEntry {
  /// Creates a horizontal divider for a popup menu.
  const ArnaPopupMenuDivider({super.key});

  @override
  State<ArnaPopupMenuDivider> createState() => _ArnaPopupMenuDividerState();
}

/// The [State] for an [ArnaPopupMenuDivider].
class _ArnaPopupMenuDividerState extends State<ArnaPopupMenuDivider> {
  @override
  Widget build(final BuildContext context) {
    return const Padding(
      padding: Styles.popupMenuDividerPadding,
      child: ArnaDivider(),
    );
  }
}

/// An item in popup menu.
///
/// To show a popup menu, use the [showArnaMenu] function. To create a button
/// that shows a popup menu, consider using [ArnaPopupMenuButton].
///
/// See also:
///
///  * [ArnaPopupMenuDivider], which can be used to divide items from each other.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given
///    location.
///  * [ArnaPopupMenuButton], an [ArnaButton.icon] that automatically shows a
///    menu when it is tapped.
class ArnaPopupMenuItem extends ArnaPopupMenuEntry {
  /// Creates an item for a popup menu.
  ///
  /// By default, the item is [enabled].
  const ArnaPopupMenuItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding = Styles.popupItemPadding,
    this.leadingToTitle = Styles.largePadding,
    this.enabled = true,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// A widget displayed at the start of the [ArnaPopupMenuItem]. This is
  /// typically [Icon] or an [Image].
  final Widget? leading;

  /// A [title] is used to convey the central information.
  final String title;

  /// A [subtitle] is used to display additional information. It is located
  /// below [title].
  final String? subtitle;

  /// A widget displayed at the end of the [ArnaPopupMenuItem]. This is usually
  /// an [Icon].
  final Widget? trailing;

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Padding of the content inside [ArnaPopupMenuItem].
  final EdgeInsetsGeometry? padding;

  /// The horizontal space between [leading] widget and [title].
  final double leadingToTitle;

  /// Whether this menu item is interactive.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// menu item.
  final MouseCursor cursor;

  /// The semantic label of the menu item.
  final String? semanticLabel;

  @override
  State<ArnaPopupMenuItem> createState() => _ArnaPopupMenuItemState();
}

// The [State] for [ArnaPopupMenuItem] subclasses.
class _ArnaPopupMenuItemState extends State<ArnaPopupMenuItem> {
  FocusNode? focusNode;
  bool _focused = false;
  late Map<Type, Action<Intent>> _actions;
  late Map<ShortcutActivator, Intent> _shortcuts;

  bool get _isEnabled => widget.enabled && widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _actions = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<Intent>(onInvoke: (final _) => handleTap())
    };
    _shortcuts = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    };
    focusNode = FocusNode(canRequestFocus: _isEnabled);
    if (widget.autofocus) {
      focusNode!.requestFocus();
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  void _handleFocusChange(final bool hasFocus) {
    if (mounted) {
      setState(() => _focused = hasFocus);
    }
  }

  void _handleFocus(final bool focus) {
    if (focus != _focused && mounted) {
      setState(() => _focused = focus);
    }
  }

  /// The handler for when the user selects the menu item.
  ///
  /// By default, uses [Navigator.pop].
  void handleTap() {
    Navigator.pop(context);
    widget.onTap?.call();
  }

  @override
  Widget build(final BuildContext context) {
    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;
    return FocusableActionDetector(
      enabled: _isEnabled && widget.isFocusable,
      focusNode: focusNode,
      autofocus: _isEnabled && widget.autofocus,
      onShowFocusHighlight: _handleFocus,
      onFocusChange: _handleFocusChange,
      actions: _actions,
      shortcuts: _shortcuts,
      child: AnimatedContainer(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          border: Border.all(
            color: _isEnabled && _focused
                ? ArnaDynamicColor.resolve(
                    ArnaDynamicColor.matchingColor(
                      accent,
                      ArnaTheme.brightnessOf(context),
                    ),
                    context,
                  )
                : ArnaColors.transparent,
          ),
        ),
        child: ClipRRect(
          borderRadius: Styles.listBorderRadius,
          child: ArnaListTile(
            leading: widget.leading ??
                const SizedBox.square(dimension: Styles.iconSize),
            title: widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing,
            onTap: _isEnabled ? handleTap : null,
            padding: widget.padding,
            leadingToTitle: widget.leadingToTitle,
            cursor: widget.cursor,
            semanticLabel: widget.semanticLabel,
          ),
        ),
      ),
    );
  }
}

/// _ArnaPopupMenu class.
class _ArnaPopupMenu extends StatelessWidget {
  /// Creates an ArnaPopupMenu.
  const _ArnaPopupMenu({
    required this.route,
    required this.semanticLabel,
  });

  /// The route of the menu.
  final _ArnaPopupMenuRoute route;

  /// The semantic label of the menu.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < route.items.length; i += 1) {
      children.add(
        route.items[i],
      );
    }

    final CurveTween opacity = CurveTween(
      curve: const Interval(0.0, 1.0 / 3.0),
    );

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (final BuildContext context, final Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: ScaleTransition(
            alignment: Alignment.topRight,
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(
                parent: route.animation!,
                curve: Styles.basicCurve,
              ),
            ),
            child: child,
          ),
        );
      },
      child: ArnaCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: Styles.listBorderRadius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: Styles.menuMinWidth,
              maxWidth: Styles.menuMaxWidth,
            ),
            child: IntrinsicWidth(
              stepWidth: Styles.base,
              child: Semantics(
                scopesRoute: true,
                namesRoute: true,
                explicitChildNodes: true,
                label: semanticLabel,
                child: SingleChildScrollView(
                  child: ListBody(children: children),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Positioning of the menu on the screen.
class _ArnaPopupMenuRouteLayout extends SingleChildLayoutDelegate {
  /// Creates an ArnaPopupMenuRouteLayout.
  _ArnaPopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  /// Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  /// The sizes of each item are computed when the menu is laid out, and before
  /// the route is laid out.
  List<Size?> itemSizes;

  /// Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  /// The padding of unsafe area.
  EdgeInsets padding;

  /// List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  /// We put the child wherever position specifies, so long as it will fit
  /// within the specified parent size padded (inset) by [Styles.padding]. If
  /// necessary, we adjust the child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(final BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus [Styles.padding]
    // pixels in each direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(Styles.padding) + padding,
    );
  }

  @override
  Offset getPositionForChild(final Size size, final Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    final double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned
      // to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned
      // to the left edge.
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
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(
      Offset.zero & size,
      avoidBounds,
    );
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(final Iterable<Rect> screens, final Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(
    final Rect screen,
    final Size childSize,
    final Offset wantedPosition,
  ) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + Styles.padding + padding.left) {
      x = screen.left + Styles.padding + padding.left;
    } else if (x + childSize.width >
        screen.right - Styles.padding - padding.right) {
      x = screen.right - childSize.width - Styles.padding - padding.right;
    }
    if (y < screen.top + Styles.padding + padding.top) {
      y = Styles.padding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - Styles.padding - padding.bottom) {
      y = screen.bottom - childSize.height - Styles.padding - padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(final _ArnaPopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then we
    // expect them to have the same length because there's no practical way to
    // change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

/// _ArnaPopupMenuRoute class.
class _ArnaPopupMenuRoute extends PopupRoute<Never> {
  /// Creates an ArnaPopupMenuRoute.
  _ArnaPopupMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    this.semanticLabel,
    this.color,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  /// position
  final RelativeRect position;

  /// items
  final List<ArnaPopupMenuEntry> items;

  /// itemSizes
  final List<Size?> itemSizes;

  /// semanticLabel
  final String? semanticLabel;

  /// color
  final Color? color;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Styles.basicCurve,
      reverseCurve: const Interval(0.0, 2.0 / 3.0),
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
  Widget buildPage(
    final BuildContext context,
    final Animation<double> animation,
    final _,
  ) {
    final Widget menu = _ArnaPopupMenu(
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
        builder: (final BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _ArnaPopupMenuRouteLayout(
              position,
              itemSizes,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
            child: menu,
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(final MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

/// Show a popup menu that contains the [items] at [position].
///
/// [items] should be non-null and not empty.
///
/// The menu position will be adjusted if necessary to fit on the screen.
///
/// Horizontally, the menu is positioned so that it grows in the direction that
/// has the most room. For example, if the [position] describes a rectangle on
/// the left edge of the screen, then the left edge of the menu is aligned with
/// the left edge of the [position], and the menu grows to the right. If both
/// edges of the [position] are equidistant from the opposite edge of the
/// screen, then the ambient [Directionality] is used as a tie-breaker,
/// preferring to grow in the reading direction.
///
/// The [context] argument is used to look up the [Navigator] for the menu. It
/// is only used when the method is called. Its corresponding widget can be
/// safely removed from the tree before the popup menu is closed.
///
/// The [useRootNavigator] argument is used to determine whether to push the
/// menu to the [Navigator] furthest from or nearest to the given [context].
/// It is `false` by default.
///
/// The [semanticLabel] argument is used by accessibility frameworks to announce
/// screen transitions when the menu is opened and closed. If this label is not
/// provided, it will default to [MaterialLocalizations.popupMenuLabel].
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal
///    line.
///  * [ArnaPopupMenuButton], which provides an [ArnaButton.icon] that shows a
///    menu by  calling this method automatically.
///  * [SemanticsConfiguration.namesRoute], for a description of edge triggered
///    semantics.
Future<T?> showArnaMenu<T>({
  required final BuildContext context,
  required final RelativeRect position,
  required final List<ArnaPopupMenuEntry> items,
  final String? semanticLabel,
  final Color? color,
  final bool useRootNavigator = false,
}) {
  assert(items.isNotEmpty);

  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  return navigator.push(
    _ArnaPopupMenuRoute(
      position: position,
      items: items,
      semanticLabel:
          semanticLabel ?? MaterialLocalizations.of(context).popupMenuLabel,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      color: color,
    ),
  );
}

/// Signature used by [ArnaPopupMenuButton] to lazily construct the items shown
/// when the button is pressed.
///
/// Used by [ArnaPopupMenuButton.itemBuilder].
typedef ArnaPopupMenuItemBuilder = List<ArnaPopupMenuEntry> Function(
  BuildContext context,
);

/// Displays a menu when pressed.
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal
///    line.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given location.
class ArnaPopupMenuButton extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const ArnaPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.icon,
    this.onOpened,
    this.onClosed,
    this.offset = Offset.zero,
    this.enabled = true,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.position = ArnaPopupMenuPosition.under,
  });

  /// Called when the button is pressed to create the items to show in the menu.
  final ArnaPopupMenuItemBuilder itemBuilder;

  /// The icon of the button.
  final IconData? icon;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user dismisses the popup menu .
  final VoidCallback? onClosed;

  /// The offset is applied relative to the initial position set by the
  /// [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;

  /// Whether this button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button will not respond to presses or show the popup menu
  /// and [onOpened], [onClosed] will not be called.
  final bool enabled;

  /// Text that describes the action that will occur when the button is pressed.
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

  /// Whether the popup menu is positioned over or under the popup menu button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// When not set, the position defaults to [ArnaPopupMenuPosition.over] which
  /// makes the popup menu appear directly over the button that was used to
  /// create it.
  final ArnaPopupMenuPosition position;

  @override
  State<ArnaPopupMenuButton> createState() => ArnaPopupMenuButtonState();
}

/// The [State] for an [ArnaPopupMenuButton].
///
/// See [showArnaButtonMenu] for a way to programmatically open the popup menu
/// of your button state.
class ArnaPopupMenuButtonState extends State<ArnaPopupMenuButton> {
  /// A method to show a popup menu with the items supplied to
  /// [ArnaPopupMenuButton.itemBuilder] at the position of your
  /// [ArnaPopupMenuButton].
  ///
  /// By default, it is called when the user taps the button and
  /// [ArnaPopupMenuButton.enabled] is set to `true`. Moreover, you can open
  /// the button by calling the method manually.
  ///
  /// You would access your [ArnaPopupMenuButtonState] using a [GlobalKey] and
  /// show the menu of the button with
  /// `globalKey.currentState.showArnaButtonMenu`.
  void showArnaButtonMenu() {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset;
    switch (widget.position) {
      case ArnaPopupMenuPosition.over:
        offset = widget.offset;
        break;
      case ArnaPopupMenuPosition.under:
        offset = Offset(0.0, button.size.height) + widget.offset;
        break;
    }
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    final List<ArnaPopupMenuEntry> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      widget.onOpened?.call();
      showArnaMenu(
        context: context,
        items: items,
        position: position,
        color: widget.accentColor ?? ArnaTheme.of(context).accentColor,
      );
      widget.onClosed?.call();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ArnaButton.icon(
      icon: widget.icon ?? Icons.more_vert_outlined,
      onPressed: widget.enabled ? showArnaButtonMenu : null,
      tooltipMessage: widget.tooltipMessage ??
          MaterialLocalizations.of(context).showMenuTooltip,
      buttonType: widget.buttonType,
      isFocusable: widget.isFocusable,
      autofocus: widget.autofocus,
      accentColor: widget.accentColor,
      cursor: widget.cursor,
      semanticLabel: widget.semanticLabel,
    );
  }
}
