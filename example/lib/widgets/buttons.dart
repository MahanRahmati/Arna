import 'package:arna/arna.dart';

import '/strings.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  List<String> items = <String>[Strings.first, Strings.second, Strings.third];

  String dropdownvalue = Strings.first;

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: const Icon(Icons.adjust_outlined),
      title: Strings.buttons,
      child: Center(
        child: Wrap(
          children: <Widget>[
            ArnaIconButton(
              icon: Icons.add_outlined,
              onPressed: () {},
              tooltipMessage: Strings.add,
            ),
            ArnaTextButton(
              label: Strings.add,
              onPressed: () {},
            ),
            ArnaButton(
              label: Strings.add,
              icon: Icons.add_outlined,
              onPressed: () {},
            ),
            const ArnaButton(
              label: Strings.add,
              icon: Icons.add_outlined,
              onPressed: null,
              tooltipMessage: Strings.add,
            ),
            ArnaIconButton(
              icon: Icons.add_outlined,
              buttonType: ButtonType.colored,
              onPressed: () {},
              tooltipMessage: Strings.add,
            ),
            ArnaBorderlessButton(
              icon: Icons.add_outlined,
              onPressed: () {},
              tooltipMessage: Strings.add,
            ),
            ArnaPopupMenuButton(
              itemBuilder: (BuildContext context) => <ArnaPopupMenuEntry>[
                ArnaPopupMenuItem(
                  leading: const Icon(Icons.add_outlined),
                  title: Strings.first,
                  onTap: () => showArnaSnackbar(
                    context: context,
                    message: '${Strings.selected} ${Strings.first}',
                  ),
                ),
                const ArnaPopupMenuItem(
                  title: Strings.second,
                ),
                const ArnaPopupMenuDivider(),
                ArnaPopupMenuItem(
                  title: Strings.third,
                  onTap: () => showArnaSnackbar(
                    context: context,
                    message: '${Strings.selected} ${Strings.third}',
                  ),
                ),
              ],
            ),
            ArnaDropdownButton<String>(
              value: dropdownvalue,
              items: items.map((String items) {
                return ArnaDropdownMenuItem<String>(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                showArnaSnackbar(
                  context: context,
                  message: '${Strings.selected} $newValue',
                );
                setState(() => dropdownvalue = newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
