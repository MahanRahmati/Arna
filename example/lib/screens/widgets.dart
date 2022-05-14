import 'package:arna/arna.dart';

class Widgets extends StatefulWidget {
  const Widgets({super.key});

  @override
  State<Widgets> createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  String _selectedType = '1';
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
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ArnaBanner(
          showBanner: _showBanner,
          title: 'This is an information banner!',
          subtitle: 'Hello There!',
          actions: <Widget>[
            ArnaBorderlessButton(
              icon: Icons.close_outlined,
              onPressed: () => setState(() => _showBanner = false),
            ),
          ],
        ),
        Flexible(
          child: SingleChildScrollView(
            child: ArnaList(
              title: 'Widgets',
              children: <Widget>[
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.adjust_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Buttons',
                  child: Center(
                    child: Wrap(
                      children: <Widget>[
                        ArnaIconButton(
                          icon: Icons.add_outlined,
                          onPressed: () {},
                          tooltipMessage: 'Add',
                        ),
                        ArnaTextButton(
                          label: 'Add',
                          onPressed: () {},
                        ),
                        ArnaButton(
                          label: 'Add',
                          icon: Icons.add_outlined,
                          onPressed: () {},
                        ),
                        const ArnaButton(
                          label: 'Add',
                          icon: Icons.add_outlined,
                          onPressed: null,
                          tooltipMessage: 'Add',
                        ),
                        ArnaIconButton(
                          icon: Icons.add_outlined,
                          buttonType: ButtonType.colored,
                          onPressed: () {},
                          tooltipMessage: 'Add',
                        ),
                        ArnaBorderlessButton(
                          icon: Icons.add_outlined,
                          onPressed: () {},
                          tooltipMessage: 'Add',
                        ),
                        ArnaPopupMenuButton<String>(
                          itemBuilder: (BuildContext context) => <ArnaPopupMenuEntry<String>>[
                            ArnaPopupMenuItem<String>(
                              value: 'First Item',
                              child: Text('First Item', style: ArnaTheme.of(context).textTheme.body),
                            ),
                            ArnaPopupMenuItem<String>(
                              value: 'Second Item',
                              child: Text('Second Item', style: ArnaTheme.of(context).textTheme.body),
                            ),
                            const ArnaPopupMenuDivider(),
                            ArnaPopupMenuItem<String>(
                              value: 'Third Item',
                              child: Text('Third Item', style: ArnaTheme.of(context).textTheme.body),
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
                  leading: Icon(
                    Icons.more_horiz_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Linked Buttons',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ArnaLinkedButtons(
                        buttons: <ArnaLinkedButton>[
                          ArnaLinkedButton(
                            icon: Icons.add_outlined,
                            onPressed: () {},
                            tooltipMessage: 'Add',
                          ),
                          ArnaLinkedButton(
                            label: 'Add',
                            onPressed: () {},
                          ),
                          ArnaLinkedButton(
                            label: 'Add',
                            icon: Icons.add_outlined,
                            onPressed: () {},
                          ),
                          const ArnaLinkedButton(
                            label: 'Add',
                            icon: Icons.add_outlined,
                            onPressed: null,
                          ),
                          ArnaLinkedButton(
                            icon: Icons.add_outlined,
                            buttonType: ButtonType.colored,
                            onPressed: () {},
                            tooltipMessage: 'Add',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.calendar_view_week_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Segmented Control',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ArnaSegmentedControl<int>(
                        groupValue: segmentedControlGroupValue,
                        children: const <int, String>{0: 'Item 1', 1: 'Item 2', 2: 'Item 3'},
                        onValueChanged: (int i) => setState(() => segmentedControlGroupValue = i),
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.check_box_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'CheckBox',
                  child: ArnaList(
                    showBackground: true,
                    showDividers: true,
                    children: <Widget>[
                      ArnaCheckBoxListTile(
                        value: _checkBox1,
                        title: 'CheckBox 1',
                        onChanged: (bool? value) => setState(() => _checkBox1 = value!),
                      ),
                      ArnaCheckBoxListTile(
                        value: _checkBox2,
                        title: 'CheckBox 2',
                        subtitle: 'Subtitle 2',
                        tristate: true,
                        onChanged: (bool? value) => setState(() => _checkBox2 = value),
                        trailing: ArnaButton(
                          icon: Icons.more_vert_outlined,
                          onPressed: () {},
                        ),
                      ),
                      ArnaCheckBoxListTile(
                        value: _checkBox3,
                        title: 'CheckBox 3',
                        onChanged: null,
                      )
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.radio_button_checked_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Radio',
                  child: ArnaList(
                    showBackground: true,
                    showDividers: true,
                    children: <Widget>[
                      ArnaRadioListTile<String>(
                        value: '1',
                        groupValue: _selectedType,
                        title: 'Radio 1',
                        onChanged: (String? value) => setState(() => _selectedType = value!),
                      ),
                      ArnaRadioListTile<String>(
                        value: '2',
                        groupValue: _selectedType,
                        title: 'Radio 2',
                        subtitle: 'Subtitle 2',
                        onChanged: (String? value) => setState(() => _selectedType = value!),
                        trailing: ArnaButton(
                          icon: Icons.more_vert_outlined,
                          onPressed: () {},
                        ),
                      ),
                      ArnaRadioListTile<String>(
                        value: '3',
                        groupValue: _selectedType,
                        title: 'Radio 3',
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.toggle_on_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Switch',
                  child: ArnaList(
                    showBackground: true,
                    showDividers: true,
                    children: <Widget>[
                      ArnaSwitchListTile(
                        title: 'Switch 1',
                        value: _switch1,
                        onChanged: (bool value) => setState(() => _switch1 = value),
                      ),
                      ArnaSwitchListTile(
                        title: 'Switch 2',
                        subtitle: 'Subtitle 2',
                        value: _switch2,
                        onChanged: (bool value) => setState(() => _switch2 = value),
                        trailing: ArnaButton(
                          icon: Icons.more_vert_outlined,
                          onPressed: () {},
                        ),
                      ),
                      ArnaSwitchListTile(
                        title: 'Switch 3',
                        value: _switch3,
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.view_list_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'List Tile',
                  child: ArnaList(
                    showBackground: true,
                    showDividers: true,
                    children: <Widget>[
                      ArnaListTile(
                        title: 'Title 1',
                        subtitle: 'Subtitle 1',
                        trailing: const ArnaBadge(label: '1'),
                        onTap: () {},
                      ),
                      const ArnaListTile(
                        title: 'Title 2',
                        trailing: ArnaBadge(label: '2'),
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.linear_scale_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Slider',
                  child: ArnaList(
                    showBackground: true,
                    showDividers: true,
                    children: <Widget>[
                      ArnaSliderListTile(
                        title: 'Title 1',
                        value: _sliderValue1,
                        max: 100,
                        onChanged: (double newValue) => setState(() => _sliderValue1 = newValue),
                      ),
                      ArnaSliderListTile(
                        title: 'Title 2',
                        subtitle: 'Subtitle 2',
                        value: _sliderValue2,
                        max: 100,
                        onChanged: (double newValue) => setState(() => _sliderValue2 = newValue),
                        trailing: ArnaButton(
                          icon: Icons.more_vert_outlined,
                          onPressed: () {},
                        ),
                      ),
                      ArnaSliderListTile(
                        title: 'Title 3',
                        value: _sliderValue3,
                        max: 100,
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.refresh_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Indicator',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      ArnaProgressIndicator(),
                      ArnaProgressIndicator(size: 119),
                    ],
                  ),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.text_fields_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Text Field',
                  child: const ArnaTextField(),
                ),
                ArnaExpansionPanel(
                  leading: Icon(
                    Icons.ad_units_outlined,
                    color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                  ),
                  title: 'Banner and SnackBar',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ArnaTextButton(
                        label: 'Show Banner',
                        onPressed: () {
                          if (!_showBanner) {
                            setState(() => _showBanner = true);
                          }
                        },
                      ),
                      ArnaTextButton(
                        label: 'Show SnackBar',
                        onPressed: () {
                          showArnaSnackbar(
                            context: context,
                            message: 'Hello There!',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
