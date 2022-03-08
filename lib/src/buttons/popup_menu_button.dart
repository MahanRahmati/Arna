import 'package:arna/arna.dart';

/// Displays a menu when pressed and calls [onSelected] when the menu is dismissed
/// because an item was selected. The value passed to [onSelected] is the value of
/// the selected menu item.
///
/// {@tool snippet}
///
/// This example shows a menu with four items, selecting between an enum's
/// values and setting a `_selection` field based on the selection.
///
/// ```dart
/// // This is the type used by the popup menu below.
/// enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
///
/// // This menu button widget updates a _selection field (of type WhyFarther,
/// // not shown here).
/// ArnaPopupMenuButton<WhyFarther>(
///   onSelected: (WhyFarther result) { setState(() { _selection = result; }); },
///   itemBuilder: (BuildContext context) => <ArnaPopupMenuEntry<WhyFarther>>[
///     const ArnaPopupMenuItem<WhyFarther>(
///       value: WhyFarther.harder,
///       child: Text('Working a lot harder'),
///     ),
///     const ArnaPopupMenuItem<WhyFarther>(
///       value: WhyFarther.smarter,
///       child: Text('Being a lot smarter'),
///     ),
///     const ArnaPopupMenuItem<WhyFarther>(
///       value: WhyFarther.selfStarter,
///       child: Text('Being a self-starter'),
///     ),
///     const ArnaPopupMenuItem<WhyFarther>(
///       value: WhyFarther.tradingCharter,
///       child: Text('Placed in charge of trading charter'),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaPopupMenuItem], a popup menu entry for a single value.
///  * [ArnaPopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [showArnaMenu], a method to dynamically show a popup menu at a given location.
class ArnaPopupMenuButton<T> extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const ArnaPopupMenuButton({
    Key? key,
    required this.itemBuilder,
    this.icon,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.enabled = true,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.hasBorder = true,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// Called when the button is pressed to create the items to show in the menu.
  final ArnaPopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
  final T? initialValue;

  /// The icon of the button.
  final IconData? icon;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final ArnaPopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final ArnaPopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

  /// Whether this button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button will not respond to presses or show the popup menu
  /// and [onSelected], [onCanceled] and [itemBuilder] will not be called.
  ///
  /// This can be useful in situations where the app needs to show the button,
  /// but doesn't currently have anything to show in the menu.
  final bool enabled;

  /// The type of the button.
  final ButtonType buttonType;

  /// Whether this button is focusable or not.
  final bool isFocusable;

  /// Whether this button should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  /// Whether this button has border or not.
  final bool hasBorder;

  /// The color of the button's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// button.
  final MouseCursor cursor;

  /// The semantic label of the button.
  final String? semanticLabel;

  @override
  ArnaPopupMenuButtonState<T> createState() => ArnaPopupMenuButtonState<T>();
}

/// The [State] for a [ArnaPopupMenuButton].
///
/// See [showArnaButtonMenu] for a way to programmatically open the popup menu
/// of your button state.
class ArnaPopupMenuButtonState<T> extends State<ArnaPopupMenuButton<T>> {
  /// A method to show a popup menu with the items supplied to
  /// [ArnaPopupMenuButton.itemBuilder] at the position of your [ArnaPopupMenuButton].
  ///
  /// By default, it is called when the user taps the button and [ArnaPopupMenuButton.enabled]
  /// is set to `true`. Moreover, you can open the button by calling the method manually.
  ///
  /// You would access your [ArnaPopupMenuButtonState] using a [GlobalKey] and
  /// show the menu of the button with `globalKey.currentState.showArnaButtonMenu`.
  void showArnaButtonMenu() {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      button.localToGlobal(
            button.size.bottomRight(Offset.zero),
            ancestor: overlay,
          ) &
          button.size,
      Offset.zero & overlay.size,
    );
    final List<ArnaPopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      showArnaMenu<T?>(
        context: context,
        items: items,
        initialValue: widget.initialValue,
        position: position,
      ).then<void>((T? newValue) {
        if (!mounted) return null;
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArnaIconButton(
      icon: widget.icon ?? Icons.more_vert_outlined,
      onPressed: widget.enabled ? showArnaButtonMenu : null,
      tooltipMessage: widget.tooltipMessage ??
          MaterialLocalizations.of(context).showMenuTooltip,
      buttonType: widget.buttonType,
      isFocusable: widget.isFocusable,
      autofocus: widget.autofocus,
      hasBorder: widget.hasBorder,
      accentColor: widget.accentColor ?? ArnaTheme.of(context).accentColor,
      cursor: widget.cursor,
      semanticLabel: widget.semanticLabel,
    );
  }
}
