import 'package:arna/arna.dart';

import '/strings.dart';

class SegmentedControl extends StatefulWidget {
  const SegmentedControl({super.key});

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl> {
  int segmentedControlGroupValue = 0;
  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.calendar_view_week_outlined),
      title: Strings.segmentedControl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaSegmentedControl<int>(
            groupValue: segmentedControlGroupValue,
            children: const <int, String>{
              0: Strings.first,
              1: Strings.second,
              2: Strings.third,
            },
            onValueChanged: (int i) =>
                setState(() => segmentedControlGroupValue = i),
          ),
        ],
      ),
    );
  }
}
