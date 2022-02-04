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
  var showSearch = false;
  TextEditingController controller = TextEditingController();
  var _selectedType = "1";
  bool _checkBox1 = false;
  bool? _checkBox2 = false;
  final bool _checkBox3 = false;
  bool _switch1 = false;
  bool _switch2 = false;
  final bool _switch3 = false;
  double _sliderValue = 50;

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
          headerBarLeading: ArnaIconButton(
            icon: Icons.search_outlined,
            onPressed: () => setState(
              () {
                showSearch = !showSearch;
                controller.text = "";
              },
            ),
          ),
          title: "Widgets",
          icon: Icons.widgets_outlined,
          searchField: ArnaSearchField(
            showSearch: showSearch,
            controller: controller,
          ),
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
                          tooltipMessage: "Add",
                        ),
                        ArnaTextButton(
                          label: "Add",
                          onPressed: () {},
                          tooltipMessage: "Add",
                        ),
                        ArnaButton(
                          label: "Add",
                          icon: Icons.add_outlined,
                          onPressed: () {},
                          tooltipMessage: "Add",
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
                            ArnaLinkedButton(
                              icon: Icons.add_outlined,
                              onPressed: () {},
                            ),
                            ArnaLinkedButton(
                              label: "Add",
                              onPressed: () {},
                            ),
                            ArnaLinkedButton(
                              label: "Add",
                              icon: Icons.add_outlined,
                              onPressed: () {},
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
                const ArnaList(
                  title: "Expansion Panel",
                  items: [
                    ArnaExpansionPanel(
                      title: "Title 1",
                      subtitle: "Subtitle 1",
                      child: ArnaListTile(
                        title: "Title 2",
                        subtitle: "Subtitle 2",
                        trailing: ArnaBadge(title: "Badge 2"),
                      ),
                    ),
                  ],
                ),
                ArnaList(
                  title: "Indicator",
                  items: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ArnaIndicator(),
                        ArnaIndicator(size: 140),
                      ],
                    ),
                  ],
                ),
                ArnaList(
                  title: "Slider",
                  items: [
                    ArnaSlider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      onChanged: (double newValue) {
                        setState(() => _sliderValue = newValue);
                      },
                    )
                  ],
                ),
                const ArnaList(
                  title: "Text Field",
                  items: [ArnaTextField()],
                )
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
                        "Lorem ipsum dolor",
                        style: headline1(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Lorem ipsum dolor",
                        style: headline2(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Lorem ipsum dolor",
                        style: bodyText(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Lorem ipsum dolor",
                        style: buttonText(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Lorem ipsum dolor",
                        style: subtitleText(context),
                      ),
                    ),
                    Padding(
                      padding: Styles.normal,
                      child: Text(
                        "Lorem ipsum dolor",
                        style: captionText(context),
                      ),
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
