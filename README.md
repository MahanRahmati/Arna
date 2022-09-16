<img src="https://user-images.githubusercontent.com/16052180/169879175-298844aa-b75e-45b1-9006-1efb5d00baa9.png">

<p align="center">
  <a href="https://pub.dartlang.org/packages/arna"><img src="https://img.shields.io/pub/v/arna.svg" alt="pub.dev"></a>
  <a href="https://github.com/MahanRahmati/"><img src="https://img.shields.io/badge/Maintainer-MahanRahmati-informational"></a>
  <a href="https://github.com/leanflutter/awesome-flutter-desktop"> <img src="https://img.shields.io/badge/Awesome-Flutter%20Desktop-blue.svg" /></a>
  <a href="https://github.com/MahanRahmati/Arna/actions/workflows/pana_analysis.yml"><img src="https://github.com/MahanRahmati/Arna/actions/workflows/pana_analysis.yml/badge.svg"></a>
  <a href="https://github.com/MahanRahmati/Arna/actions/workflows/flutter_analysis.yml"><img src="https://github.com/MahanRahmati/Arna/actions/workflows/flutter_analysis.yml/badge.svg"></a>
  <img src="https://img.shields.io/github/license/MahanRahmati/arna">
</p>

## Introduction

Arna is a set of widgets designed to be simple and easy to use for building applications with Flutter. These widgets are designed to be clean, minimal, and modern. Arna is inspired by the GNOME project.

You can check the web version [here](https://mahanrahmati.github.io/arna_demo/).

## Made with Arna

- [Arna Translate](https://github.com/MahanRahmati/translate) - Alternative front-end for Google Translate.

## Getting Started

Add Arna as a dependency in your pubspec.yaml

```yaml
dependencies:
  arna: ^1.0.6
```

And import it

```dart
import 'package:arna/arna.dart';
```

## Donation

If you like Arna you can support developer with [monero](https://github.com/monero-project/monero). Thank you!

![monero](.github/monero.png)

`89nMEk2ZhypZDMkniyBiTsP1UrzMzEV9oNcAzdrxKo5HVuwB7kXA78iC9HaFLhdTBfHPzGrHL4ww9faGfvWFvxZo8kDkqcG`

## Platform Support

| Platform  | Android | iOS | Linux | MacOS | Web | Windows |
| --------- | ------- | --- | ----- | ----- | --- | ------- |
| Supported | ✅      | ✅  | ✅    | ✅    | ✅  | ✅      |

## Feature roadmap

See [ROADMAP](./ROADMAP.md).

## Widgets

| Arna                      | Material                      | Cupertino                             |
| ------------------------- | ----------------------------- | ------------------------------------- |
| ArnaApp                   | MaterialApp                   | CupertinoApp                          |
| ArnaLogo                  | FlutterLogo                   | -                                     |
| ArnaAvatar                | CircleAvatar                  | -                                     |
| ArnaBanner                | MaterialBanner                | -                                     |
| ArnaBaseWidget            | InkWell                       | -                                     |
| ArnaBody                  | -                             | -                                     |
| ArnaBottomBar             | NavigationBar                 | CupertinoTabBar                       |
| ArnaBottomBarItem         | NavigationDestination         | -                                     |
| ArnaDivider               | Divider                       | -                                     |
| ArnaDrawer                | Drawer                        | -                                     |
| ArnaHeaderBar             | AppBar                        | CupertinoNavigationBar                |
| ArnaSliverHeaderBar       | SliverAppBar                  | CupertinoSliverNavigationBar          |
| ArnaLicensePage           | LicensePage                   | -                                     |
| ArnaMasterDetailScaffold  | -                             | -                                     |
| ArnaMasterItem            | -                             | -                                     |
| ArnaPageIndicator         | -                             | -                                     |
| ArnaPage                  | MaterialPage                  | CupertinoPage                         |
| ArnaProgressIndicator     | ProgressIndicator             | CupertinoActivityIndicator            |
| ArnaPageRoute             | MaterialPageRoute             | CupertinoPageRoute                    |
| ArnaScaffold              | Scaffold                      | CupertinoPageScaffold                 |
| ArnaScrollbar             | Scrollbar                     | CupertinoScrollbar                    |
| ArnaSearchField           | SearchPage                    | CupertinoSearchTextField              |
| ArnaSelectableText        | SelectableText                | -                                     |
| ArnaSideBarItem           | -                             | -                                     |
| ArnaSideScaffold          | -                             | -                                     |
| ArnaSnackBar              | SnackBar                      | -                                     |
| ArnaTabItem               | Tab                           | -                                     |
| ArnaTabView               | TabBarView                    | CupertinoTabScaffold                  |
| ArnaTextSelectionControls | MaterialTextSelectionControls | CupertinoDesktopTextSelectionControls |
| ArnaTooltip               | Tooltip                       | -                                     |
| ArnaBackButton            | BackButton                    | -                                     |
| ArnaBorderlessButton      | -                             | -                                     |
| ArnaButton                | ElevatedButton                | CupertinoButton                       |
| ArnaCloseButton           | CloseButton                   | -                                     |
| ArnaColorButton           | -                             | -                                     |
| ArnaIconButton            | IconButton                    | -                                     |
| ArnaLinkedButtons         | -                             | -                                     |
| ArnaTextButton            | TextButton                    | -                                     |
| ArnaPillButton            | FloatingActionButton          | -                                     |
| ArnaBadge                 | -                             | -                                     |
| ArnaCard                  | Card                          | -                                     |
| ArnaExpansionPanel        | ExpansionPanel                | -                                     |
| ArnaGridTileBar           | GridTileBar                   | -                                     |
| ArnaGridTile              | GridTile                      | -                                     |
| ArnaList                  | -                             | -                                     |
| ArnaListTile              | ListTile                      | -                                     |
| ArnaReorderableList       | ReorderableListView           | -                                     |
| ArnaAboutDialog           | AboutDialog                   | -                                     |
| ArnaAlertDialog           | AlertDialog                   | CupertinoAlertDialog                  |
| ArnaDialog                | Dialog                        | -                                     |
| ArnaPopupDialog           | -                             | -                                     |
| ArnaAutocomplete          | Autocomplete                  | -                                     |
| ArnaCheckbox              | Checkbox                      | -                                     |
| ArnaCheckboxListTile      | CheckboxListTile              | -                                     |
| ArnaDropdownButton        | DropdownButton                | -                                     |
| ArnaPopupMenu             | PopupMenu                     | CupertinoContextMenu                  |
| ArnaRadio                 | Radio                         | -                                     |
| ArnaRadioListTile         | RadioListTile                 | -                                     |
| ArnaSegmentedControl      | Tab                           | CupertinoSegmentedControl             |
| ArnaSlider                | Slider                        | CupertinoSlider                       |
| ArnaSliderListTile        | -                             | -                                     |
| ArnaSwitch                | Switch                        | CupertinoSwitch                       |
| ArnaSwitchListTile        | SwitchListTile                | -                                     |
| ArnaTextField             | TextField                     | CupertinoTextField                    |
| ArnaTextFormField         | TextFormField                 | CupertinoTextFormFieldRow             |
| ArnaDatePicker            | DatePicker                    | CupertinoDatePicker                   |

## Contributing

Arna is in active development. Any contribution, idea, criticism or feedback is welcomed.

- If you know Flutter and Dart, we would love you to help us grow Arna more.
- If you are a designer, we would love to see more mockups for Arna.
- You can always file feature requests and bugs at the [issue tracker](https://github.com/MahanRahmati/Arna/issues).

## License

Arna is [BSD 3-Clause licensed](./LICENSE).

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
- [jhyns](https://github.com/jhyns) for [one_ui](https://github.com/jhyns/one_ui)
- [seel-channel](https://github.com/seel-channel) for [helpers](https://github.com/seel-channel/helpers)
