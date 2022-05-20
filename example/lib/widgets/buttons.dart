import 'package:arna/arna.dart';

import '/strings.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

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
          ],
        ),
      ),
    );
  }
}
