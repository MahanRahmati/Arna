import 'package:arna/arna.dart';

import '/strings.dart';

class CheckBoxs extends StatefulWidget {
  const CheckBoxs({super.key});

  @override
  State<CheckBoxs> createState() => _CheckBoxsState();
}

class _CheckBoxsState extends State<CheckBoxs> {
  bool? _checkBox1 = false;

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.check_box_outlined),
      title: Strings.checkBox,
      child: ArnaList(
        showBackground: true,
        showDividers: true,
        children: <Widget>[
          ArnaCheckboxListTile(
            value: _checkBox1,
            title: '${Strings.checkBox} 1',
            tristate: true,
            onChanged: (bool? value) => setState(() => _checkBox1 = value),
          ),
          ArnaCheckboxListTile(
            value: _checkBox1,
            title: '${Strings.checkBox} 2',
            subtitle: Strings.subtitle,
            onChanged: null,
          )
        ],
      ),
    );
  }
}
