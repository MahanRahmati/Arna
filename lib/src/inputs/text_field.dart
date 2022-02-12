import 'package:arna/arna.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ArnaTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Brightness? keyboardAppearance;
  final DragStartBehavior dragStartBehavior;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final GestureTapCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;

  const ArnaTextField({
    Key? key,
    this.controller,
    this.focusNode,
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    ToolbarOptions? toolbarOptions,
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
    this.enabled = true,
    this.keyboardAppearance,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.autofillHints = const [],
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onPressed,
  })  : smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  )
                : const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  )),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.small,
      child: Material(
        color: Styles.color00,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: subtitleText(context, disabled: !enabled),
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textDirection: textDirection,
          readOnly: readOnly,
          toolbarOptions: toolbarOptions,
          showCursor: true,
          autofocus: autofocus,
          obscuringCharacter: obscuringCharacter,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLengthEnforcement: maxLengthEnforcement,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onAppPrivateCommand: onAppPrivateCommand,
          inputFormatters: inputFormatters,
          enabled: enabled,
          cursorWidth: Styles.cursorWidth,
          cursorRadius: const Radius.circular(Styles.cursorRadius),
          cursorColor: ArnaColors.accentColor,
          keyboardAppearance: keyboardAppearance,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          scrollPadding: Styles.large,
          selectionControls: selectionControls,
          onTap: onTap,
          mouseCursor: mouseCursor,
          buildCounter: buildCounter,
          scrollController: scrollController,
          scrollPhysics: const BouncingScrollPhysics(),
          autofillHints: autofillHints,
          restorationId: restorationId,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
          clipBehavior: Clip.antiAlias,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: Styles.small,
                    child: Icon(
                      prefixIcon,
                      size: Styles.iconSize,
                      color: ArnaDynamicColor.resolve(
                        !enabled
                            ? ArnaColors.disabledColor
                            : ArnaColors.secondaryTextColor,
                        context,
                      ),
                    ),
                  )
                : null,
            suffixIcon: (suffixIcon != null)
                ? Padding(
                    padding: Styles.small,
                    child: SizedBox(
                      height: Styles.buttonSize + 10,
                      width: Styles.buttonSize + 10,
                      child: ArnaIconButton(
                        icon: suffixIcon,
                        onPressed: onPressed,
                      ),
                    ),
                  )
                : null,
            filled: true,
            fillColor: enabled
                ? textFieldColor(context)
                : backgroundColorDisabled(context),
            border: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: BorderSide(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.borderColor,
                  context,
                ),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: BorderSide(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.borderColor,
                  context,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: const BorderSide(color: ArnaColors.accentColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: BorderSide(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.borderColor,
                  context,
                ),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: const BorderSide(color: Styles.errorColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: Styles.borderRadius,
              borderSide: const BorderSide(color: Styles.errorColor),
            ),
            errorStyle: const TextStyle(height: 0, color: Colors.transparent),
            contentPadding: Styles.normal,
            // isDense: true,
            hintStyle: subtitleText(context, disabled: !enabled),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
