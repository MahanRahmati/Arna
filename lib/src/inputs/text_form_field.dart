import 'package:arna/arna.dart';
import 'package:flutter/services.dart';

/// A [FormField] that contains an [ArnaTextField].
///
/// This is a convenience widget that wraps an [ArnaTextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a `GlobalKey<FormFieldState>` (see [GlobalKey]) to the constructor and
/// use [GlobalKey.currentState] to save or reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text] defines
/// the [initialValue]. If this [FormField] is part of a scrolling container
/// that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give the
/// automatically generated controller an initial value.
///
/// Remember to call [TextEditingController.dispose] of the
/// [TextEditingController] when it is no longer needed. This will ensure any
/// resources used by the object are discarded.
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
///   onSaved: (final String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (final String? value) {
///     return (value != null && value.contains('@'))
///         ? 'Do not use the @ char.'
///         : null;
///   },
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaTextField], which is the underlying text field without the [Form]
///    integration.
class ArnaTextFormField extends FormField<String> {
  /// Creates a [FormField] that contains an [ArnaTextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null
  /// (the default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized to
  /// [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [ArnaTextField]
  /// class.
  ArnaTextFormField({
    super.key,
    super.onSaved,
    super.validator,
    final AutovalidateMode? autovalidateMode,
    this.controller,
    final String? initialValue,
    final FocusNode? focusNode,
    final String? hintText,
    final Widget? prefix,
    final ArnaOverlayVisibilityMode prefixMode =
        ArnaOverlayVisibilityMode.always,
    final Widget? suffix,
    final ArnaOverlayVisibilityMode suffixMode =
        ArnaOverlayVisibilityMode.always,
    final ArnaOverlayVisibilityMode clearButtonMode =
        ArnaOverlayVisibilityMode.never,
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
    final TextCapitalization textCapitalization = TextCapitalization.none,
    final StrutStyle? strutStyle,
    final TextAlign textAlign = TextAlign.start,
    final TextAlignVertical? textAlignVertical,
    final TextDirection? textDirection,
    final bool readOnly = false,
    final bool? showCursor,
    final bool autofocus = false,
    final String obscuringCharacter = '•',
    final bool obscureText = false,
    final bool autocorrect = true,
    final SmartDashesType? smartDashesType,
    final SmartQuotesType? smartQuotesType,
    final bool enableSuggestions = true,
    final int? maxLines = 1,
    final int? minLines,
    final bool expands = false,
    final int? maxLength,
    final MaxLengthEnforcement? maxLengthEnforcement,
    final ValueChanged<String>? onChanged,
    final VoidCallback? onEditingComplete,
    final ValueChanged<String>? onFieldSubmitted,
    final List<TextInputFormatter>? inputFormatters,
    final bool? enabled,
    final double cursorWidth = Styles.cursorWidth,
    final double? cursorHeight,
    final Radius? cursorRadius = const Radius.circular(Styles.cursorRadius),
    final Color? accentColor,
    final Brightness? keyboardAppearance,
    final EdgeInsets scrollPadding = const EdgeInsets.all(Styles.padding),
    final bool? enableInteractiveSelection,
    final TextSelectionControls? selectionControls,
    final GestureTapCallback? onTap,
    final MouseCursor cursor = MouseCursor.defer,
    final ScrollController? scrollController,
    final ScrollPhysics? scrollPhysics,
    final Iterable<String>? autofillHints,
    super.restorationId,
    final bool enableIMEPersonalizedLearning = true,
    final EditableTextContextMenuBuilder? contextMenuBuilder =
        _defaultContextMenuBuilder,
  })  : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
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
        assert(
          !obscureText || maxLines == 1,
          'Obscured fields cannot be multiline.',
        ),
        assert(maxLength == null || maxLength > 0),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          enabled: enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (final FormFieldState<String> field) {
            final _ArnaTextFormFieldState state =
                field as _ArnaTextFormFieldState;
            void onChangedHandler(final String value) {
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
                showCursor: showCursor,
                autofocus: autofocus,
                obscuringCharacter: obscuringCharacter,
                obscureText: obscureText,
                autocorrect: autocorrect,
                smartDashesType: smartDashesType ??
                    (obscureText
                        ? SmartDashesType.disabled
                        : SmartDashesType.enabled),
                smartQuotesType: smartQuotesType ??
                    (obscureText
                        ? SmartQuotesType.disabled
                        : SmartQuotesType.enabled),
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
                enableInteractiveSelection:
                    enableInteractiveSelection ?? (!obscureText || !readOnly),
                selectionControls: selectionControls,
                onTap: onTap,
                cursor: cursor,
                scrollController: scrollController,
                scrollPhysics: scrollPhysics,
                autofillHints: autofillHints,
                restorationId: restorationId,
                enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
                contextMenuBuilder: contextMenuBuilder,
              ),
            );
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  static Widget _defaultContextMenuBuilder(
    final BuildContext context,
    final EditableTextState editableTextState,
  ) {
    return ArnaTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  FormFieldState<String> createState() => _ArnaTextFormFieldState();
}

/// The [State] for an [ArnaTextFormField].
class _ArnaTextFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  ArnaTextFormField get _textFormField => super.widget as ArnaTextFormField;

  @override
  void restoreState(
    final RestorationBucket? oldBucket,
    final bool initialRestore,
  ) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([final TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(final ArnaTextFormField oldWidget) {
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
  void didChange(final String? value) {
    super.didChange(value);
    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
