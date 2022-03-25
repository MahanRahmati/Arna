import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show desktopTextSelectionControls;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show
        AutofillClient,
        AutofillConfiguration,
        Brightness,
        LengthLimitingTextInputFormatter,
        MaxLengthEnforcement,
        TextCapitalization,
        TextInputAction,
        TextInputConfiguration,
        TextInputFormatter;

/// Visibility of text field overlays based on the state of the current text entry.
///
/// Used to toggle the visibility behavior of the optional decorating widgets
/// surrounding the [EditableText] such as the clear text button.
enum ArnaOverlayVisibilityMode {
  /// Overlay will never appear regardless of the text entry state.
  never,

  /// Overlay will only appear when the current text entry is not empty.
  ///
  /// This includes prefilled text that the user did not type in manually. But
  /// does not include text in placeholders.
  editing,

  /// Overlay will only appear when the current text entry is empty.
  ///
  /// This also includes not having prefilled text that the user did not type
  /// in manually. Texts in placeholders are ignored.
  notEditing,

  /// Always show the overlay regardless of the text entry state.
  always,
}

class _ArnaTextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _ArnaTextFieldSelectionGestureDetectorBuilder({
    required _ArnaTextFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _ArnaTextFieldState _state;

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
      }
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();
    // Because TextSelectionGestureDetector listens to taps that happen on
    // widgets in front of it, tapping the clear button will also trigger
    // this handler. If the clear button widget recognizes the up event,
    // then do not handle it.
    if (_state._clearGlobalKey.currentContext != null) {
      final RenderBox renderBox = _state._clearGlobalKey.currentContext!
          .findRenderObject()! as RenderBox;
      final Offset localOffset =
          renderBox.globalToLocal(details.globalPosition);
      if (renderBox.hitTest(BoxHitTestResult(), position: localOffset)) {
        return;
      }
    }
    super.onSingleTapUp(details);
    _state._requestKeyboard();
    _state.widget.onTap?.call();
  }

  @override
  void onDragSelectionEnd(DragEndDetails details) => _state._requestKeyboard();

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWord(cause: SelectionChangedCause.longPress);
          break;
      }
    }
  }
}

/// An Arna-styled text field.
///
/// A text field lets the user enter text, either with a hardware keyboard or with
/// an onscreen keyboard.
///
/// The text field calls the [onChanged] callback whenever the user changes the
/// text in the field. If the user indicates that they are done typing in the
/// field (e.g., by pressing a button on the soft keyboard), the text field
/// calls the [onSubmitted] callback.
///
/// {@macro flutter.widgets.EditableText.onChanged}
///
/// To control the text that is displayed in the text field, use the
/// [controller]. For example, to set the initial value of the text field, use
/// a [controller] that already contains some text such as:
///
/// {@tool snippet}
///
/// ```dart
/// class MyPrefilledText extends StatefulWidget {
///   const MyPrefilledText({Key? key}) : super(key: key);
///
///   @override
///   State<MyPrefilledText> createState() => _MyPrefilledTextState();
/// }
///
/// class _MyPrefilledTextState extends State<MyPrefilledText> {
///   late TextEditingController _textController;
///
///   @override
///   void initState() {
///     super.initState();
///     _textController = TextEditingController(text: 'initial text');
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ArnaTextField(controller: _textController);
///   }
/// }
/// ```
/// {@end-tool}
///
/// The [controller] can also control the selection and composing region (and to
/// observe changes to the text, selection, and composing region).
///
/// Remember to call [TextEditingController.dispose] when it is no longer
/// needed. This will ensure we discard any resources used by the object.
///
/// {@macro flutter.widgets.editableText.showCaretOnScreen}
///
/// See also:
///
///  * [EditableText], which is the raw text editing control at the heart of a
///    [TextField].
class ArnaTextField extends StatefulWidget {
  /// Creates an Arna-styled text field.
  ///
  /// To provide a prefilled text entry, pass in a [TextEditingController] with
  /// an initial value to the [controller] parameter.
  ///
  /// To provide a hint text that appears when the text entry is empty, pass a
  /// [String] to the [placeholder] parameter.
  ///
  /// The [maxLines] property can be set to null to remove the restriction on
  /// the number of lines. In this mode, the intrinsic height of the widget will
  /// grow as the number of lines of text grows. By default, it is `1`, meaning
  /// this is a single-line text field and will scroll horizontally when
  /// overflown. [maxLines] must not be zero.
  ///
  /// The text cursor is not shown if [showCursor] is false or if [showCursor]
  /// is null (the default) and [readOnly] is true.
  ///
  /// If specified, the [maxLength] property must be greater than zero.
  ///
  /// The [selectionHeightStyle] and [selectionWidthStyle] properties allow
  /// changing the shape of the selection highlighting. These properties default
  /// to [ui.BoxHeightStyle.tight] and [ui.BoxWidthStyle.tight] respectively and
  /// must not be null.
  ///
  /// The [autocorrect], [autofocus], [clearButtonMode], [dragStartBehavior],
  /// [expands], [obscureText], [prefixMode], [readOnly], [suffixMode],
  /// [textAlign], [selectionHeightStyle], [selectionWidthStyle],
  /// [enableSuggestions], and [enableIMEPersonalizedLearning] properties must
  /// not be null.
  ///
  /// See also:
  ///
  ///  * [minLines], which is the minimum number of lines to occupy when the
  ///    content spans fewer lines.
  ///  * [expands], to allow the widget to size itself to its parent's height.
  ///  * [maxLength], which discusses the precise meaning of "number of
  ///    characters" and how it may differ from the intuitive meaning.
  const ArnaTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.prefix,
    this.prefixMode = ArnaOverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = ArnaOverlayVisibilityMode.always,
    this.clearButtonMode = ArnaOverlayVisibilityMode.never,
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    ToolbarOptions? toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorHeight,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.accentColor,
    this.cursor = MouseCursor.defer,
  })  : assert(obscuringCharacter.length == 1),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
          !identical(textInputAction, TextInputAction.newline) ||
              maxLines == 1 ||
              !identical(
                keyboardType,
                TextInputType.text,
              ),
          'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.',
        ),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(selectAll: true, paste: true)
                : const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  )),
        super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// A lighter colored hint that appears on the first line of the
  /// text field when the text entry is empty.
  ///
  /// Defaults to having no placeholder text.
  final String? placeholder;

  /// An optional [Widget] to display before the text.
  final Widget? prefix;

  /// Controls the visibility of the [prefix] widget based on the state of
  /// text entry when the [prefix] argument is not null.
  ///
  /// Defaults to [ArnaOverlayVisibilityMode.always] and cannot be null.
  ///
  /// Has no effect when [prefix] is null.
  final ArnaOverlayVisibilityMode prefixMode;

  /// An optional [Widget] to display after the text.
  final Widget? suffix;

  /// Controls the visibility of the [suffix] widget based on the state of
  /// text entry when the [suffix] argument is not null.
  ///
  /// Defaults to [ArnaOverlayVisibilityMode.always] and cannot be null.
  ///
  /// Has no effect when [suffix] is null.
  final ArnaOverlayVisibilityMode suffixMode;

  /// Show a clear button to clear the current text entry.
  ///
  /// Can be made to appear depending on various text states of the
  /// [TextEditingController].
  ///
  /// Will only appear if no [suffix] widget is appearing.
  ///
  /// Defaults to never appearing and cannot be null.
  final ArnaOverlayVisibilityMode clearButtonMode;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// Configuration of toolbar options.
  ///
  /// If not set, select all and paste will default to be enabled. Copy and cut
  /// will be disabled if [obscureText] is true. If [readOnly] is true,
  /// paste and cut will be disabled regardless.
  final ToolbarOptions toolbarOptions;

  /// {@macro flutter.material.InputDecorator.textAlignVertical}
  final TextAlignVertical? textAlignVertical;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.TextInputConfiguration.smartDashesType}
  final SmartDashesType smartDashesType;

  /// {@macro flutter.services.TextInputConfiguration.smartQuotesType}
  final SmartQuotesType smartQuotesType;

  /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The TextField enforces the length with a
  /// [LengthLimitingTextInputFormatter], which is evaluated after the supplied
  /// [inputFormatters], if any.
  ///
  /// This value must be either null or greater than zero. If set to null
  /// (the default), there is no limit to the number of characters allowed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// If [MaxLengthEnforcement.none] is set, additional input beyond [maxLength]
  /// will not be enforced by the limit.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.onAppPrivateCommand}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Disables the text field when false.
  ///
  /// Text fields in disabled states have a light grey background and don't
  /// respond to touch events including the [prefix], [suffix] and the clear
  /// button.
  final bool? enabled;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If null, defaults to [Brightness.light].
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// {@macro flutter.material.textfield.onTap}
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  /// {@macro flutter.material.textfield.restorationId}
  final String? restorationId;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  final bool enableIMEPersonalizedLearning;

  /// The color of the text field.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// text field.
  final MouseCursor cursor;

  @override
  State<ArnaTextField> createState() => _ArnaTextFieldState();
}

class _ArnaTextFieldState extends State<ArnaTextField>
    with RestorationMixin, AutomaticKeepAliveClientMixin<ArnaTextField>
    implements TextSelectionGestureDetectorBuilderDelegate, AutofillClient {
  final GlobalKey _clearGlobalKey = GlobalKey();

  RestorableTextEditingController? _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  bool _isHovering = false;

  bool _showSelectionHandles = false;

  late _ArnaTextFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

// API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  bool get forcePressEnabled => true;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        _ArnaTextFieldSelectionGestureDetectorBuilder(state: this);
    if (widget.controller == null) _createLocalController();
    _focusNode = FocusNode(canRequestFocus: widget.enabled ?? true);
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
  }

  @override
  void didUpdateWidget(ArnaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }
    _effectiveFocusNode.canRequestFocus = widget.enabled ?? true;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) _registerController();
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
    _controller!.value.addListener(updateKeepAlive);
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) _registerController();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode!.dispose();
    _controller?.dispose();
    super.dispose();
  }

  EditableTextState get _editableText => editableTextKey.currentState!;

  void _requestKeyboard() => _editableText.requestKeyboard();

  // Rebuild the widget on focus change to show/hide the text selection
  // highlight.
  void _handleFocusChanged() => setState(() {});

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (_effectiveController.selection.isCollapsed) return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (cause == SelectionChangedCause.longPress) return true;

    if (_effectiveController.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() => _showSelectionHandles = willShowSelectionHandles);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress ||
            cause == SelectionChangedCause.drag) {
          _editableText.bringIntoView(selection.extent);
        }
        return;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        if (cause == SelectionChangedCause.drag) {
          _editableText.bringIntoView(selection.extent);
        }
        return;
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) setState(() => _isHovering = hovering);
  }

  @override
  bool get wantKeepAlive => _controller?.value.text.isNotEmpty == true;

  bool _shouldShowAttachment({
    required ArnaOverlayVisibilityMode attachment,
    required bool hasText,
  }) {
    switch (attachment) {
      case ArnaOverlayVisibilityMode.never:
        return false;
      case ArnaOverlayVisibilityMode.always:
        return true;
      case ArnaOverlayVisibilityMode.editing:
        return hasText;
      case ArnaOverlayVisibilityMode.notEditing:
        return !hasText;
    }
  }

  bool _showPrefixWidget(TextEditingValue text) {
    return widget.prefix != null &&
        _shouldShowAttachment(
          attachment: widget.prefixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showSuffixWidget(TextEditingValue text) {
    return widget.suffix != null &&
        _shouldShowAttachment(
          attachment: widget.suffixMode,
          hasText: text.text.isNotEmpty,
        );
  }

  bool _showClearButton(TextEditingValue text) {
    return _shouldShowAttachment(
      attachment: widget.clearButtonMode,
      hasText: text.text.isNotEmpty,
    );
  }

// True if any surrounding decoration widgets will be shown.
  bool get _hasDecoration {
    return widget.placeholder != null ||
        widget.clearButtonMode != ArnaOverlayVisibilityMode.never ||
        widget.prefix != null ||
        widget.suffix != null;
  }

  // Provide default behavior if widget.textAlignVertical is not set.
  // ArnaTextField has top alignment by default, unless it has decoration
  // like a prefix or suffix, in which case it's aligned to the center.
  TextAlignVertical get _textAlignVertical {
    if (widget.textAlignVertical != null) {
      return widget.textAlignVertical!;
    }
    return _hasDecoration ? TextAlignVertical.center : TextAlignVertical.top;
  }

  Widget _addTextDependentAttachments(Widget editableText) {
    // If there are no surrounding widgets, just return the core editable text
    // part.
    if (!_hasDecoration) return editableText;

    // Otherwise, listen to the current state of the text entry.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      child: editableText,
      builder: (BuildContext context, TextEditingValue? text, Widget? child) {
        return Row(
          children: <Widget>[
            // Insert a prefix at the front if the prefix visibility mode matches
            // the current text state.
            if (_showPrefixWidget(text!))
              Padding(
                padding: Styles.horizontal,
                child: widget.prefix!,
              ),
            // In the middle part, stack the placeholder on top of the main EditableText
            // if needed.
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (widget.placeholder != null && text.text.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: Styles.textFieldPadding,
                        child: Text(
                          widget.placeholder!,
                          maxLines: widget.maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: ArnaTheme.of(context)
                              .textTheme
                              .subtitleTextStyle
                              .copyWith(
                                color: ArnaDynamicColor.resolve(
                                  ArnaColors.secondaryTextColor,
                                  context,
                                ),
                              ),
                          textAlign: widget.textAlign,
                        ),
                      ),
                    ),
                  child!,
                ],
              ),
            ),
            // First add the explicit suffix if the suffix visibility mode matches.
            if (_showSuffixWidget(text))
              Padding(
                padding: Styles.horizontal,
                child: widget.suffix!,
              )
            // Otherwise, try to show a clear button if its visibility mode matches.
            else if (_showClearButton(text))
              GestureDetector(
                key: _clearGlobalKey,
                onTap: widget.enabled ?? true
                    ? () {
                        // Special handle onChanged for ClearButton
                        // Also call onChanged when the clear button is tapped.
                        final bool textChanged =
                            _effectiveController.text.isNotEmpty;
                        _effectiveController.clear();
                        if (widget.onChanged != null && textChanged) {
                          widget.onChanged!(_effectiveController.text);
                        }
                      }
                    : null,
                child: const Padding(
                  padding: Styles.horizontal,
                  child: Icon(Icons.clear_outlined, size: Styles.iconSize),
                ),
              ),
          ],
        );
      },
    );
  }

  // AutofillClient implementation start.
  @override
  String get autofillId => _editableText.autofillId;

  @override
  void autofill(TextEditingValue newEditingValue) => _editableText.autofill(
        newEditingValue,
      );

  @override
  TextInputConfiguration get textInputConfiguration {
    final List<String>? autofillHints = widget.autofillHints?.toList(
      growable: false,
    );
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: _effectiveController.value,
            hintText: widget.placeholder,
          )
        : AutofillConfiguration.disabled;

    return _editableText.textInputConfiguration.copyWith(
      autofillConfiguration: autofillConfiguration,
    );
  }
  // AutofillClient implementation end.

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    assert(debugCheckHasDirectionality(context));
    final Brightness keyboardAppearance = widget.keyboardAppearance ??
        ArnaTheme.of(context).brightness ??
        Brightness.light;
    final TextEditingController controller = _effectiveController;
    TextSelectionControls? textSelectionControls = widget.selectionControls;
    VoidCallback? handleDidGainAccessibilityFocus;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        textSelectionControls ??= desktopTextSelectionControls;
        break;

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        textSelectionControls ??= desktopTextSelectionControls;
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        break;
    }
    final bool enabled = widget.enabled ?? true;
    final Offset cursorOffset = Offset(
      (-2) / MediaQuery.of(context).devicePixelRatio,
      0,
    );
    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    Color accent = widget.accentColor ?? ArnaTheme.of(context).accentColor;

    final Widget paddedEditable = Padding(
      padding: Styles.normal,
      child: RepaintBoundary(
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: EditableText(
            key: editableTextKey,
            controller: controller,
            readOnly: widget.readOnly,
            toolbarOptions: widget.toolbarOptions,
            showCursor: widget.showCursor,
            showSelectionHandles: _showSelectionHandles,
            focusNode: _effectiveFocusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textCapitalization: widget.textCapitalization,
            style: ArnaTheme.of(context).textTheme.textStyle,
            strutStyle: widget.strutStyle,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            autofocus: widget.autofocus,
            obscuringCharacter: widget.obscuringCharacter,
            obscureText: widget.obscureText,
            autocorrect: widget.autocorrect,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            enableSuggestions: widget.enableSuggestions,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            expands: widget.expands,
            // Only show the selection highlight when the text field is focused.
            selectionColor: _effectiveFocusNode.hasFocus ? accent : null,
            selectionControls:
                widget.selectionEnabled ? textSelectionControls : null,
            onChanged: widget.onChanged,
            onSelectionChanged: _handleSelectionChanged,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            onSelectionHandleTapped: _handleSelectionHandleTapped,
            inputFormatters: formatters,
            rendererIgnoresPointer: true,
            cursorWidth: Styles.cursorWidth,
            cursorHeight: widget.cursorHeight,
            cursorRadius: const Radius.circular(Styles.cursorRadius),
            cursorColor: ArnaDynamicColor.matchingColor(
              ArnaColors.textFieldColor,
              accent,
              ArnaTheme.brightnessOf(context),
            ),
            cursorOpacityAnimates: true,
            cursorOffset: cursorOffset,
            paintCursorAboveText: false,
            autocorrectionTextRectColor: accent.withOpacity(0.21),
            selectionHeightStyle: widget.selectionHeightStyle,
            selectionWidthStyle: widget.selectionWidthStyle,
            backgroundCursorColor: ArnaDynamicColor.resolve(
              ArnaColors.secondaryTextColor,
              context,
            ),
            scrollPadding: Styles.normal,
            keyboardAppearance: keyboardAppearance,
            dragStartBehavior: widget.dragStartBehavior,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            autofillClient: this,
            clipBehavior: Clip.antiAlias,
            restorationId: 'editable',
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          ),
        ),
      ),
    );

    return Padding(
      padding: Styles.small,
      child: MouseRegion(
        cursor: widget.cursor,
        onEnter: (PointerEnterEvent event) => _handleHover(true),
        onExit: (PointerExitEvent event) => _handleHover(false),
        child: Semantics(
          enabled: enabled,
          onTap: !enabled || widget.readOnly
              ? null
              : () {
                  if (!controller.selection.isValid) {
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                  }
                  _requestKeyboard();
                },
          onDidGainAccessibilityFocus: handleDidGainAccessibilityFocus,
          child: IgnorePointer(
            ignoring: !enabled,
            child: Container(
              decoration: BoxDecoration(
                color: ArnaDynamicColor.resolve(
                  _isHovering
                      ? ArnaDynamicColor.blend(
                          ArnaDynamicColor.resolve(
                            ArnaColors.textFieldColor,
                            context,
                          ),
                          14,
                        )
                      : ArnaColors.textFieldColor,
                  context,
                ),
                border: Border.all(
                  color: ArnaDynamicColor.resolve(
                    _effectiveFocusNode.hasFocus
                        ? ArnaDynamicColor.matchingColor(
                            ArnaColors.textFieldColor,
                            accent,
                            ArnaTheme.brightnessOf(context),
                          )
                        : ArnaColors.borderColor,
                    context,
                  ),
                ),
                borderRadius: Styles.borderRadius,
              ),
              color: !enabled
                  ? ArnaDynamicColor.resolve(ArnaColors.disabledColor, context)
                  : null,
              child: _selectionGestureDetectorBuilder.buildGestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Align(
                  alignment: Alignment(-1.0, _textAlignVertical.y),
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: _addTextDependentAttachments(paddedEditable),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
