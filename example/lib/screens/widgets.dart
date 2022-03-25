import 'package:arna/arna.dart';

class Widgets extends StatefulWidget {
  const Widgets({Key? key}) : super(key: key);

  @override
  _WidgetsState createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  var _selectedType = "1";
  bool _checkBox1 = false;
  bool? _checkBox2 = false;
  final bool _checkBox3 = false;
  bool _switch1 = false;
  bool _switch2 = false;
  final bool _switch3 = false;
  double _sliderValue1 = 0;
  double _sliderValue2 = 0;
  final double _sliderValue3 = 0;
  int segmentedControlGroupValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ArnaList(
            title: "Widgets",
            items: <Widget>[
              ArnaExpansionPanel(
                leading: const Icon(Icons.adjust_outlined),
                title: "Buttons",
                child: Center(
                  child: Wrap(
                    children: <Widget>[
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
                        buttonType: ButtonType.colored,
                        onPressed: () => showArnaSnackbar(
                          context: context,
                          message: "Hello There!",
                        ),
                        tooltipMessage: "Add",
                      ),
                      ArnaIconButton(
                        icon: Icons.add_outlined,
                        hasBorder: false,
                        buttonType: ButtonType.normal,
                        onPressed: () => showArnaSnackbar(
                          context: context,
                          message: "Hello There!",
                        ),
                        tooltipMessage: "Add",
                      ),
                      ArnaPopupMenuButton<String>(
                        itemBuilder: (context) => <ArnaPopupMenuEntry<String>>[
                          ArnaPopupMenuItem(
                            child: Text(
                              "First Item",
                              style: ArnaTheme.of(context).textTheme.textStyle,
                            ),
                            value: "First Item",
                          ),
                          ArnaPopupMenuItem(
                            child: Text(
                              "Second Item",
                              style: ArnaTheme.of(context).textTheme.textStyle,
                            ),
                            value: "Second Item",
                          ),
                          const ArnaPopupMenuDivider(),
                          ArnaPopupMenuItem(
                            child: Text(
                              "Third Item",
                              style: ArnaTheme.of(context).textTheme.textStyle,
                            ),
                            value: "Third Item",
                          ),
                        ],
                        onSelected: (String value) => showArnaSnackbar(
                          context: context,
                          message: value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.more_horiz_outlined),
                title: "Linked Buttons",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ArnaLinkedButtons(
                      buttons: <ArnaLinkedButton>[
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
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.calendar_view_week_outlined),
                title: "Segmented Control",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ArnaSegmentedControl(
                      groupValue: segmentedControlGroupValue,
                      children: const {0: "Item 1", 1: "Item 2", 2: "Item 3"},
                      onValueChanged: (int i) =>
                          setState(() => segmentedControlGroupValue = i),
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.check_box_outlined),
                title: "CheckBox",
                child: ArnaColumn(
                  children: <Widget>[
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
                      trailing: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaCheckBoxListTile(
                      value: _checkBox3,
                      title: "CheckBox 3",
                      onChanged: null,
                    )
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.radio_button_checked_outlined),
                title: "Radio",
                child: ArnaColumn(
                  children: <Widget>[
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
                      trailing: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaRadioListTile(
                      value: "3",
                      groupValue: _selectedType,
                      title: "Radio 3",
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.toggle_on_outlined),
                title: "Switch",
                child: ArnaColumn(
                  children: <Widget>[
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
                      trailing: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaSwitchListTile(
                      title: "Switch 3",
                      value: _switch3,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.view_list_outlined),
                title: "List Tile",
                child: ArnaColumn(
                  children: <Widget>[
                    ArnaListTile(
                      title: "Title 1",
                      subtitle: "Subtitle 1",
                      trailing: const ArnaBadge(label: "1"),
                      onTap: () {},
                    ),
                    const ArnaListTile(
                      title: "Title 2",
                      trailing: ArnaBadge(label: "2"),
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.linear_scale_outlined),
                title: "Slider",
                child: ArnaColumn(
                  children: <Widget>[
                    ArnaSliderListTile(
                      title: "Title 1",
                      value: _sliderValue1,
                      min: 0,
                      max: 100,
                      onChanged: (double newValue) =>
                          setState(() => _sliderValue1 = newValue),
                    ),
                    ArnaSliderListTile(
                      title: "Title 2",
                      subtitle: "Subtitle 2",
                      value: _sliderValue2,
                      min: 0,
                      max: 100,
                      onChanged: (double newValue) =>
                          setState(() => _sliderValue2 = newValue),
                      trailing: ArnaIconButton(
                        icon: Icons.add_outlined,
                        onPressed: () {},
                      ),
                    ),
                    ArnaSliderListTile(
                      title: "Title 3",
                      value: _sliderValue3,
                      min: 0,
                      max: 100,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.refresh_outlined),
                title: "Indicator",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    ArnaProgressIndicator(),
                    ArnaProgressIndicator(size: 119),
                  ],
                ),
              ),
              const ArnaExpansionPanel(
                leading: Icon(Icons.text_fields_outlined),
                title: "Text Field",
                child: ArnaTextField(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
