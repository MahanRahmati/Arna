import 'package:arna/arna.dart';

class ArnaLinkedButtons extends StatelessWidget {
  /// Creates linked buttons.
  const ArnaLinkedButtons({Key? key, required this.buttons}) : super(key: key);

  /// The list of linked buttons.
  final List<ArnaLinkedButton> buttons;

  Widget _buildChild() {
    List<Widget> children = <Widget>[];
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));
    children.addAll(
      buttons.map((button) {
        int index = buttons.indexOf(button);
        bool first = index == 0 ? true : false;
        bool last = index == buttons.length - 1 ? true : false;
        return _ArnaLinked(button: button, first: first, last: last);
      }).toList(),
    );
    children.add(const SizedBox(height: Styles.buttonSize, width: 0.5));
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: Container(
        height: Styles.buttonSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: Styles.borderRadius,
          color: ArnaDynamicColor.resolve(ArnaColors.borderColor, context),
        ),
        child: _buildChild(),
      ),
    );
  }
}

class _ArnaLinked extends StatelessWidget {
  final ArnaLinkedButton button;
  final bool first;
  final bool last;

  const _ArnaLinked({
    Key? key,
    required this.button,
    required this.first,
    required this.last,
  }) : super(key: key);

  Widget _buildChild(BuildContext context, bool enabled) {
    final List<Widget> children = <Widget>[];
    if (button.icon != null) {
      Widget iconWidget = Icon(
        button.icon,
        size: Styles.iconSize,
        color: ArnaDynamicColor.resolve(
          !enabled ? ArnaColors.disabledColor : ArnaColors.iconColor,
          context,
        ),
      );
      children.add(iconWidget);
      if (button.label != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    if (button.label != null) {
      Widget labelWidget = Flexible(
        child: Text(
          button.label!,
          style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
                color: ArnaDynamicColor.resolve(
                  !enabled
                      ? ArnaColors.disabledColor
                      : ArnaColors.primaryTextColor,
                  context,
                ),
              ),
        ),
      );
      children.add(labelWidget);
      if (button.icon != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    return ArnaBaseWidget(
      builder: (context, enabled, hover, focused, pressed, selected) {
        return AnimatedContainer(
          height: Styles.buttonSize - 2,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: first
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : const Radius.circular(0),
              right: last
                  ? const Radius.circular(Styles.borderRadiusSize - 1)
                  : const Radius.circular(0),
            ),
            border: focused
                ? Border.all(
                    color: ArnaDynamicColor.matchingColor(
                      ArnaDynamicColor.resolve(
                        ArnaColors.buttonColor,
                        context,
                      ),
                      button.accentColor ?? ArnaTheme.of(context).accentColor,
                      ArnaTheme.brightnessOf(context),
                    ),
                  )
                : Border.all(color: ArnaColors.transparent),
            color: ArnaDynamicColor.resolve(
              !enabled
                  ? ArnaColors.backgroundColor
                  : pressed
                      ? ArnaDynamicColor.blend(
                          ArnaDynamicColor.resolve(
                            ArnaColors.buttonColor,
                            context,
                          ),
                          14,
                        )
                      : hover
                          ? ArnaDynamicColor.blend(
                              ArnaDynamicColor.resolve(
                                ArnaColors.buttonColor,
                                context,
                              ),
                              14,
                            )
                          : ArnaColors.buttonColor,
              context,
            ),
          ),
          margin: const EdgeInsets.all(0.5),
          padding: button.icon != null
              ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1)
              : Styles.largeHorizontal,
          child: _buildChild(context, enabled),
        );
      },
      onPressed: button.onPressed,
      tooltipMessage: button.onPressed != null ? button.tooltipMessage : null,
      isFocusable: button.isFocusable,
      autofocus: button.autofocus,
      cursor: button.cursor,
      semanticLabel: button.semanticLabel,
    );
  }
}

class ArnaLinkedButton {
  /// Creates a linked button.
  const ArnaLinkedButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

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
}
