import 'package:arna/arna.dart';

/// Shows a search field inside the scaffold.
/// See also:
///
///  * [ArnaScaffold]
///  * [ArnaSideScaffold]
///  * [ArnaMasterDetailScaffold]
class ArnaSearchField extends StatefulWidget {
  /// Creates a search field in the Arna style.
  const ArnaSearchField({
    Key? key,
    required this.showSearch,
    required this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.hint,
  }) : super(key: key);

  /// Whether to show search or not.
  final bool showSearch;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// The hint text of the search field.
  final String? hint;

  @override
  State<ArnaSearchField> createState() => _ArnaSearchFieldState();
}

class _ArnaSearchFieldState extends State<ArnaSearchField> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: widget.showSearch);
    if (widget.showSearch) focusNode!.requestFocus();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showSearch
        ? Column(
            children: <Widget>[
              AnimatedContainer(
                height: widget.showSearch ? Styles.headerBarHeight : 0,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                color: ArnaDynamicColor.resolve(
                  ArnaColors.headerColor,
                  context,
                ),
                child: Padding(
                  padding: Styles.small,
                  child: Center(
                    child: SizedBox(
                      width: Styles.searchWidth,
                      child: ArnaTextField(
                        controller: widget.controller,
                        placeholder: widget.hint,
                        prefix: const Icon(Icons.search_outlined),
                        clearButtonMode: ArnaOverlayVisibilityMode.editing,
                        onChanged: widget.onChanged,
                        onEditingComplete: widget.onEditingComplete,
                        onSubmitted: widget.onSubmitted,
                        focusNode: focusNode,
                        autofocus: true,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.showSearch) const ArnaHorizontalDivider(),
            ],
          )
        : const SizedBox.shrink();
  }
}
