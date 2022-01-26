# Arna

Arna framework and widgets for Flutter.

## Content

- [Arna](#arna)
  - [Content](#content)
  - [Getting Started](#getting-started)
  - [Usage](#usage)
    - [ArnaApp](#arnaapp)
    - [ArnaScaffold](#arnascaffold)
    - [ArnaSideScaffold](#arnasidescaffold)
    - [ArnaButton](#arnabutton)
    - [ArnaIconButton](#arnaiconbutton)
    - [ArnaTextButton](#arnatextbutton)
    - [ArnaLinkedButtons](#arnalinkedbuttons)
    - [ArnaCheckBox](#arnacheckbox)
    - [ArnaCheckBoxListTile](#arnacheckboxlisttile)
    - [ArnaRadio](#arnaradio)
    - [ArnaRadioListTile](#arnaradiolisttile)
    - [ArnaSwitch](#arnaswitch)
    - [ArnaSwitchListTile](#arnaswitchlisttile)
    - [ArnaList](#arnalist)
    - [ArnaCard](#arnacard)
    - [ArnaBadge](#arnabadge)
    - [ArnaDividers](#arnadividers)
    - [ArnaSeparators](#arnaseparators)
    - [ArnaPopupDialog](#arnapopupdialog)
    - [ArnaDialog](#arnadialog)

## Getting Started

Add Arna as a dependency in your pubspec.yaml

```yaml
dependencies:
  arna: ^0.0.4
```

And import it

```dart
import 'package:arna/arna.dart';
```

## Usage

### ArnaApp

```dart
ArnaApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
);
```

### ArnaScaffold

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

### ArnaSideScaffold

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

### ArnaButton

```dart
ArnaButton(
    title: "Add",
    icon: Icons.add_outlined,
    onPressed: () {},
);
```

### ArnaIconButton

```dart
ArnaIconButton(
    icon: Icons.add_outlined,
    onPressed: () {},
);
```

### ArnaTextButton

```dart
ArnaTextButton(
    title: "Add",
    onPressed: () {},
);
```

### ArnaLinkedButtons

```dart
ArnaLinkedButtons(
    buttons: [
        ArnaLinkedButton(
            title: "Add",
            icon: Icons.add_outlined,
            onPressed: () {},
        ),
        ArnaLinkedIconButton(
            icon: Icons.add_outlined,
            onPressed: () {},
        ),
        ArnaLinkedTextButton(
            title: "Add",
            onPressed: () {},
        ),
    ],
);
```

### ArnaCheckBox

```dart
ArnaCheckBox(
    value: _throwShotAway,
    onChanged: (bool? newValue) => setState(() => _throwShotAway = newValue!),
);
```

### ArnaCheckBoxListTile

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

### ArnaRadio

```dart
ArnaRadio<SingingCharacter>(
    value: SingingCharacter.lafayette,
    groupValue: _character,
    onChanged: (SingingCharacter newValue) => setState(() => _character = newValue),
);
```

### ArnaRadioListTile

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

### ArnaSwitch

```dart
ArnaSwitch(
    value: _giveVerse,
    onChanged: (bool newValue) => setState(() => _giveVerse = newValue),
);
```

### ArnaSwitchListTile

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

### ArnaList

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

### ArnaCard

```dart
ArnaCard(
    height: 200,
    width: 200,
    child: Container(),
);
```

### ArnaBadge

```dart
ArnaBadge(title: "Title");
```

### ArnaDividers

```dart
ArnaHorizontalDivider();
ArnaVerticalDivider();
```

### ArnaSeparators

```dart
ArnaHorizontalSeparator();
ArnaVerticalSeparator();
```

### ArnaPopupDialog

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

### ArnaDialog

```dart
ArnaIconButton(
    icon: Icons.info_outlined,
    onPressed: () => ArnaDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => ArnaAlertDialog(
            title: "Title",
            message: "Message",
            primary: ArnaTextButton(
                title: "OK",
                onPressed: Navigator.of(context).pop,
            )
        ),
    ),
);
```
