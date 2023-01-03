import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

/// Initial display of a calendar date picker.
///
/// Either a grid of available years or a monthly calendar.
///
/// See also:
///
///  * [showArnaDatePicker], which shows a dialog that contains a date picker.
///  * [ArnaCalendarDatePicker], widget which implements the date picker.
enum ArnaDatePickerMode {
  /// Choosing a month and day.
  day,

  /// Choosing a year.
  year,
}

/// Signature for predicating dates for enabled date selections.
///
/// See [showArnaDatePicker], which has an [ArnaSelectableDayPredicate] parameter used to specify allowable days in the
/// date picker.
typedef ArnaSelectableDayPredicate = bool Function(DateTime day);

/// Shows a dialog containing a date picker.
///
/// The returned [Future] resolves to the date selected by the user when the user confirms the dialog. If the user
/// cancels the dialog, null is returned.
///
/// When the date picker is first displayed, it will show the month of [initialDate], with [initialDate] selected.
///
/// The [firstDate] is the earliest allowable date. The [lastDate] is the latest allowable date. [initialDate] must
/// either fall between these dates, or be equal to one of them. For each of these [DateTime] parameters, only their
/// dates are considered. Their time fields are ignored. They must all be non-null.
///
/// The [currentDate] represents the current day (i.e. today). This date will be highlighted in the day grid. If null,
/// the date of `DateTime.now()` will be used.
///
/// An optional [selectableDayPredicate] function can be passed in to only allow certain days for selection. If
/// provided, only the days that [selectableDayPredicate] returns true for will be selectable. For example, this can be
/// used to only allow weekdays for selection. If provided, it must return true for [initialDate].
///
/// The following optional string parameters allow you to override the default text used for various parts of the
/// dialog:
///
///   * [helpText], label displayed at the top of the dialog.
///   * [confirmText], label on the ok button.
///
/// An optional [locale] argument can be used to set the locale for the date picker. It defaults to the ambient locale
/// provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction ([TextDirection.ltr] or
/// [TextDirection.rtl]) for the date picker. It defaults to the ambient text direction provided by [Directionality].
/// If both [locale] and [textDirection] are non-null, [textDirection] overrides the direction chosen for the [locale].
///
/// The [context], [useRootNavigator] and [routeSettings] arguments are passed to [showArnaDialog], the documentation
/// for which discusses how it is used. [context] and [useRootNavigator] must be non-null.
///
/// An optional [initialDatePickerMode] argument can be used to have the calendar date picker initially appear in the
/// [ArnaDatePickerMode.year] or [ArnaDatePickerMode.day] mode. It defaults to [ArnaDatePickerMode.day], and must be
/// non-null.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// ### State Restoration
///
/// Using this method will not enable state restoration for the date picker. In order to enable state restoration for a
/// date picker, use [Navigator.restorablePush] or [Navigator.restorablePushNamed] with [ArnaDatePickerDialog].
///
/// For more information about state restoration, see [RestorationManager].
///
/// {@macro flutter.widgets.RestorationManager}
///
/// See also:
///
///  * [ArnaCalendarDatePicker], which provides the calendar grid used by the date picker dialog.
///  * [DisplayFeatureSubScreen], which documents the specifics of how [DisplayFeature]s can split the screen into
///    sub-screens.
Future<DateTime?> showArnaDatePicker({
  required final BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  final DateTime? currentDate,
  final ArnaSelectableDayPredicate? selectableDayPredicate,
  final String? helpText,
  final String? confirmText,
  final Locale? locale,
  final bool useRootNavigator = true,
  final RouteSettings? routeSettings,
  final TextDirection? textDirection,
  final TransitionBuilder? builder,
  final ArnaDatePickerMode initialDatePickerMode = ArnaDatePickerMode.day,
  final Offset? anchorPoint,
}) async {
  initialDate = ArnaDateUtils.dateOnly(initialDate);
  firstDate = ArnaDateUtils.dateOnly(firstDate);
  lastDate = ArnaDateUtils.dateOnly(lastDate);
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(
    selectableDayPredicate == null || selectableDayPredicate(initialDate),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
  );

  Widget dialog = ArnaDatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showArnaDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (final BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

/// An Arna-style date picker dialog.
///
/// It is used internally by [showArnaDatePicker] or can be directly pushed onto the [Navigator] stack to enable state
/// restoration. See [showArnaDatePicker] for a state restoration app example.
///
/// See also:
///
///  * [showArnaDatePicker], which is a way to display the date picker.
class ArnaDatePickerDialog extends StatefulWidget {
  /// An Arna-style date picker dialog.
  ArnaDatePickerDialog({
    super.key,
    required final DateTime initialDate,
    required final DateTime firstDate,
    required final DateTime lastDate,
    final DateTime? currentDate,
    this.selectableDayPredicate,
    this.confirmText,
    this.helpText,
    this.initialCalendarMode = ArnaDatePickerMode.day,
    this.restorationId,
  })  : initialDate = ArnaDateUtils.dateOnly(initialDate),
        firstDate = ArnaDateUtils.dateOnly(firstDate),
        lastDate = ArnaDateUtils.dateOnly(lastDate),
        currentDate = ArnaDateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          selectableDayPredicate!(this.initialDate),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate',
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Function to provide full control over which [DateTime] can be selected.
  final ArnaSelectableDayPredicate? selectableDayPredicate;

  /// The text that is displayed on the confirm button.
  final String? confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// The initial display of the calendar picker.
  final ArnaDatePickerMode initialCalendarMode;

  /// Restoration ID to save and restore the state of the [ArnaDatePickerDialog].
  ///
  /// If it is non-null, the date picker will persist and restore the date selected on the dialog.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed from the surrounding [RestorationScope]
  /// using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in Flutter.
  final String? restorationId;

  @override
  State<ArnaDatePickerDialog> createState() => _ArnaDatePickerDialogState();
}

/// The [State] for an [ArnaDatePickerDialog].
class _ArnaDatePickerDialogState extends State<ArnaDatePickerDialog>
    with RestorationMixin {
  final GlobalKey _calendarPickerKey = GlobalKey();
  late final RestorableDateTime _selectedDate = RestorableDateTime(
    widget.initialDate,
  );

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(
    final RestorationBucket? oldBucket,
    final bool initialRestore,
  ) {
    registerForRestoration(_selectedDate, 'selected_date');
  }

  @override
  Widget build(final BuildContext context) {
    return ArnaDialog(
      child: SizedBox(
        width: ArnaHelpers.isCompact(context)
            ? ArnaHelpers.deviceWidth(context) - Styles.largePadding
            : Styles.dialogSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ArnaHeaderBar(
              leading: const ArnaCloseButton(),
              middle: Text(
                widget.helpText ??
                    MaterialLocalizations.of(context).datePickerHelpText,
                style: ArnaTheme.of(context).textTheme.title,
              ),
            ),
            ArnaCalendarDatePicker(
              key: _calendarPickerKey,
              initialDate: _selectedDate.value,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              currentDate: widget.currentDate,
              onDateChanged: (final DateTime date) =>
                  setState(() => _selectedDate.value = date),
              selectableDayPredicate: widget.selectableDayPredicate,
              initialCalendarMode: widget.initialCalendarMode,
            ),
            const ArnaDivider(),
            ColoredBox(
              color: ArnaColors.backgroundColor.resolveFrom(context),
              child: Padding(
                padding: Styles.normal,
                child: ArnaButton.text(
                  onPressed: () => Navigator.pop(context, _selectedDate.value),
                  buttonSize: ButtonSize.huge,
                  label: widget.confirmText ??
                      MaterialLocalizations.of(context).okButtonLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays a grid of days for a given month and allows the user to select a date.
///
/// Days are arranged in a rectangular grid with one column for each day of the week. Controls are provided to change
/// the year and month that the grid is showing.
///
/// The calendar picker widget is rarely used directly. Instead, consider using [showArnaDatePicker], which will create
/// a dialog that uses this widget.
///
/// See also:
///
///  * [showArnaDatePicker], which creates a Dialog that contains an [ArnaCalendarDatePicker].
class ArnaCalendarDatePicker extends StatefulWidget {
  /// Creates a calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day indicated by [initialDate] will be
  /// selected.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track the currently displayed month.
  ///
  /// The user interface provides a way to change the year of the month being displayed. By default it will show the
  /// day grid, but this can be changed to start in the year selection interface with [initialCalendarMode] set to
  /// [ArnaDatePickerMode.year].
  ///
  /// The [initialDate], [firstDate], [lastDate], [onDateChanged], and [initialCalendarMode] must be non-null.
  ///
  /// [lastDate] must be after or equal to [firstDate].
  ///
  /// [initialDate] must be between [firstDate] and [lastDate] or equal to one of them.
  ///
  /// [currentDate] represents the current day (i.e. today). This date will be highlighted in the day grid. If null,
  /// the date of `DateTime.now()` will be used.
  ///
  /// If [selectableDayPredicate] is non-null, it must return `true` for the [initialDate].
  ArnaCalendarDatePicker({
    super.key,
    required final DateTime initialDate,
    required final DateTime firstDate,
    required final DateTime lastDate,
    final DateTime? currentDate,
    required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = ArnaDatePickerMode.day,
    this.selectableDayPredicate,
  })  : initialDate = ArnaDateUtils.dateOnly(initialDate),
        firstDate = ArnaDateUtils.dateOnly(firstDate),
        lastDate = ArnaDateUtils.dateOnly(lastDate),
        currentDate = ArnaDateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          selectableDayPredicate!(this.initialDate),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate.',
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The initial display of the calendar picker.
  final ArnaDatePickerMode initialCalendarMode;

  /// Function to provide full control over which dates in the calendar can be selected.
  final ArnaSelectableDayPredicate? selectableDayPredicate;

  @override
  State<ArnaCalendarDatePicker> createState() => _ArnaCalendarDatePickerState();
}

/// The [State] for an [ArnaCalendarDatePicker].
class _ArnaCalendarDatePickerState extends State<ArnaCalendarDatePicker> {
  bool _announcedInitialDate = false;
  late ArnaDatePickerMode _mode;
  late DateTime _currentDisplayedMonthDate;
  late DateTime _selectedDate;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialCalendarMode;
    _currentDisplayedMonthDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(final ArnaCalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCalendarMode != oldWidget.initialCalendarMode) {
      _mode = widget.initialCalendarMode;
    }
    if (!ArnaDateUtils.isSameDay(widget.initialDate, oldWidget.initialDate)) {
      _currentDisplayedMonthDate = DateTime(
        widget.initialDate.year,
        widget.initialDate.month,
      );
      _selectedDate = widget.initialDate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        _localizations.formatFullDate(_selectedDate),
        _textDirection,
      );
    }
  }

  void _handleModeChanged(final ArnaDatePickerMode mode) {
    ArnaFeedback.forLongPress(context);
    setState(() {
      _mode = mode;
      SemanticsService.announce(
        _mode == ArnaDatePickerMode.day
            ? _localizations.formatMonthYear(_selectedDate)
            : _localizations.formatYear(_selectedDate),
        _textDirection,
      );
    });
  }

  void _handleMonthChanged(final DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    ArnaFeedback.forLongPress(context);

    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }

    setState(() {
      _mode = ArnaDatePickerMode.day;
      _handleMonthChanged(value);
    });
  }

  void _handleDayChanged(final DateTime value) {
    ArnaFeedback.forLongPress(context);
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate);
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case ArnaDatePickerMode.day:
        return _ArnaMonthPicker(
          key: _monthPickerKey,
          initialMonth: _currentDisplayedMonthDate,
          currentDate: widget.currentDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          selectedDate: _selectedDate,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthChanged,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case ArnaDatePickerMode.year:
        return Padding(
          padding: const EdgeInsets.only(top: Styles.pickerTopRowHeight),
          child: _ArnaYearPicker(
            key: _yearPickerKey,
            currentDate: widget.currentDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _currentDisplayedMonthDate,
            selectedDate: _selectedDate,
            onChanged: _handleYearChanged,
          ),
        );
    }
  }

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        SizedBox(
          height: Styles.pickerTopRowHeight + Styles.pickerRowHeight * (8),
          child: _buildPicker(),
        ),
        ArnaButton.text(
          label: _localizations.formatMonthYear(_currentDisplayedMonthDate),
          onPressed: () {
            _handleModeChanged(
              _mode == ArnaDatePickerMode.day
                  ? ArnaDatePickerMode.year
                  : ArnaDatePickerMode.day,
            );
          },
        )
      ],
    );
  }
}

/// An Arna month picker.
class _ArnaMonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _ArnaMonthPicker({
    super.key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

  /// The initial month to display.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final ArnaSelectableDayPredicate? selectableDayPredicate;

  @override
  State<_ArnaMonthPicker> createState() => _ArnaMonthPickerState();
}

/// The [State] for a [_ArnaMonthPicker].
class _ArnaMonthPickerState extends State<_ArnaMonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  Map<ShortcutActivator, Intent>? _shortcutMap;
  Map<Type, Action<Intent>>? _actionMap;
  late FocusNode _dayGridFocus;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
      initialPage: ArnaDateUtils.monthDelta(widget.firstDate, _currentMonth),
    );
    _shortcutMap = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
        TraversalDirection.left,
      ),
      SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
        TraversalDirection.right,
      ),
      SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
        TraversalDirection.down,
      ),
      SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
        TraversalDirection.up,
      ),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent: CallbackAction<NextFocusIntent>(
        onInvoke: _handleGridNextFocus,
      ),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
        onInvoke: _handleGridPreviousFocus,
      ),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
        onInvoke: _handleDirectionFocus,
      ),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void didUpdateWidget(final _ArnaMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != oldWidget.initialMonth &&
        widget.initialMonth != _currentMonth) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      WidgetsBinding.instance.addPostFrameCallback(
        (final Duration timeStamp) =>
            _showMonth(widget.initialMonth, jump: true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(final DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(final int monthPage) {
    setState(() {
      final DateTime monthDate = ArnaDateUtils.addMonthsToMonthDate(
        widget.firstDate,
        monthPage,
      );
      if (!ArnaDateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !ArnaDateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the focused day is not in this month. Choose a
          // new one trying to keep the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
        SemanticsService.announce(
          _localizations.formatMonthYear(_currentMonth),
          _textDirection,
        );
      }
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned, otherwise the first selectable day in the
  /// month will be returned. If no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(
    final DateTime month,
    final int preferredDay,
  ) {
    final int daysInMonth = ArnaDateUtils.getDaysInMonth(
      month.year,
      month.month,
    );

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      _pageController.nextPage(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      _pageController.previousPage(
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
      );
    }
  }

  /// Navigate to the given month.
  void _showMonth(final DateTime month, {final bool jump = false}) {
    final int monthPage = ArnaDateUtils.monthDelta(widget.firstDate, month);
    if (jump) {
      _pageController.jumpToPage(monthPage);
    } else {
      _pageController.animateToPage(
        monthPage,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstMonth {
    return !_currentMonth.isAfter(
      DateTime(
        widget.firstDate.year,
        widget.firstDate.month,
      ),
    );
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastMonth {
    return !_currentMonth.isBefore(
      DateTime(
        widget.lastDate.year,
        widget.lastDate.month,
      ),
    );
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(final bool focused) {
    setState(() {
      if (focused && _focusedDay == null) {
        if (ArnaDateUtils.isSameMonth(widget.selectedDate, _currentMonth)) {
          _focusedDay = widget.selectedDate;
        } else if (ArnaDateUtils.isSameMonth(
          widget.currentDate,
          _currentMonth,
        )) {
          _focusedDay = _focusableDayForMonth(
            _currentMonth,
            widget.currentDate.day,
          );
        } else {
          _focusedDay = _focusableDayForMonth(_currentMonth, 1);
        }
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(final NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(final PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in the given direction. If the new date is
  /// not in the current month, then the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending on the current [TextDirection]). For
  /// vertical directions it will move up and down a week at a time.
  void _handleDirectionFocus(final DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime? nextDate = _nextDateInDirection(
        _focusedDay!,
        intent.direction,
      );
      if (nextDate != null) {
        _focusedDay = nextDate;
        if (!ArnaDateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          _showMonth(_focusedDay!);
        }
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
    TraversalDirection traversalDirection,
    final TextDirection textDirection,
  ) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(
    final DateTime date,
    final TraversalDirection direction,
  ) {
    final TextDirection textDirection = Directionality.of(context);
    DateTime nextDate = ArnaDateUtils.addDaysToDate(
      date,
      _dayDirectionOffset(direction, textDirection),
    );
    while (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }
      nextDate = ArnaDateUtils.addDaysToDate(
        nextDate,
        _dayDirectionOffset(direction, textDirection),
      );
    }
    return null;
  }

  bool _isSelectable(final DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(final BuildContext context, final int index) {
    final DateTime month = ArnaDateUtils.addMonthsToMonthDate(
      widget.firstDate,
      index,
    );
    return _ArnaDayPicker(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      child: Column(
        children: <Widget>[
          Container(
            height: Styles.pickerTopRowHeight,
            padding: Styles.smallHorizontal,
            child: Row(
              children: <Widget>[
                ArnaButton.icon(
                  icon: Icons.chevron_left,
                  tooltipMessage: _isDisplayingFirstMonth
                      ? null
                      : _localizations.previousMonthTooltip,
                  onPressed:
                      _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
                const Spacer(),
                ArnaButton.icon(
                  icon: Icons.chevron_right,
                  tooltipMessage: _isDisplayingLastMonth
                      ? null
                      : _localizations.nextMonthTooltip,
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ],
            ),
          ),
          Expanded(
            child: FocusableActionDetector(
              shortcuts: _shortcutMap,
              actions: _actionMap,
              focusNode: _dayGridFocus,
              onFocusChange: _handleGridFocusChange,
              child: _ArnaFocusedDate(
                date: _dayGridFocus.hasFocus ? _focusedDay : null,
                child: PageView.builder(
                  key: _pageViewKey,
                  controller: _pageController,
                  itemBuilder: _buildItems,
                  itemCount: ArnaDateUtils.monthDelta(
                        widget.firstDate,
                        widget.lastDate,
                      ) +
                      1,
                  onPageChanged: _handleMonthPageChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_ArnaMonthPicker] to let its children [_ArnaDayPicker]s know what the currently focused date
/// (if any) should be.
class _ArnaFocusedDate extends InheritedWidget {
  /// Creates a focused date.
  const _ArnaFocusedDate({
    required super.child,
    this.date,
  });

  /// An instant in time.
  final DateTime? date;

  @override
  bool updateShouldNotify(final _ArnaFocusedDate oldWidget) =>
      !ArnaDateUtils.isSameDay(
        date,
        oldWidget.date,
      );

  static DateTime? of(final BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ArnaFocusedDate>()?.date;
  }
}

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of the week.
class _ArnaDayPicker extends StatefulWidget {
  /// Creates a day picker.
  _ArnaDayPicker({
    super.key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.selectableDayPredicate,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(!selectedDate.isBefore(firstDate)),
        assert(!selectedDate.isAfter(lastDate));

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final ArnaSelectableDayPredicate? selectableDayPredicate;

  @override
  State<_ArnaDayPicker> createState() => _ArnaDayPickerState();
}

/// The [State] for a [_ArnaDayPicker].
class _ArnaDayPickerState extends State<_ArnaDayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = ArnaDateUtils.getDaysInMonth(
      widget.displayedMonth.year,
      widget.displayedMonth.month,
    );
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (final int index) => FocusNode(
        skipTraversal: true,
        debugLabel: 'Day ${index + 1}',
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _ArnaFocusedDate.of(context);
    if (focusedDate != null &&
        ArnaDateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the returned list corresponds to the first
  /// day of week for the current locale.
  ///
  /// Examples:
  ///
  /// ```
  /// ┌ Sunday is the first day of week in the US (en_US)
  /// |
  /// S M T W T F S  <-- the returned list contains these widgets
  /// _ _ _ _ _ 1 2
  /// 3 4 5 6 7 8 9
  ///
  /// ┌ But it's Monday in the UK (en_GB)
  /// |
  /// M T W T F S S  <-- the returned list contains these widgets
  /// _ _ _ _ 1 2 3
  /// 4 5 6 7 8 9 10
  /// ```
  List<Widget> _dayHeaders(
    final TextStyle? headerStyle,
    final MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(
        ExcludeSemantics(
          child: Center(child: Text(weekday, style: headerStyle)),
        ),
      );
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  List<Widget> _buildDayItems(final BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextStyle? headerStyle = ArnaTheme.of(context).textTheme.body?.apply(
          color: ArnaColors.disabledColor.resolveFrom(context),
        );

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = ArnaDateUtils.getDaysInMonth(year, month);
    final int dayOffset = ArnaDateUtils.firstDayOffset(
      year,
      month,
      localizations,
    );

    final List<Widget> dayItems = _dayHeaders(headerStyle, localizations);

    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    final int day = -dayOffset;

    for (int i = day + 1; i < daysInMonth + 1; i++) {
      if (i < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, i);
        final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
            dayToBuild.isBefore(widget.firstDate) ||
            (widget.selectableDayPredicate != null &&
                !widget.selectableDayPredicate!(dayToBuild));
        final bool isSelectedDay = ArnaDateUtils.isSameDay(
          widget.selectedDate,
          dayToBuild,
        );
        final bool isToday = ArnaDateUtils.isSameDay(
          widget.currentDate,
          dayToBuild,
        );

        final Color accentColor = ArnaTheme.of(context).accentColor;

        dayItems.add(
          isDisabled
              ? ExcludeSemantics(
                  child: Center(
                    child: Text(
                      localizations.formatDecimal(i),
                      style: ArnaTheme.of(context).textTheme.body!.apply(
                            color: ArnaColors.primaryTextColor
                                .resolveFrom(context),
                          ),
                    ),
                  ),
                )
              : ArnaBaseWidget(
                  builder: (
                    final BuildContext context,
                    final bool enabled,
                    final bool hover,
                    final bool focused,
                    final bool pressed,
                    final bool selected,
                  ) {
                    return Semantics(
                      // We want the day of month to be spoken first irrespective of the locale-specific preferences or
                      // TextDirection. This is because an accessibility user is more likely to be interested in the day of
                      // month before the rest of the date, as they are looking for the day of month. To do that we prepend
                      // day of month to the formatted full date.
                      label:
                          '${localizations.formatDecimal(i)}, ${localizations.formatFullDate(dayToBuild)}',
                      selected: isSelectedDay,
                      excludeSemantics: true,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isToday || focused
                                ? accentColor
                                : ArnaColors.transparent,
                          ),
                          color: isDisabled
                              ? ArnaColors.transparent
                              : isSelectedDay
                                  ? accentColor
                                  : pressed || hover || focused
                                      ? ArnaDynamicColor.applyOverlay(
                                          ArnaColors.cardColor.resolveFrom(
                                            context,
                                          ),
                                        )
                                      : ArnaColors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            localizations.formatDecimal(i),
                            style: ArnaTheme.of(context).textTheme.body!.apply(
                                  color: isDisabled
                                      ? ArnaColors.disabledColor.resolveFrom(
                                          context,
                                        )
                                      : isSelectedDay
                                          ? ArnaDynamicColor.onBackgroundColor(
                                              accentColor,
                                            )
                                          : isToday
                                              ? accentColor
                                              : ArnaColors.primaryTextColor
                                                  .resolveFrom(
                                                  context,
                                                ),
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                  onPressed: () => widget.onChanged(dayToBuild),
                  focusNode: _dayFocusNodes[i - 1],
                ),
        );
      }
    }

    return dayItems;
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: Styles.normal,
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: _dayPickerGridDelegate,
        childrenDelegate: SliverChildListDelegate(
          _buildDayItems(context),
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}

/// _ArnaDayPickerGridDelegate class.
class _ArnaDayPickerGridDelegate extends SliverGridDelegate {
  /// Creates a day picker grid delegate.
  const _ArnaDayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(final SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    const double tileHeight = Styles.pickerRowHeight;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(final _ArnaDayPickerGridDelegate oldDelegate) => false;
}

/// _dayPickerGridDelegate.
const _ArnaDayPickerGridDelegate _dayPickerGridDelegate =
    _ArnaDayPickerGridDelegate();

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using [ArnaCalendarDatePicker], or
/// [showArnaDatePicker] which create full date pickers.
///
/// See also:
///
///  * [ArnaCalendarDatePicker], which provides a date picker interface.
///  * [showArnaDatePicker], which shows a dialog containing a date picker.
class _ArnaYearPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [firstDate], [lastDate], [selectedDate], and [onChanged] arguments must be non-null. The [lastDate] must be
  /// after the [firstDate].
  _ArnaYearPicker({
    super.key,
    final DateTime? currentDate,
    required this.firstDate,
    required this.lastDate,
    final DateTime? initialDate,
    required this.selectedDate,
    required this.onChanged,
  })  : assert(!firstDate.isAfter(lastDate)),
        currentDate = ArnaDateUtils.dateOnly(currentDate ?? DateTime.now()),
        initialDate = ArnaDateUtils.dateOnly(initialDate ?? selectedDate);

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The initial date to center the year display around.
  final DateTime initialDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  @override
  State<_ArnaYearPicker> createState() => _ArnaYearPickerState();
}

/// The [State] for a [_ArnaYearPicker].
class _ArnaYearPickerState extends State<_ArnaYearPicker> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _scrollOffsetForYear(widget.selectedDate),
    );
  }

  @override
  void didUpdateWidget(final _ArnaYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _scrollController.jumpTo(_scrollOffsetForYear(widget.selectedDate));
    }
  }

  double _scrollOffsetForYear(final DateTime date) {
    final int initialYearIndex = date.year - widget.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ 3;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return _itemCount < minYears ? 0 : centeredYearRow * Styles.pickerRowHeight;
  }

  Widget _buildYearItem(final BuildContext context, final int index) {
    final Color accentColor = ArnaTheme.of(context).accentColor;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.firstDate.year + index - offset;
    final bool isSelected = year == widget.selectedDate.year;
    final bool isCurrentYear = year == widget.currentDate.year;
    final bool isDisabled =
        year < widget.firstDate.year || year > widget.lastDate.year;

    final Color textColor;
    if (isSelected) {
      textColor = ArnaDynamicColor.onBackgroundColor(accentColor);
    } else if (isDisabled) {
      textColor = ArnaColors.disabledColor.resolveFrom(context);
    } else if (isCurrentYear) {
      textColor = accentColor;
    } else {
      textColor = ArnaColors.primaryTextColor.resolveFrom(context);
    }
    final TextStyle? itemStyle = ArnaTheme.of(context).textTheme.body?.apply(
          color: textColor,
        );

    return isDisabled
        ? ExcludeSemantics(
            child: SizedBox(
              height: Styles.yearPickerRowHeight,
              width: Styles.yearPickerRowWidth,
              child: Center(
                child: Semantics(
                  selected: isSelected,
                  button: true,
                  child: Text(year.toString(), style: itemStyle),
                ),
              ),
            ),
          )
        : ArnaBaseWidget(
            key: ValueKey<int>(year),
            builder: (
              final BuildContext context,
              final bool enabled,
              final bool hover,
              final bool focused,
              final bool pressed,
              final bool selected,
            ) {
              return Center(
                child: Container(
                  height: Styles.yearPickerRowHeight,
                  width: Styles.yearPickerRowWidth,
                  decoration: BoxDecoration(
                    borderRadius: Styles.borderRadius,
                    border: Border.all(
                      color: focused
                          ? ArnaDynamicColor.outerColor(accentColor)
                          : ArnaColors.transparent,
                    ),
                    color: isSelected
                        ? accentColor
                        : pressed || hover
                            ? ArnaDynamicColor.applyOverlay(
                                ArnaColors.cardColor.resolveFrom(context),
                              )
                            : ArnaColors.transparent,
                    // borderRadius: Styles.borderRadius,
                  ),
                  child: Center(
                    child: Semantics(
                      selected: isSelected,
                      button: true,
                      child: Text(year.toString(), style: itemStyle),
                    ),
                  ),
                ),
              );
            },
            onPressed: () => widget.onChanged(
              DateTime(
                year,
                widget.initialDate.month,
              ),
            ),
          );
  }

  int get _itemCount => widget.lastDate.year - widget.firstDate.year + 1;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: Styles.normal,
          ),
        ),
      ],
    );
  }
}

/// _ArnaYearPickerGridDelegate class.
class _ArnaYearPickerGridDelegate extends SliverGridDelegate {
  /// Creates a year picker grid delegate.
  const _ArnaYearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(final SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - (3 - 1) * Styles.padding) / 3;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: Styles.pickerRowHeight,
      crossAxisCount: 3,
      crossAxisStride: tileWidth + Styles.padding,
      mainAxisStride: Styles.pickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(final _ArnaYearPickerGridDelegate oldDelegate) => false;
}

/// _yearPickerGridDelegate.
const _ArnaYearPickerGridDelegate _yearPickerGridDelegate =
    _ArnaYearPickerGridDelegate();
