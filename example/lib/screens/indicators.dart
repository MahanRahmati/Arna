import 'package:arna/arna.dart';

class Indicators extends StatelessWidget {
  const Indicators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ArnaList(
        title: "Indicator",
        items: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ArnaProgressIndicator(),
              ArnaProgressIndicator(size: 140),
            ],
          ),
        ],
      ),
    );
  }
}
