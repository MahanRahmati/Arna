import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Brightness;

/// Button types.
enum ButtonType { normal, colored, destructive, suggested }

/// Button sizes.
enum ButtonSize { normal, huge }

/// An Arna-styled button.
class ArnaButton extends StatelessWidget {
  /// Creates a button.
  const ArnaButton({
    Key? key,
    this.label,
    this.icon,
    required this.onPressed,
    this.tooltipMessage,
    this.buttonType = ButtonType.normal,
    this.buttonSize = ButtonSize.normal,
    this.isFocusable = true,
    this.autofocus = false,
    this.hasBorder = true,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  }) : super(key: key);

  /// The text label of the button.
  final String? label;

  /// The icon of the button.
  final IconData? icon;

  /// The callback that is called when a button is tapped.
  final VoidCallback? onPressed;

  /// Text that describes the action that will occur when the button is pressed.
  final String? tooltipMessage;

  /// The type of the button.
  final ButtonType buttonType;

  /// The size of the button.
  final ButtonSize buttonSize;

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

  Widget _buildChild(
    BuildContext context,
    bool enabled,
    bool hovered,
    Color accent,
  ) {
    final List<Widget> children = <Widget>[];
    Brightness brightness = ArnaTheme.brightnessOf(context);
    if (icon != null) {
      Widget iconWidget = Icon(
        icon!,
        size: Styles.iconSize,
        color: ArnaDynamicColor.resolve(
          !enabled
              ? ArnaColors.disabledColor
              : buttonType == ButtonType.normal
                  ? ArnaColors.iconColor
                  : hasBorder
                      ? ArnaDynamicColor.innerColor(
                          accent,
                          ArnaTheme.brightnessOf(context),
                        )
                      : hovered
                          ? ArnaDynamicColor.matchingColor(
                              ArnaDynamicColor.blend(
                                hasBorder
                                    ? ArnaDynamicColor.resolve(
                                        ArnaColors.buttonColor,
                                        context,
                                      )
                                    : ArnaDynamicColor.resolve(
                                        ArnaColors.headerColor,
                                        context,
                                      ),
                                14,
                                brightness,
                              ),
                              accent,
                              brightness,
                            )
                          : ArnaDynamicColor.matchingColor(
                              hasBorder
                                  ? ArnaDynamicColor.resolve(
                                      ArnaColors.buttonColor,
                                      context,
                                    )
                                  : ArnaDynamicColor.resolve(
                                      ArnaColors.headerColor,
                                      context,
                                    ),
                              accent,
                              brightness,
                            ),
          context,
        ),
      );
      children.add(iconWidget);
      if (label != null) {
        children.add(
          const SizedBox(width: Styles.padding),
        );
      }
    }
    if (label != null) {
      Widget text = Text(
        label!,
        style: ArnaTheme.of(context).textTheme.buttonTextStyle.copyWith(
              color: ArnaDynamicColor.resolve(
                !enabled
                    ? ArnaColors.disabledColor
                    : buttonType == ButtonType.normal
                        ? ArnaColors.primaryTextColor
                        : ArnaDynamicColor.innerColor(
                            accent,
                            brightness,
                          ),
                context,
              ),
            ),
      );
      Widget labelWidget = Flexible(child: text);
      children.add(labelWidget);
      if (icon != null) {
        children.add(const SizedBox(width: Styles.padding));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize:
          buttonSize == ButtonSize.huge ? MainAxisSize.max : MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent;
    switch (buttonType) {
      case ButtonType.destructive:
        accent = ArnaColors.errorColor;
        break;
      case ButtonType.suggested:
        accent = ArnaColors.accentColor;
        break;
      default:
        accent = accentColor ?? ArnaTheme.of(context).accentColor;
    }
    Brightness brightness = ArnaTheme.brightnessOf(context);
    return Padding(
      padding: Styles.small,
      child: ArnaBaseWidget(
        builder: (context, enabled, hover, focused, pressed, selected) {
          return AnimatedContainer(
            height: (buttonSize == ButtonSize.huge)
                ? Styles.hugeButtonSize
                : Styles.buttonSize,
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: hasBorder
                    ? ArnaDynamicColor.resolve(
                        buttonType == ButtonType.normal
                            ? !enabled
                                ? ArnaColors.borderColor
                                : focused
                                    ? ArnaDynamicColor.matchingColor(
                                        ArnaDynamicColor.resolve(
                                          ArnaColors.buttonColor,
                                          context,
                                        ),
                                        accent,
                                        brightness,
                                      )
                                    : ArnaColors.borderColor
                            : !enabled
                                ? ArnaDynamicColor.blend(
                                    ArnaDynamicColor.innerColor(
                                      accent,
                                      brightness,
                                    ),
                                    21,
                                    brightness,
                                  )
                                : focused
                                    ? ArnaDynamicColor.outerColor(
                                        accent,
                                        true,
                                        brightness,
                                      )
                                    : ArnaDynamicColor.outerColor(
                                        accent,
                                        hover,
                                        brightness,
                                      ),
                        context,
                      )
                    : focused
                        ? ArnaColors.borderColor
                        : ArnaDynamicColor.resolve(
                            ArnaColors.buttonColor,
                            context,
                          ).withAlpha(0),
              ),
              color: !enabled
                  ? ArnaDynamicColor.resolve(
                      ArnaColors.backgroundColor,
                      context,
                    )
                  : buttonType == ButtonType.normal || !hasBorder
                      ? pressed
                          ? ArnaDynamicColor.blend(
                              hasBorder
                                  ? ArnaDynamicColor.resolve(
                                      ArnaColors.buttonColor,
                                      context,
                                    )
                                  : ArnaDynamicColor.resolve(
                                      ArnaColors.headerColor,
                                      context,
                                    ),
                              14,
                              brightness,
                            )
                          : hover
                              ? ArnaDynamicColor.blend(
                                  hasBorder
                                      ? ArnaDynamicColor.resolve(
                                          ArnaColors.buttonColor,
                                          context,
                                        )
                                      : ArnaDynamicColor.resolve(
                                          ArnaColors.headerColor,
                                          context,
                                        ),
                                  14,
                                  brightness,
                                )
                              : hasBorder
                                  ? ArnaDynamicColor.resolve(
                                      ArnaColors.buttonColor,
                                      context,
                                    )
                                  : ArnaDynamicColor.resolve(
                                      ArnaColors.buttonColor,
                                      context,
                                    ).withAlpha(0)
                      : pressed
                          ? ArnaDynamicColor.blend(
                              accent,
                              14,
                              brightness,
                            )
                          : hover
                              ? ArnaDynamicColor.blend(
                                  accent,
                                  14,
                                  brightness,
                                )
                              : focused
                                  ? ArnaDynamicColor.blend(
                                      accent,
                                      14,
                                      brightness,
                                    )
                                  : accent,
            ),
            padding: icon != null
                ? const EdgeInsets.symmetric(horizontal: Styles.padding - 1)
                : Styles.largeHorizontal,
            child: _buildChild(context, enabled, hover, accent),
          );
        },
        onPressed: onPressed,
        tooltipMessage: onPressed != null ? tooltipMessage : null,
        isFocusable: isFocusable,
        autofocus: autofocus,
        cursor: cursor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
