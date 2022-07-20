import 'package:arna/arna.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

/// Helper functions
class ArnaHelpers {
  /// This class is not meant to be instantiated or extended; this constructor prevents instantiation and extension.
  ArnaHelpers._();

  /// Get device height.
  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get device width.
  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Is device compact?
  static bool isCompact(BuildContext context) =>
      deviceWidth(context) < Styles.compact;

  /// Is device medium?
  static bool isMedium(BuildContext context) =>
      !isCompact(context) && !isExpanded(context);

  /// Is device expanded?
  static bool isExpanded(BuildContext context) =>
      deviceWidth(context) > Styles.expanded;

  /// Determines if this is the first child that is being laid out.
  static bool isFirstButton(
    int index,
    int length,
    TextDirection textDirection,
  ) {
    return (index == 0 && textDirection == TextDirection.ltr) ||
        (index == length - 1 && textDirection == TextDirection.rtl);
  }

  /// Determines if this is the last child that is being laid out.
  static bool isLastButton(int index, int length, TextDirection textDirection) {
    return (index == length - 1 && textDirection == TextDirection.ltr) ||
        (index == 0 && textDirection == TextDirection.rtl);
  }

  /// Copy text to clipboard.
  static Future<void> copyToClipboard(String text) async {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  /// Paste text from clipboard.
  static Future<String?> pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text;
  }
}
