import 'package:arna/arna.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ArnaApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _selectedType = "1";
  bool _checkBox1 = false;
  bool? _checkBox2 = false;
  final bool _checkBox3 = false;
  bool _switch1 = false;
  bool _switch2 = false;
  final bool _switch3 = false;

  @override
  Widget build(BuildContext context) {
    return ArnaSideScaffold(
      title: "Arna Demo",
      headerBarTrailing: ArnaIconButton(
        icon: Icons.info_outlined,
        onPressed: () {
          showArnaPopupDialog(
            context: context,
            title: "Title",
            body: Container(),
          );
        },
      ),
      items: [
        NavigationItem(
          title: "Inputs",
          icon: Icons.check_box_outlined,
          builder: (_) => SingleChildScrollView(
            child: Column(
              children: [
                ArnaList(
                  title: "Buttons",
                  items: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArnaIconButton(
                          icon: Icons.add_outlined,
                          onPressed: () {},
                        ),
                        ArnaTextButton(title: "Add", onPressed: () {}),
                        ArnaButton(
                          title: "Add",
                          icon: Icons.add_outlined,
                          onPressed: () {},
                        ),
                        const ArnaButton(
                          title: "Add",
                          icon: Icons.add_outlined,
                          onPressed: null,
                        ),
                      ],
                    ),
                  ],
                ),
                ArnaList(
                  title: "Linked buttons",
                  items: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArnaLinkedButtons(
                          buttons: [
                            ArnaLinkedIconButton(
                              icon: Icons.add_outlined,
                              onPressed: () {},
                            ),
                            ArnaLinkedTextButton(
                              title: "Add",
                              onPressed: () {},
                            ),
                            ArnaLinkedButton(
                              title: "Add",
                              icon: Icons.add_outlined,
                              onPressed: () {},
                            ),
                            const ArnaLinkedButton(
                              title: "Add",
                              icon: Icons.add_outlined,
                              onPressed: null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ArnaList(
                  title: "CheckBox",
                  items: [
                    ArnaCheckBoxListTile(
                      value: _checkBox1,
                      title: "CheckBox 1",
                      onChanged: (value) => setState(() => _checkBox1 = value!),
                    ),
                    ArnaCheckBoxListTile(
                      value: _checkBox2,
                      title: "CheckBox 2",
                      subtitle: "Subtitle 2",
                      tristate: true,
                      onChanged: (value) => setState(() => _checkBox2 = value),
                      trailingButton: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaCheckBoxListTile(
                      value: _checkBox3,
                      title: "CheckBox 3",
                      subtitle: "Subtitle 3",
                      onChanged: null,
                    ),
                  ],
                ),
                ArnaList(
                  title: "Radio",
                  items: [
                    ArnaRadioListTile(
                      value: "1",
                      groupValue: _selectedType,
                      title: "Radio 1",
                      onChanged: (value) =>
                          setState(() => _selectedType = value as String),
                    ),
                    ArnaRadioListTile(
                      value: "2",
                      groupValue: _selectedType,
                      title: "Radio 2",
                      subtitle: "Subtitle 2",
                      onChanged: (value) =>
                          setState(() => _selectedType = value as String),
                      trailingButton: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaRadioListTile(
                      value: "3",
                      groupValue: _selectedType,
                      title: "Radio 3",
                      subtitle: "Subtitle 3",
                      onChanged: null,
                    ),
                  ],
                ),
                ArnaList(
                  title: "Switch",
                  items: [
                    ArnaSwitchListTile(
                      title: "Switch 1",
                      value: _switch1,
                      onChanged: (value) => setState(() => _switch1 = value),
                    ),
                    ArnaSwitchListTile(
                      title: "Switch 2",
                      subtitle: "Subtitle 2",
                      value: _switch2,
                      onChanged: (value) => setState(() => _switch2 = value),
                      trailingButton: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaSwitchListTile(
                      title: "Switch 3",
                      subtitle: "Subtitle 3",
                      value: _switch3,
                      onChanged: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        NavigationItem(
          title: "List",
          icon: Icons.list_outlined,
          badge: const ArnaBadge(title: "1"),
          builder: (_) => SingleChildScrollView(
            child: Column(
              children: [
                ArnaList(
                  title: "List tile",
                  items: [
                    ArnaListTile(
                      title: "Title 1",
                      subtitle: "Subtitle 1",
                      trailing: const ArnaBadge(title: "Badge 1"),
                      onTap: () {},
                    ),
                    const ArnaListTile(
                      title: "Title 2",
                      subtitle: "Subtitle 2",
                      trailing: ArnaBadge(title: "Badge 2"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        NavigationItem(
          title: "Typography",
          icon: Icons.font_download_outlined,
          builder: (_) => SingleChildScrollView(
            child: Padding(
              padding: Styles.normal,
              child: SizedBox(
                width: deviceWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Large Title",
                        style: largeTitleText(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text("Title", style: titleText(context)),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text("Body", style: bodyText(context, false)),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text("Button", style: buttonText(context, false)),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Subtitle",
                        style: subtitleText(context, false),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text("Caption", style: captionText(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
