import 'package:arna/arna.dart';
import 'package:flutter/services.dart';

/// A [FormField] that contains an [ArnaTextField].
///
/// This is a convenience widget that wraps an [ArnaTextField] widget in a [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to save, reset, or validate multiple fields at
/// once. To use without a [Form], pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to save or
/// reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text] defines the [initialValue]. If this [FormField]
/// is part of a scrolling container that lazily constructs its children, like a [ListView] or a [CustomScrollView],
/// then a [controller] should be specified. The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give the automatically generated controller an
/// initial value.
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController] when it is no longer needed. This
/// will ensure we discard any resources used by the object.
///
/// For a documentation about the various parameters, see [ArnaTextField].
///
/// {@tool snippet}
///
/// Creates an [ArnaTextFormField] and validator function.
///
/// ```dart
/// ArnaTextFormField(
///   hintText: 'What do people call you?',
///   onSaved: (String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String? value) {
///     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaTextField], which is the underlying text field without the [Form] integration.
class ArnaTextFormField extends FormField<String> {
  /// Creates a [FormField] that contains an [ArnaTextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the default). If [controller] is null, then a
  /// [TextEditingController] will be constructed automatically and its `text` will be initialized to [initialValue] or
  /// the empty string.
  ///
  /// For documentation about the various parameters, see the [ArnaTextField] class.
  ArnaTextFormField({
    super.key,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
    this.controller,
    String? initialValue,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    ArnaOverlayVisibilityMode prefixMode = ArnaOverlayVisibilityMode.always,
    Widget? suffix,
    ArnaOverlayVisibilityMode suffixMode = ArnaOverlayVisibilityMode.always,
    ArnaOverlayVisibilityMode clearButtonMode = ArnaOverlayVisibilityMode.never,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    bool autofocus = false,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = Styles.cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius = const Radius.circular(Styles.cursorRadius),
    Color? accentColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = Styles.normal,
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    GestureTapCallback? onTap,
    MouseCursor cursor = MouseCursor.defer,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    super.restorationId,
    bool enableIMEPersonalizedLearning = true,
  })  : assert(initialValue == null || controller == null),
        assert(textAlign != null),
        assert(autofocus != null),
        assert(readOnly != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        assert(enableSuggestions != null),
        assert(scrollPadding != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength > 0),
        assert(enableIMEPersonalizedLearning != null),
        super(
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          enabled: enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final _ArnaTextFormFieldState state = field as _ArnaTextFormFieldState;
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: ArnaTextField(
                controller: state._effectiveController,
                focusNode: focusNode,
                hintText: hintText,
                prefix: prefix,
                prefixMode: prefixMode,
                suffix: suffix,
                suffixMode: suffixMode,
                clearButtonMode: clearButtonMode,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                textCapitalization: textCapitalization,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                readOnly: readOnly,
                toolbarOptions: toolbarOptions,
                showCursor: showCursor,
                autofocus: autofocus,
                obscuringCharacter: obscuringCharacter,
                obscureText: obscureText,
                autocorrect: autocorrect,
                smartDashesType: smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
                smartQuotesType: smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
                enableSuggestions: enableSuggestions,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                maxLengthEnforcement: maxLengthEnforcement,
                onChanged: onChangedHandler,
                onEditingComplete: onEditingComplete,
                onSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                enabled: enabled ?? true,
                cursorWidth: cursorWidth,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                accentColor: accentColor,
                keyboardAppearance: keyboardAppearance,
                scrollPadding: scrollPadding,
                enableInteractiveSelection: enableInteractiveSelection ?? (!obscureText || !readOnly),
                selectionControls: selectionControls,
                onTap: onTap,
                cursor: cursor,
                scrollController: scrollController,
                scrollPhysics: scrollPhysics,
                autofillHints: autofillHints,
                restorationId: restorationId,
                enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
              ),
            );
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _ArnaTextFormFieldState();
}

/// The [State] for an [ArnaTextFormField].
class _ArnaTextFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController => _textFormField.controller ?? _controller!.value;

  ArnaTextFormField get _textFormField => super.widget as ArnaTextFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null ? RestorableTextEditingController() : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      _createLocalController(widget.initialValue != null ? TextEditingValue(text: widget.initialValue!) : null);
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(ArnaTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being manipulated, no setState call is needed
    // here.
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we register this change listener. In these
    // cases, we'll also receive change notifications for changes originating from within this class -- for example,
    // the reset() method. In such cases, the FormField value will already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
