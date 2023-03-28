import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

/// ArnaTextSpanEditingController class.
class _ArnaTextSpanEditingController extends TextEditingController {
  /// Creates an ArnaTextSpanEditingController.
  _ArnaTextSpanEditingController({required final TextSpan textSpan})
      : _textSpan = textSpan,
        super(text: textSpan.toPlainText(includeSemanticsLabels: false));

  final TextSpan _textSpan;

  @override
  TextSpan buildTextSpan({
    required final BuildContext context,
    final TextStyle? style,
    required final bool withComposing,
  }) {
    // This does not care about composing.
    return TextSpan(
      style: style,
      children: <TextSpan>[_textSpan],
    );
  }

  @override
  set text(final String? newText) {
    // This should never be reached.
    throw UnimplementedError();
  }
}

/// ArnaSelectableTextSelectionGestureDetectorBuilder class.
class _ArnaSelectableTextSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  /// Creates an ArnaSelectableTextSelectionGestureDetectorBuilder.
  _ArnaSelectableTextSelectionGestureDetectorBuilder({
    required final _ArnaSelectableTextState state,
  })  : _state = state,
        super(delegate: state);

  final _ArnaSelectableTextState _state;

  @override
  void onForcePressStart(final ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(final ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(final LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      renderEditable.selectWordsInRange(
        from: details.globalPosition - details.offsetFromOrigin,
        to: details.globalPosition,
        cause: SelectionChangedCause.longPress,
      );
    }
  }

  @override
  void onSingleTapUp(final TapUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
      }
    }
    _state.widget.onTap?.call();
  }

  @override
  void onSingleLongTapStart(final LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      renderEditable.selectWord(cause: SelectionChangedCause.longPress);
      ArnaFeedback.forLongPress(_state.context);
    }
  }
}

/// A run of selectable text with a single style.
///
/// The [ArnaSelectableText] widget displays a string of text with a single
/// style.
/// The string might break across multiple lines or might all be displayed on
/// the same line depending on the layout constraints.
///
/// The [style] argument is optional. When omitted, the text will use the style
/// from the closest enclosing [DefaultTextStyle]. If the given style's
/// [TextStyle.inherit] property is true (the default), the given style will
/// be merged with the closest enclosing [DefaultTextStyle]. This merging
/// behavior is useful, for example, to make the text bold while using the
/// default font family and size.
///
/// {@macro flutter.material.textfield.wantKeepAlive}
///
/// {@tool snippet}
///
/// ```dart
/// const ArnaSelectableText(
///   'Hello! How are you?',
///   textAlign: TextAlign.center,
///   style: TextStyle(fontWeight: FontWeight.bold),
/// )
/// ```
/// {@end-tool}
///
/// Using the [SelectableText.rich] constructor, the [SelectableText] widget
/// can display a paragraph with differently styled [TextSpan]s. The sample
/// that follows displays "Hello beautiful world" with different styles for
/// each word.
///
/// {@tool snippet}
///
/// ```dart
/// const ArnaSelectableText.rich(
///   TextSpan(
///     text: 'Hello', // default text style
///     children: <TextSpan>[
///       TextSpan(
///         text: ' beautiful ',
///         style: TextStyle(fontStyle: FontStyle.italic),
///       ),
///       TextSpan(
///         text: 'world',
///         style: TextStyle(fontWeight: FontWeight.bold),
///       ),
///     ],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// ## Interactivity
///
/// To make [ArnaSelectableText] react to touch events, use callback [onTap]
/// to achieve the desired behavior.
///
/// See also:
///
///  * [Text], which is the non selectable version of this widget.
///  * [ArnaTextField], which is the editable version of this widget.
class ArnaSelectableText extends StatefulWidget {
  /// Creates a selectable text widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ///
  /// The [showCursor], [autofocus], [dragStartBehavior],
  /// [selectionHeightStyle], [selectionWidthStyle] and [data] parameters must
  /// not be null. If specified, the [maxLines] argument must be greater than
  /// zero.
  const ArnaSelectableText(
    String this.data, {
    super.key,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = Styles.cursorWidth,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(Styles.cursorRadius),
    this.accentColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.magnifierConfiguration,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        textSpan = null;

  /// Creates a selectable text widget with a [TextSpan].
  ///
  /// The [textSpan] parameter must not be null and only contain [TextSpan] in
  /// [textSpan].children. Other type of [InlineSpan] is not allowed.
  ///
  /// The [autofocus] and [dragStartBehavior] arguments must not be null.
  const ArnaSelectableText.rich(
    TextSpan this.textSpan, {
    super.key,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.showCursor = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.cursorWidth = Styles.cursorWidth,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(Styles.cursorRadius),
    this.accentColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollPhysics,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.magnifierConfiguration,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        data = null;

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String? data;

  /// The text to display as a [TextSpan].
  ///
  /// This will be null if [data] is provided instead.
  final TextSpan? textSpan;

  /// Defines the focus for this widget.
  ///
  /// Text is only selectable when widget is focused.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the focus to this widget, provide a [focusNode] and then use
  /// the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode] with
  /// [FocusNode.skipTraversal] parameter set to `true`, which causes the
  /// widget to be skipped over during focus traversal.
  final FocusNode? focusNode;

  /// The style to use for the text.
  ///
  /// If null, defaults [DefaultTextStyle] of context.
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool showCursor;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// Called when the user taps on this selectable text.
  ///
  /// The selectable text builds a [GestureDetector] to handle input events
  /// like tap, to trigger focus requests, to move the caret, adjust the
  /// selection, etc. Handling some of those events by wrapping the selectable
  /// text with a competing GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the selectable
  /// text's internal gesture detector, provide this callback.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// selectable text's internal gesture detector, use a [Listener].
  final GestureTapCallback? onTap;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.Text.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.editableText.onSelectionChanged}
  final SelectionChangedCallback? onSelectionChanged;

  /// The color of the text field.
  final Color? accentColor;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  static Widget _defaultContextMenuBuilder(
    final BuildContext context,
    final EditableTextState editableTextState,
  ) {
    return ArnaTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.intro}
  ///
  /// {@macro flutter.widgets.magnifier.intro}
  ///
  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.details}
  ///
  /// By default, builds an [ArnaTextMagnifier] on iOS and Android, and builds
  /// nothing on all other platforms. If it is desired to suppress the
  /// magnifier, consider passing [TextMagnifierConfiguration.disabled].
  final TextMagnifierConfiguration? magnifierConfiguration;

  @override
  State<ArnaSelectableText> createState() => _ArnaSelectableTextState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<String>(
        'data',
        data,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<String>(
        'semanticsLabel',
        semanticsLabel,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<FocusNode>(
        'focusNode',
        focusNode,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'style',
        style,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'autofocus',
        autofocus,
        defaultValue: false,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'showCursor',
        showCursor,
        defaultValue: false,
      ),
    );
    properties.add(
      IntProperty(
        'minLines',
        minLines,
        defaultValue: null,
      ),
    );
    properties.add(
      IntProperty(
        'maxLines',
        maxLines,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<TextAlign>(
        'textAlign',
        textAlign,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<TextDirection>(
        'textDirection',
        textDirection,
        defaultValue: null,
      ),
    );
    properties.add(
      DoubleProperty(
        'textScaleFactor',
        textScaleFactor,
        defaultValue: null,
      ),
    );
    properties.add(
      DoubleProperty(
        'cursorWidth',
        cursorWidth,
        defaultValue: Styles.cursorWidth,
      ),
    );
    properties.add(
      DoubleProperty(
        'cursorHeight',
        cursorHeight,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Radius>(
        'cursorRadius',
        cursorRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Color>(
        'accentColor',
        accentColor,
        defaultValue: null,
      ),
    );
    properties.add(
      FlagProperty(
        'selectionEnabled',
        value: selectionEnabled,
        defaultValue: true,
        ifFalse: 'selection disabled',
      ),
    );
    properties.add(
      DiagnosticsProperty<TextSelectionControls>(
        'selectionControls',
        selectionControls,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ScrollPhysics>(
        'scrollPhysics',
        scrollPhysics,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextHeightBehavior>(
        'textHeightBehavior',
        textHeightBehavior,
        defaultValue: null,
      ),
    );
  }
}

/// The [State] for an [ArnaSelectableText].
class _ArnaSelectableTextState extends State<ArnaSelectableText>
    implements TextSelectionGestureDetectorBuilderDelegate {
  EditableTextState get _editableText => editableTextKey.currentState!;

  late _ArnaTextSpanEditingController _controller;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode(skipTraversal: true));

  bool _showSelectionHandles = false;

  late _ArnaSelectableTextSelectionGestureDetectorBuilder
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
        _ArnaSelectableTextSelectionGestureDetectorBuilder(state: this);
    _controller = _ArnaTextSpanEditingController(
      textSpan: widget.textSpan ?? TextSpan(text: widget.data),
    );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(final ArnaSelectableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.textSpan != oldWidget.textSpan) {
      _controller.removeListener(_onControllerChanged);
      _controller = _ArnaTextSpanEditingController(
        textSpan: widget.textSpan ?? TextSpan(text: widget.data),
      );
      _controller.addListener(_onControllerChanged);
    }
    if (_effectiveFocusNode.hasFocus && _controller.selection.isCollapsed) {
      _showSelectionHandles = false;
    } else {
      _showSelectionHandles = true;
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final bool showSelectionHandles =
        !_effectiveFocusNode.hasFocus || !_controller.selection.isCollapsed;
    if (showSelectionHandles == _showSelectionHandles) {
      return;
    }
    setState(() => _showSelectionHandles = showSelectionHandles);
  }

  void _handleSelectionChanged(
    final TextSelection selection,
    final SelectionChangedCause? cause,
  ) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() => _showSelectionHandles = willShowSelectionHandles);
    }

    widget.onSelectionChanged?.call(selection, cause);

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_controller.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  bool _shouldShowSelectionHandles(final SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (_controller.selection.isCollapsed) {
      return false;
    }

    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.scribble) {
      return true;
    }

    if (_controller.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasDirectionality(context));
    assert(
      !(widget.style != null &&
          widget.style!.inherit == false &&
          (widget.style!.fontSize == null ||
              widget.style!.textBaseline == null)),
      'inherit false style must supply fontSize and textBaseline',
    );

    final FocusNode focusNode = _effectiveFocusNode;

    final bool paintCursorAboveText;
    Offset? cursorOffset;

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        paintCursorAboveText = true;
        cursorOffset = Offset(
          (-2) / MediaQuery.of(context).devicePixelRatio,
          0,
        );
        break;
      case TargetPlatform.android:
        paintCursorAboveText = false;
        break;
      case TargetPlatform.fuchsia:
        paintCursorAboveText = false;
        break;
      case TargetPlatform.linux:
        paintCursorAboveText = false;
        break;
      case TargetPlatform.macOS:
        paintCursorAboveText = true;
        cursorOffset = Offset(
          (-2) / MediaQuery.of(context).devicePixelRatio,
          0,
        );
        break;
      case TargetPlatform.windows:
        paintCursorAboveText = false;
        break;
    }

    final Color accent =
        widget.accentColor ?? ArnaTheme.of(context).accentColor;

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (effectiveTextStyle == null || effectiveTextStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(
        widget.style ?? _controller._textSpan.style,
      );
    }
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle.merge(
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }
    final Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        style: effectiveTextStyle,
        readOnly: true,
        textWidthBasis:
            widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
        textHeightBehavior:
            widget.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
        showSelectionHandles: _showSelectionHandles,
        showCursor: widget.showCursor,
        controller: _controller,
        focusNode: focusNode,
        strutStyle: widget.strutStyle ?? const StrutStyle(),
        textAlign:
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor,
        autofocus: widget.autofocus,
        forceLine: false,
        minLines: widget.minLines,
        maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
        selectionColor: accent.withOpacity(0.42),
        selectionControls:
            widget.selectionEnabled ? widget.selectionControls : null,
        onSelectionChanged: _handleSelectionChanged,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        rendererIgnoresPointer: true,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: ArnaDynamicColor.matchingColor(
          accent,
          ArnaTheme.brightnessOf(context),
        ),
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: ArnaColors.secondaryTextColor.resolveFrom(
          context,
        ),
        enableInteractiveSelection: widget.enableInteractiveSelection,
        magnifierConfiguration: widget.magnifierConfiguration ??
            TextMagnifierConfiguration(
              magnifierBuilder: (
                final BuildContext context,
                final MagnifierController controller,
                final ValueNotifier<MagnifierInfo> magnifierInfo,
              ) {
                return ArnaTextMagnifier(
                  controller: controller,
                  magnifierInfo: magnifierInfo,
                );
              },
            ),
        dragStartBehavior: widget.dragStartBehavior,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: null,
        contextMenuBuilder: widget.contextMenuBuilder,
      ),
    );

    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: widget.semanticsLabel != null,
      onLongPress: () => _effectiveFocusNode.requestFocus(),
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
