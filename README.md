# Arna

Arna Framework - A unique set of widgets for building applications with Flutter.

This Framework is in active development. Any contribution, idea, criticism or feedback is welcomed.

<p align="start">
  <a href="https://pub.dartlang.org/packages/arna"><img src="https://img.shields.io/pub/v/arna.svg" alt="pub.dev"></a>
  <a href="https://github.com/MahanRahmati/"><img src="https://img.shields.io/badge/Maintainer-MahanRahmati-informational"></a>
  <a href="https://github.com/leanflutter/awesome-flutter-desktop">
   <img alt="Awesome Flutter Desktop" src="https://img.shields.io/badge/Awesome-Flutter%20Desktop-blue.svg" /></a>
  <img src="https://img.shields.io/github/license/MahanRahmati/arna">
</p>

<img alt="Light" src="https://user-images.githubusercontent.com/16052180/156654600-b8be06db-1cb1-411b-adf9-0bba86dd9704.png">
<img alt="Dark" src="https://user-images.githubusercontent.com/16052180/156654550-cef8b2c8-b95a-41de-9d4e-903c6968637b.png">

## Content

- [Arna](#arna)
  - [Content](#content)
  - [Getting Started](#getting-started)
  - [Usage](#usage)
    - [Arna App](#arna-app)
    - [Arna Scaffold](#arna-scaffold)
    - [Arna Side Scaffold](#arna-side-scaffold)
    - [Arna Master Detail Scaffold](#arna-master-detail-scaffold)
    - [Arna Button](#arna-button)
    - [Arna Icon Button](#arna-icon-button)
    - [Arna Text Button](#arna-text-button)
    - [Arna Linked Buttons](#arna-linked-buttons)
    - [Arna Popup Menu Button](#arna-popup-menu-button)
    - [Arna Segmented Control](#arna-segmented-control)
    - [Arna CheckBox](#arna-checkbox)
    - [Arna CheckBox List Tile](#arna-checkbox-list-tile)
    - [Arna Radio](#arna-radio)
    - [Arna Radio List Tile](#arna-radio-list-tile)
    - [Arna Switch](#arna-switch)
    - [Arna Switch List Tile](#arna-switch-list-tile)
    - [Arna List](#arna-list)
    - [Arna Expansion Panel](#arna-expansion-panel)
    - [Arna Card](#arna-card)
    - [Arna Badge](#arna-badge)
    - [Arna Dividers](#arna-dividers)
    - [Arna Separators](#arna-separators)
    - [Arna PopupDialog](#arna-popupdialog)
    - [Arna Alert Dialog](#arna-alert-dialog)
    - [Arna Text Field](#arna-text-field)
    - [Arna Slider](#arna-slider)
    - [Arna Slider List Tile](#arna-slider-list-tile)
    - [Arna Tooltip](#arna-tooltip)
    - [Arna Indicator](#arna-indicator)
    - [Arna Search Field](#arna-search-field)
    - [Arna Snack Bar](#arna-snack-bar)
    - [Arna Banner](#arna-banner)
  - [TODO](#todo)
  - [Special thanks](#special-thanks)

## Getting Started

Add Arna as a dependency in your pubspec.yaml

```yaml
dependencies:
  arna: ^0.2.9
```

And import it

```dart
import 'package:arna/arna.dart';
```

## Usage

### Arna App

```dart
ArnaApp(
    debugShowCheckedModeBanner: false,
    theme: ArnaThemeData(
        accentColor: ArnaColors.accentColor,
        brightness: Brightness.light,
    ),
    home: Home(),
);
```

### Arna Scaffold

```dart
ArnaScaffold(
    headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
    title: "Title",
    headerBarTrailing: ArnaIconButton(
        icon: Icons.info_outlined,
        onPressed: () {},
    ),
    body: Container(),
);
```

### Arna Side Scaffold

```dart
ArnaSideScaffold(
    headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
    title: "Title",
    headerBarTrailing: ArnaIconButton(
        icon: Icons.info_outlined,
        onPressed: () {},
    ),
    items: [
        NavigationItem(
          title: "Dummy",
          icon: Icons.info_outlined,
          builder: (_) => Container(),
        ),
        NavigationItem(
          title: "Dummy",
          icon: Icons.info_outlined,
          builder: (_) => Container(),
        ),
    ],
);
```

### Arna Master Detail Scaffold

```dart
ArnaMasterDetailScaffold(
    headerBarLeading: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
    title: "Title",
    headerBarTrailing: ArnaIconButton(
        icon: Icons.info_outlined,
        onPressed: () {},
    ),
    emptyBody : Container(),
    items: [
        MasterNavigationItem(
          title: "Title 1",
          subtitle: "Subtitle 1",
          builder: (_) => Container(),
        ),
        MasterNavigationItem(
          title: "Title 2",
          subtitle: "Subtitle 2",
          builder: (_) => Container(),
        ),
    ],
);
```

### Arna Button

```dart
ArnaButton(
    label: "Add",
    icon: Icons.add_outlined,
    onPressed: () {},
);
```

### Arna Icon Button

```dart
ArnaIconButton(
    icon: Icons.add_outlined,
    onPressed: () {},
    tooltipMessage: "Add",
);
```

### Arna Text Button

```dart
ArnaTextButton(
    label: "Add",
    onPressed: () {},
    tooltipMessage: "Add",
);
```

### Arna Linked Buttons

```dart
ArnaLinkedButtons(
    buttons: [
        ArnaLinkedButton(
            label: "Add",
            icon: Icons.add_outlined,
            onPressed: () {},
            tooltipMessage: "Add",
        ),
        ArnaLinkedButton(
            icon: Icons.add_outlined,
            onPressed: () {},
            tooltipMessage: "Add",
        ),
        ArnaLinkedButton(
            label: "Add",
            onPressed: () {},
            tooltipMessage: "Add",
        ),
    ],
);
```

### Arna Popup Menu Button

```dart
ArnaPopupMenuButton<String>(
    itemBuilder: (context) => [
        ArnaPopupMenuItem(
            child: Text(
                "First Item",
                style: ArnaTheme.of(context).textTheme.textStyle,
                ),
                value: "First Item",
            ),
        const ArnaPopupMenuDivider(),
        ArnaPopupMenuItem(
            child: Text(
                "Second Item",
                style: ArnaTheme.of(context).textTheme.textStyle,
                ),
                value: "Second Item",
            ),
    ],
    onSelected: (String value) => showArnaSnackbar(
        context: context,
        message: value,
    ),
);
```

### Arna Segmented Control

```dart
ArnaSegmentedControl(
    groupValue: segmentedControlGroupValue,
    children: {0: "Item 1", 1: "Item 2", 2: "Item 3"},
    onValueChanged: (int i) => setState(() => segmentedControlGroupValue = i),
);
```

### Arna CheckBox

```dart
ArnaCheckBox(
    value: _throwShotAway,
    onChanged: (bool? newValue) => setState(() => _throwShotAway = newValue!),
);
```

### Arna CheckBox List Tile

```dart
ArnaCheckBoxListTile(
    value: _throwShotAway,
    title: "Title",
    subtitle: "Subtitle",
    onChanged: (bool? newValue) => setState(() => _throwShotAway = newValue!),
    trailingButton: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna Radio

```dart
ArnaRadio<SingingCharacter>(
    value: SingingCharacter.lafayette,
    groupValue: _character,
    onChanged: (SingingCharacter newValue) => setState(() => _character = newValue),
);
```

### Arna Radio List Tile

```dart
ArnaRadioListTile<SingingCharacter>(
    value: SingingCharacter.lafayette,
    groupValue: _character,
    title: "Title",
    subtitle: "Subtitle",
    onChanged: (SingingCharacter newValue) => setState(() => _character = newValue),
    trailingButton: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna Switch

```dart
ArnaSwitch(
    value: _giveVerse,
    onChanged: (bool newValue) => setState(() => _giveVerse = newValue),
);
```

### Arna Switch List Tile

```dart
ArnaSwitchListTile(
    value: _giveVerse,
    title: "Title",
    subtitle: "Subtitle",
    onChanged: (bool newValue) => setState(() => _giveVerse = newValue),
    trailingButton: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna List

```dart
ArnaList(
    title: "Title",
    items: [
        ArnaListTile(
            title: "Title 1",
            subtitle: "Subtitle 1",
            trailing: ArnaBadge(title: "Badge 1"),
            onTap: () {},
        ),
        ArnaListTile(
            title: "Title 2",
            subtitle: "Subtitle 2",
            trailing: ArnaBadge(title: "Badge 2"),
        ),
    ],
);
```

### Arna Expansion Panel

```dart
ArnaExpansionPanel(
    title: "Title 1",
    subtitle: "Subtitle 1",
    child: Container(),
);
```

### Arna Card

```dart
ArnaCard(
    height: 200,
    width: 200,
    child: Container(),
);
```

### Arna Badge

```dart
ArnaBadge(title: "Title");
```

### Arna Dividers

```dart
ArnaHorizontalDivider();
ArnaVerticalDivider();
```

### Arna Separators

```dart
ArnaHorizontalSeparator();
ArnaVerticalSeparator();
```

### Arna PopupDialog

```dart
ArnaIconButton(
    icon: Icons.info_outlined,
    onPressed: () => showArnaPopupDialog(
        context: context,
        title: "Title",
        body: Container(),
    ),
);
```

### Arna Alert Dialog

```dart
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
);
```

### Arna Text Field

```dart
ArnaTextField(
  obscureText: true,
);
```

### Arna Slider

```dart
ArnaSlider(
    value: _sliderValue,
    min: 0,
    max: 100,
    onChanged: (double newValue) {
        setState(() => _sliderValue = newValue);
    },
);
```

### Arna Slider List Tile

```dart
ArnaSliderListTile(
    value: _sliderValue,
    title: "Title",
    subtitle: "Subtitle",
    onChanged: (double newValue) {
        setState(() => _sliderValue = newValue);
    },
    trailingButton: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna Tooltip

```dart
ArnaTooltip(
    message: _sliderValue,
    child: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna Indicator

```dart
ArnaIndicator(value: 0.35);
```

### Arna Search Field

```dart
ArnaSearchField(
    showSearch: showSearch,
    controller: controller,
);
```

### Arna Snack Bar

```dart
showArnaSnackbar(
    context: context,
    message: "SnackBar Title",
    trailing: ArnaIconButton(
        icon: Icons.add_outlined,
        onPressed: () {},
    ),
);
```

### Arna Banner

```dart
ArnaBanner(
    showBanner: showBanner,
    title: "This is an information banner!",
    trailing: ArnaIconButton(
        icon: Icons.close_outlined,
        onPressed: () => setState(() => showBanner = false),
    ),
);
```

## TODO

- Dropdown Button
- Popup Button
- Date and Time Pickers
- Chip

## Special thanks

- [flutter](https://github.com/flutter/) for [flutter](https://github.com/flutter/flutter/).
- [bdlukaa](https://github.com/bdlukaa) for [fluent_ui](https://github.com/bdlukaa/fluent_ui).
- [GroovinChip](https://github.com/GroovinChip) for [macos_ui](https://github.com/GroovinChip/macos_ui).
- [gtk-flutter](https://github.com/gtk-flutter) for [libadwaita](https://github.com/gtk-flutter/libadwaita).
- [ubuntu](https://github.com/ubuntu) for [yaru_widgets.dart](https://github.com/ubuntu/yaru_widgets.dart) and [yaru.dart](https://github.com/ubuntu/yaru.dart).
- [tvolkert](https://github.com/tvolkert) for [chicago](https://github.com/tvolkert/chicago).
- [rsms](https://github.com/rsms) for [inter](https://github.com/rsms/inter).
- [WangYng](https://github.com/WangYng) for [better_cupertino_slider](https://github.com/WangYng/better_cupertino_slider).
- [MingSern](https://github.com/MingSern) for [flutter_bounceable](https://github.com/MingSern/flutter_bounceable).
