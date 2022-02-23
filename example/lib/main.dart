import 'package:arna/arna.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ArnaApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
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
  int segmentedControlGroupValue = 0;
  var showBanner = true;

  @override
  Widget build(BuildContext context) {
    NavigationItem widgets = NavigationItem(
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
      banner: ArnaBanner(
        showBanner: showBanner,
        message: "This is a message!",
        trailing: ArnaIconButton(
          icon: Icons.close_outlined,
          onPressed: () => setState(() => showBanner = false),
        ),
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
                      onPressed: () => showArnaSnackbar(
                        context: context,
                        message: "Hello There!",
                      ),
                      tooltipMessage: "Add",
                    ),
                    ArnaTextButton(
                      label: "Add",
                      onPressed: () => showArnaSnackbar(
                        context: context,
                        message: "Hello There!",
                      ),
                      tooltipMessage: "Add",
                    ),
                    ArnaButton(
                      label: "Add",
                      icon: Icons.add_outlined,
                      onPressed: () => showArnaSnackbar(
                        context: context,
                        message: "Hello There!",
                      ),
                      tooltipMessage: "Add",
                    ),
                    const ArnaButton(
                      label: "Add",
                      icon: Icons.add_outlined,
                      onPressed: null,
                      tooltipMessage: "Add",
                    ),
                    ArnaIconButton(
                      icon: Icons.add_outlined,
                      buttonType: ButtonType.suggested,
                      onPressed: () => showArnaSnackbar(
                        context: context,
                        message: "Hello There!",
                      ),
                      tooltipMessage: "Add",
                    ),
                  ],
                ),
              ],
            ),
            ArnaList(
              title: "Linked Buttons",
              items: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ArnaLinkedButtons(
                      buttons: [
                        ArnaLinkedButton(
                          icon: Icons.add_outlined,
                          onPressed: () => showArnaSnackbar(
                            context: context,
                            message: "Hello There!",
                          ),
                        ),
                        ArnaLinkedButton(
                          label: "Add",
                          onPressed: () => showArnaSnackbar(
                            context: context,
                            message: "Hello There!",
                          ),
                        ),
                        ArnaLinkedButton(
                          label: "Add",
                          icon: Icons.add_outlined,
                          onPressed: () => showArnaSnackbar(
                            context: context,
                            message: "Hello There!",
                          ),
                        ),
                        const ArnaLinkedButton(
                          label: "Add",
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
              title: "Segmented Control",
              items: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ArnaSegmentedControl(
                      groupValue: segmentedControlGroupValue,
                      children: const {0: "Item 1", 1: "Item 2", 2: "Item 3"},
                      onValueChanged: (int i) =>
                          setState(() => segmentedControlGroupValue = i),
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
              title: "List Tile",
              items: [
                ArnaListTile(
                  title: "Title 1",
                  subtitle: "Subtitle 1",
                  trailing: const ArnaBadge(label: "1"),
                  onTap: () {},
                ),
                const ArnaListTile(
                  title: "Title 2",
                  subtitle: "Subtitle 2",
                  trailing: ArnaBadge(label: "2"),
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
                    trailing: ArnaBadge(label: "2"),
                  ),
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
              items: [
                Padding(
                  padding: Styles.large,
                  child: ArnaTextField(),
                )
              ],
            ),
          ],
        ),
      ),
    );

    NavigationItem typography = NavigationItem(
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
                    style: ArnaTheme.of(context).textTheme.largeTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    "Lorem ipsum dolor",
                    style: ArnaTheme.of(context).textTheme.titleTextStyle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    "Lorem ipsum dolor",
                    style: ArnaTheme.of(context).textTheme.textStyle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    "Lorem ipsum dolor",
                    style: ArnaTheme.of(context).textTheme.buttonTextStyle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    "Lorem ipsum dolor",
                    style: ArnaTheme.of(context).textTheme.subtitleTextStyle,
                  ),
                ),
                Padding(
                  padding: Styles.normal,
                  child: Text(
                    "Lorem ipsum dolor",
                    style: ArnaTheme.of(context).textTheme.captionTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    NavigationItem indicators = NavigationItem(
      title: "Indicators",
      icon: Icons.refresh_outlined,
      builder: (_) => SingleChildScrollView(
        child: ArnaList(
          title: "Indicator",
          items: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ArnaProgressIndicator(),
                ArnaProgressIndicator(size: 140),
              ],
            ),
          ],
        ),
      ),
    );

    NavigationItem dummy = NavigationItem(
      title: "Dummy",
      icon: Icons.info_outlined,
      builder: (_) => Container(),
    );

    return ArnaSideScaffold(
      title: "Arna Demo",
      headerBarTrailing: Row(
        children: [
          ArnaIconButton(
            icon: Icons.info_outlined,
            onPressed: () => showArnaDialog(
              context: context,
              barrierDismissible: true,
              dialog: ArnaAlertDialog(
                title: "Title",
                message: "Message",
                primary: ArnaTextButton(
                  label: "OK",
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ),
          ),
          ArnaIconButton(
            icon: Icons.settings_outlined,
            onPressed: () {
              showArnaPopupDialog(
                context: context,
                title: "Settings",
                body: Container(),
              );
            },
          ),
        ],
      ),
      items: [
        widgets,
        typography,
        indicators,
        dummy,
      ],
    );
  }
}
