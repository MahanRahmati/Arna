import 'package:arna/arna.dart';

import '/strings.dart';

class Switches extends StatefulWidget {
  const Switches({super.key});

  @override
  State<Switches> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  bool _switch1 = false;
  final bool _switch2 = false;

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.toggle_on_outlined),
      title: Strings.switchText,
      child: ArnaList(
        showBackground: true,
        showDividers: true,
        children: <Widget>[
          ArnaSwitchListTile(
            value: _switch1,
            title: '${Strings.switchText} 1',
            onChanged: (bool value) => setState(() => _switch1 = value),
          ),
          ArnaSwitchListTile(
            value: _switch2,
            title: '${Strings.switchText} 2',
            subtitle: Strings.subtitle,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
