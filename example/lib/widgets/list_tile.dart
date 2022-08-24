import 'package:arna/arna.dart';

import '/strings.dart';

class ListTiles extends StatelessWidget {
  const ListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.view_list_outlined,
        color: ArnaColors.iconColor.resolveFrom(context),
      ),
      title: Strings.listTile,
      child: const ArnaList(
        showBackground: true,
        showDividers: true,
        children: <Widget>[
          ArnaListTile(
            title: '${Strings.title} 1',
            trailing: ArnaBadge(label: '1'),
            showBackground: false,
          ),
          ArnaListTile(
            title: '${Strings.title} 2',
            subtitle: Strings.subtitle,
            trailing: ArnaBadge(label: '2'),
          ),
        ],
      ),
    );
  }
}
