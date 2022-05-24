import 'package:arna/arna.dart';

import '/strings.dart';

class LinkedButtons extends StatelessWidget {
  const LinkedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.more_horiz_outlined,
        color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
      ),
      title: Strings.linkedButtons,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaLinkedButtons(
            buttons: <ArnaLinkedButton>[
              ArnaLinkedButton(
                icon: Icons.add_outlined,
                onPressed: () {},
                tooltipMessage: Strings.add,
              ),
              ArnaLinkedButton(
                label: Strings.add,
                onPressed: () {},
              ),
              ArnaLinkedButton(
                label: Strings.add,
                icon: Icons.add_outlined,
                onPressed: () {},
              ),
              const ArnaLinkedButton(
                label: Strings.add,
                icon: Icons.add_outlined,
                onPressed: null,
              ),
              ArnaLinkedButton(
                icon: Icons.add_outlined,
                buttonType: ButtonType.colored,
                onPressed: () {},
                tooltipMessage: Strings.add,
              ),
            ],
          ),
        ],
      ),
    );
  }
}