import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeStateProvider<Brightness?> themeProvider =
    StateProvider.autoDispose<Brightness?>(
  (AutoDisposeStateProviderRef<Brightness?> ref) => null,
);

final AutoDisposeStateProvider<bool> masterProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

final AutoDisposeStateProvider<Color> accentProvider =
    StateProvider.autoDispose<Color>(
  (AutoDisposeStateProviderRef<Color> ref) => ArnaColors.blue,
);

final AutoDisposeStateProvider<bool> bannerProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

final AutoDisposeStateProvider<bool> searchProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);
