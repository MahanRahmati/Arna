import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers.dart';
import '/strings.dart';

class Banners extends ConsumerWidget {
  const Banners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showBanner = ref.watch(bannerProvider);
    return ArnaExpansionPanel(
      leading: const Icon(Icons.ad_units_outlined),
      title: Strings.banners,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaButton.text(
            label: Strings.showBanner,
            onPressed: () {
              if (!showBanner) {
                ref.read(bannerProvider.notifier).state = !showBanner;
              }
            },
          ),
          ArnaButton.text(
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
