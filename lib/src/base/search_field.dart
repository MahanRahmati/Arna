import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;
import 'package:flutter/services.dart' show TextInputAction;

//TODO: Add ArnaSearchField to Example

/// An Arna-styled search field.
class ArnaSearchField extends StatefulWidget {
  /// Creates a search field in the Arna style.
  const ArnaSearchField({
    Key? key,
    required this.showSearch,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.restorationId,
    this.autofocus = false,
    this.onTap,
    this.autocorrect = true,
    this.enabled,
  }) : super(key: key);

  /// Whether to show search or not.
  final bool showSearch;

  /// Controls the text being edited.
  ///
  /// Similar to [ArnaTextField], to provide a prefilled text entry, pass in a [TextEditingController] with an initial
  /// value to the [controller] parameter. Defaults to creating its own [TextEditingController].
  final TextEditingController? controller;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Invoked upon keyboard submission.
  final ValueChanged<String>? onSubmitted;

  /// The hint text that appears when the text entry is empty.
  final String? hintText;

  /// {@macro flutter.material.textfield.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.textfield.onTap}
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// Disables the text field when false.
  final bool? enabled;

  @override
  State<ArnaSearchField> createState() => _ArnaSearchFieldState();
}

/// The [State] for a [ArnaSearchField].
class _ArnaSearchFieldState extends State<ArnaSearchField> with SingleTickerProviderStateMixin, RestorationMixin {
  RestorableTextEditingController? _textcontroller;
  FocusNode? focusNode;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Styles.basicDuration,
      debugLabel: 'ArnaSearchField',
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Styles.basicCurve,
    );
    if (widget.controller == null) {
      _createLocalController();
    }
    if (widget.showSearch) {
      _controller.forward();
    }
    focusNode = FocusNode(canRequestFocus: widget.showSearch);
  }

  @override
  void didUpdateWidget(ArnaSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showSearch != oldWidget.showSearch) {
      switch (_controller.status) {
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          widget.showSearch
              ? _controller.forward().then((_) => focusNode!.requestFocus())
              : _controller.reverse().then((_) => focusNode!.unfocus());
          break;
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    }
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_textcontroller!);
      _textcontroller!.dispose();
      _textcontroller = null;
    }
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_textcontroller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_textcontroller != null);
    registerForRestoration(_textcontroller!, '_textcontroller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_textcontroller == null);
    _textcontroller =
        value == null ? RestorableTextEditingController() : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: _animation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedContainer(
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            color: ArnaDynamicColor.resolve(ArnaColors.headerColor, context),
            child: Padding(
              padding: Styles.small,
              child: Center(
                child: SizedBox(
                  width: Styles.searchWidth,
                  child: ArnaTextField(
                    controller: widget.controller ?? _textcontroller!.value,
                    hintText: widget.hintText ?? MaterialLocalizations.of(context).searchFieldLabel,
                    prefix: Icon(
                      Icons.search_outlined,
                      color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                    ),
                    enabled: widget.enabled,
                    onTap: widget.onTap,
                    clearButtonMode: ArnaOverlayVisibilityMode.editing,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    focusNode: focusNode,
                    autofocus: widget.autofocus && widget.showSearch,
                    autocorrect: widget.autocorrect,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ),
            ),
          ),
          const ArnaDivider(),
        ],
      ),
    );
  }
}
