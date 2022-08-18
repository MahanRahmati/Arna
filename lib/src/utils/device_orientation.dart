import 'package:flutter/services.dart' show DeviceOrientation;

/// Specifies a particular device orientation.
abstract class ArnaDeviceOrientation {
  /// DeviceOrientation.landscapeLeft
  static List<DeviceOrientation> landscapeLeft = <DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
  ];

  /// DeviceOrientation.landscapeRight
  static List<DeviceOrientation> landscapeRight = <DeviceOrientation>[
    DeviceOrientation.landscapeRight,
  ];

  /// DeviceOrientation.portraitDown
  static List<DeviceOrientation> portraitDown = <DeviceOrientation>[
    DeviceOrientation.portraitDown,
  ];

  /// DeviceOrientation.portraitUp
  static List<DeviceOrientation> portraitUp = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ];

  /// DeviceOrientation.values
  static List<DeviceOrientation> values = DeviceOrientation.values;
}
