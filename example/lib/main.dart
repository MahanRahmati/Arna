import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers.dart';
import '/screens/home.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArnaApp(
      debugShowCheckedModeBanner: false,
      theme: ArnaThemeData(
        accentColor: ref.watch(accentProvider),
        brightness: ref.watch(themeProvider),
      ),
      home: const Home(),
    );
  }
}
