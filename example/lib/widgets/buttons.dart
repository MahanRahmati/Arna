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
      leading: Icon(
        Icons.adjust_outlined,
        color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
      ),
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
            ArnaPopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <ArnaPopupMenuEntry<String>>[
                const ArnaPopupMenuItem<String>(
                  value: Strings.first,
                  child: Text(Strings.first),
                ),
                const ArnaPopupMenuItem<String>(
                  enabled: false,
                  value: Strings.second,
                  child: Text(Strings.second),
                ),
                const ArnaPopupMenuDivider(),
                const ArnaPopupMenuItem<String>(
                  value: Strings.third,
                  child: Text(Strings.third),
                ),
              ],
              onSelected: (String value) => showArnaSnackbar(
                context: context,
                message: '${Strings.selected} $value',
              ),
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
            ArnaLinkButton(
              label: Strings.add,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
