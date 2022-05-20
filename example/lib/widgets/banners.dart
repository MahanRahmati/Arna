import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/strings.dart';

class Banners extends ConsumerWidget {
  const Banners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showBanner = ref.watch(bannerProvider);
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.ad_units_outlined,
        color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
      ),
      title: Strings.banners,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaTextButton(
            label: Strings.showBanner,
            onPressed: () {
              if (!showBanner) {
                ref.read(bannerProvider.notifier).state = !showBanner;
              }
            },
          ),
          ArnaTextButton(
            label: Strings.showSnackBar,
            onPressed: () {
              showArnaSnackbar(
                context: context,
                message: Strings.hello,
              );
            },
          ),
        ],
      ),
    );
  }
}

final AutoDisposeStateProvider<bool> bannerProvider = StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);
