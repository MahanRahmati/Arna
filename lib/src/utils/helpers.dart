import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/services.dart'
    show
        Clipboard,
        ClipboardData,
        DeviceOrientation,
        SystemChrome,
        SystemUiOverlayStyle;

/// Helper functions
class ArnaHelpers {
  /// This class is not meant to be instantiated or extended; this constructor prevents instantiation and extension.
  ArnaHelpers._();

  /// Get device height.
  static double deviceHeight(final BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get device width.
  static double deviceWidth(final BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Is device compact?
  static bool isCompact(final BuildContext context) {
    return deviceWidth(context) < Styles.compact;
  }

  /// Is device medium?
  static bool isMedium(final BuildContext context) {
    return !isCompact(context) && !isExpanded(context);
  }

  /// Is device expanded?
  static bool isExpanded(final BuildContext context) {
    return deviceWidth(context) > Styles.expanded;
  }

  /// Determines if this is the first child that is being laid out.
  static bool isFirstButton(
    final int index,
    final int length,
    final TextDirection textDirection,
  ) {
    return (index == 0 && textDirection == TextDirection.ltr) ||
        (index == length - 1 && textDirection == TextDirection.rtl);
  }

  /// Determines if this is the last child that is being laid out.
  static bool isLastButton(
    final int index,
    final int length,
    final TextDirection textDirection,
  ) {
    return (index == length - 1 && textDirection == TextDirection.ltr) ||
        (index == 0 && textDirection == TextDirection.rtl);
  }

  /// Copy text to clipboard.
  static Future<void> copyToClipboard(final String text) async {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  /// Paste text from clipboard.
  static Future<String?> pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text;
  }

  /// Specifies the style of system bottom navigation bar.
  static void setNavigationBarStyle(final BuildContext context) {
    Brightness? systemNavigationBarIconBrightness;
    switch (ArnaTheme.of(context).brightness) {
      case Brightness.dark:
        systemNavigationBarIconBrightness = Brightness.light;
        break;
      case Brightness.light:
        systemNavigationBarIconBrightness = Brightness.dark;
        break;
      case null:
        systemNavigationBarIconBrightness = null;
        break;
    }
    final Color backgroundColor = ArnaColors.backgroundColor.resolveFrom(
      context,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
        systemNavigationBarDividerColor: ArnaColors.transparent,
      ),
    );
  }

  /// Specifies the set of orientations the application interface can be displayed in.
  static Future<void> setOrientation(
    final List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Dismiss the keyboard
  static void dismissKeyboard(final BuildContext context) {
    final FocusScopeNode focus = FocusScope.of(context);
    if (focus.hasFocus) {
      focus.unfocus();
    } else {
      focus.requestFocus(FocusNode());
    }
  }

  /// Whether the text has content or not.
  bool hasContent(final String? text) {
    return text != null && text.isNotEmpty;
  }

  /// Whether the text is email or not.
  static bool isEmail(final String text) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(text);
  }

  /// Whether the text is url or not.
  static bool isUrl(final String text) {
    return RegExp(
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$",
    ).hasMatch(text);
  }

  /// Convert dynamic to double.
  static double? dynamicToDouble(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String && value.isNotEmpty) {
      return double.tryParse(
        value.removeAllNotNumber(exclude: <String>['.', '-']),
      );
    }
    return null;
  }

  /// Convert dynamic to string.
  static String? dynamicToString(final dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  /// Convert dynamic to bool.
  static bool? dynamicToBool(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is int) {
      if (value == 1) {
        return true;
      }
      if (value == 0) {
        return false;
      }
      return null;
    }
    if (value is String && value.isNotEmpty) {
      final String lower = value.toNormalize();
      if (lower == 'true') {
        return true;
      }
      if (lower == 'false') {
        return false;
      }
      return null;
    }
    return null;
  }

  /// Convert dynamic to int.
  static int? dynamicToInt(final dynamic value) {
    return dynamicToDouble(value)?.toInt();
  }

  /// Convert dynamic to DateTime.
  static DateTime? dynamicToDateTime(final dynamic value) {
    try {
      if (value is String) {
        return DateTime.parse(value);
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (_) {}
    return null;
  }

  /// Convert dynamic to Map.
  static Map<K, V>? dynamicToMap<K, V>(final dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Map) {
      return Map<K, V>.from(value);
    }
    if (value is List && value.isNotEmpty) {
      return dynamicToMap<K, V>(value.first);
    }
    return null;
  }

  /// Convert dynamic to Map<String, dynamic>.
  static Map<String, dynamic>? dynamicToMapStringDynamic(final dynamic value) {
    return dynamicToMap<String, dynamic>(value);
  }

  /// Convert dynamic map to model.
  static T? dynamicMapToModel<T>(
    final dynamic value,
    final T Function(Map<String, dynamic> e) f,
  ) {
    final Map<String, dynamic>? map = dynamicToMapStringDynamic(value);
    if (map != null) {
      return f(map);
    }
    return null;
  }

  /// Convert degrees to dadians.
  static double degreesToRadians(final double degrees) {
    const double degrees2radians = math.pi / 180.0;
    return degrees * degrees2radians;
  }

  /// Get color from hex.
  static Color colorFromHex(final String hex) {
    final StringBuffer buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
