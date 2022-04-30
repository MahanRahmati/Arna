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
    this.hintText,
  }) : super(key: key);

  /// Whether to show search or not.
  final bool showSearch;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [onEditingComplete], [onSubmitted]: which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// The hint text of the search field.
  final String? hintText;

  @override
  State<ArnaSearchField> createState() => _ArnaSearchFieldState();
}

/// The [State] for a [ArnaSearchField].
class _ArnaSearchFieldState extends State<ArnaSearchField> with SingleTickerProviderStateMixin {
  FocusNode? focusNode;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Styles.basicDuration, debugLabel: 'ArnaSearchField', vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Styles.basicCurve);
    if (widget.showSearch) _controller.forward();
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
  }

  @override
  void dispose() {
    focusNode!.dispose();
    focusNode = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1,
      sizeFactor: _animation,
      child: Column(
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
                    controller: widget.controller,
                    hintText: widget.hintText,
                    prefix: Icon(
                      Icons.search_outlined,
                      color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
                    ),
                    clearButtonMode: ArnaOverlayVisibilityMode.editing,
                    onChanged: widget.onChanged,
                    onEditingComplete: widget.onEditingComplete,
                    onSubmitted: widget.onSubmitted,
                    focusNode: focusNode,
                    autofocus: widget.showSearch,
                  ),
                ),
              ),
            ),
          ),
          const ArnaHorizontalDivider(),
        ],
      ),
    );
  }
}
