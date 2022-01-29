import 'package:arna/arna.dart';

class ArnaSearchField extends StatelessWidget {
  final bool showSearch;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const ArnaSearchField({
    Key? key,
    required this.showSearch,
    required this.controller,
    this.focusNode,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showSearch ? Column(
      children: [
        AnimatedContainer(
          height: showSearch ? Styles.headerBarHeight : 0,
          duration: Styles.basicDuration,
          curve: Styles.basicCurve,
          decoration: BoxDecoration(color: headerColor(context)),
          child: Padding(
            padding: Styles.horizontal,
            child: Center(
              child: SizedBox(
                width: Styles.searchWidth,
                child: ArnaTextField(
                  controller: controller,
                  hintText: hintText,
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onSubmitted,
                  focusNode: focusNode,
                  autofocus: autofocus,
                ),
              ),
            ),
          ),
        ),
        if (showSearch) const ArnaHorizontalDivider(),
      ],
    ) : const SizedBox.shrink();
  }
}
