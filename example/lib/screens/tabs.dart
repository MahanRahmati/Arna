import 'package:arna/arna.dart';

import '/strings.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final List<ArnaTab> tabs = <ArnaTab>[];

  @override
  void initState() {
    super.initState();
    tabs.add(tab(context));
  }

  ArnaTab tab(BuildContext context) => ArnaTab(
        label: 'New ${Strings.tab}',
        icon: const ArnaLogo(),
        builder: (BuildContext context) {
          return Center(
            child: Text(
              'New ${Strings.tab}',
              style: ArnaTheme.of(context).textTheme.body,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return tabs.isNotEmpty
        ? ArnaTabView(
            tabs: tabs,
            onTabClosed: (int index) => setState(() => tabs.removeAt(index)),
            onAddPressed: () => setState(() => tabs.add(tab(context))),
          )
        : Center(
            child: ArnaButton.text(
              label: 'Add Tab',
              onPressed: () => setState(() => tabs.add(tab(context))),
            ),
          );
  }
}
