import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

class HelloWorld extends ConsumerWidget {
  const HelloWorld({Key? key}) : super(key: key);

  void add(WidgetRef ref) {
    ref.read(counterProvider.state).state++;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "You have pushed the button this many times:",
            style: ArnaTheme.of(context).textTheme.textStyle,
          ),
          const SizedBox(height: Styles.padding),
          Consumer(
            builder: (context, ref, _) => Text(
              "${ref.watch(counterProvider.state).state}",
              style: ArnaTheme.of(context).textTheme.titleTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
