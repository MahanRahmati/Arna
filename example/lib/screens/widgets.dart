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
        children: [
          ArnaList(
            title: "Widgets",
            items: [
              ArnaExpansionPanel(
                leading: const Icon(Icons.adjust_outlined),
                title: "Buttons",
                subtitle:
                    "Buttons allow users to take actions, and make choices, with a single tap.",
                child: Center(
                  child: Wrap(
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
                      ArnaPopupMenuButton<String>(
                        itemBuilder: (context) => [
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
                subtitle: "Buttons that are attached together.",
                child: Row(
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
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.calendar_view_week_outlined),
                title: "Segmented Control",
                subtitle:
                    "Segmented controls allow users to select one item from a set.",
                child: Row(
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
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.check_box_outlined),
                title: "CheckBox",
                subtitle:
                    "Checkboxes allow users to select one or more items from a set.",
                child: ArnaColumn(
                  children: [
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
                      onChanged: null,
                    )
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.radio_button_checked_outlined),
                title: "Radio",
                subtitle:
                    "Radio buttons allow users to select one option from a set.",
                child: ArnaColumn(
                  children: [
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
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.toggle_on_outlined),
                title: "Switch",
                subtitle:
                    "Switches toggle the state of a single item on or off.",
                child: ArnaColumn(
                  children: [
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
                      value: _switch3,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.view_list_outlined),
                title: "List Tile",
                subtitle: "Arna-styled list tile.",
                child: ArnaColumn(
                  children: [
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
              ),
              ArnaExpansionPanel(
                leading: const Icon(Icons.linear_scale_outlined),
                title: "Slider",
                subtitle:
                    "Sliders allow users to make selections from a range of values.",
                child: ArnaColumn(
                  children: [
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
                      trailingButton: ArnaIconButton(
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
                subtitle:
                    "Progress indicators express an unspecified wait time or display the length of a process.",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    ArnaProgressIndicator(),
                    ArnaProgressIndicator(size: 119),
                  ],
                ),
              ),
              const ArnaExpansionPanel(
                leading: Icon(Icons.text_fields_outlined),
                title: "Text Field",
                subtitle: "Text fields let users enter and edit text.",
                child: Padding(
                  padding: Styles.large,
                  child: ArnaTextField(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
