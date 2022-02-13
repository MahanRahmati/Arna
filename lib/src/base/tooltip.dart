import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show Tooltip;

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
class ArnaTooltip extends StatelessWidget {
  /// Creates a tooltip.
  const ArnaTooltip({
    Key? key,
    this.message,
    required this.child,
  }) : super(key: key);

  /// The text to display in the tooltip.
  final String? message;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return message == null
        ? child
        : Tooltip(
            message: message,
            showDuration: Styles.basicDuration,
            waitDuration: Styles.basicDuration,
            padding: Styles.normal,
            margin: Styles.normal,
            verticalOffset: Styles.tooltipOffset,
            textStyle:
                ArnaTheme.of(context).textTheme.captionTextStyle.copyWith(
                      color: ArnaDynamicColor.resolve(
                        ArnaColors.reversePrimaryTextColor,
                        context,
                      ),
                    ),
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              color: ArnaDynamicColor.resolve(
                ArnaColors.reverseBackgroundColor,
                context,
              ),
            ),
            child: child,
          );
  }
}
