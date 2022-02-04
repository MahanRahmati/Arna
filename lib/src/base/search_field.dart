import 'package:arna/arna.dart';

class ArnaSearchField extends StatefulWidget {
  final bool showSearch;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? hint;

  const ArnaSearchField({
    Key? key,
    required this.showSearch,
    required this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.hint,
  }) : super(key: key);

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
            children: [
              AnimatedContainer(
                height: widget.showSearch ? Styles.headerBarHeight : 0,
                duration: Styles.basicDuration,
                curve: Styles.basicCurve,
                decoration: BoxDecoration(color: headerColor(context)),
                child: Padding(
                  padding: Styles.horizontal,
                  child: Center(
                    child: SizedBox(
                      width: Styles.searchWidth,
                      child: ArnaTextField(
                        controller: widget.controller,
                        hintText: widget.hint,
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
