import 'package:arna/arna.dart';

import '/strings.dart';

class Sliders extends StatefulWidget {
  const Sliders({super.key});

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  double _sliderValue1 = 0;
  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.linear_scale_outlined),
      title: Strings.slider,
      child: ArnaList(
        showBackground: true,
        showDividers: true,
        children: <Widget>[
          ArnaSliderListTile(
            title: '${Strings.title} 1',
            value: _sliderValue1,
            max: 100,
            onChanged: (double newValue) =>
                setState(() => _sliderValue1 = newValue),
          ),
          const ArnaSliderListTile(
            title: '${Strings.title} 2',
            subtitle: Strings.subtitle,
            value: 0,
            max: 100,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
