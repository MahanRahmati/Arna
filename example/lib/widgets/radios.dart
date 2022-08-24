import 'package:arna/arna.dart';

import '/strings.dart';

class Radios extends StatefulWidget {
  const Radios({super.key});

  @override
  State<Radios> createState() => _RadiosState();
}

class _RadiosState extends State<Radios> {
  String _selectedType = '1';
  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.radio_button_checked_outlined),
      title: Strings.radio,
      child: ArnaList(
        showBackground: true,
        showDividers: true,
        children: <Widget>[
          ArnaRadioListTile<String>(
            value: '1',
            groupValue: _selectedType,
            title: '${Strings.radio} 1',
            onChanged: (String? value) =>
                setState(() => _selectedType = value!),
          ),
          ArnaRadioListTile<String>(
            value: '2',
            groupValue: _selectedType,
            title: '${Strings.radio} 2',
            onChanged: (String? value) =>
                setState(() => _selectedType = value!),
          ),
          ArnaRadioListTile<String>(
            value: '3',
            groupValue: _selectedType,
            title: '${Strings.radio} 3',
            subtitle: Strings.subtitle,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
