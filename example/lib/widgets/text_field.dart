import 'package:arna/arna.dart';

import '/strings.dart';

class TextField extends StatelessWidget {
  const TextField({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.text_fields_outlined,
        color: ArnaColors.iconColor.resolveFrom(context),
      ),
      title: Strings.textField,
      child: const ArnaTextField(
        clearButtonMode: ArnaOverlayVisibilityMode.editing,
        maxLength: 100,
        maxLines: null,
      ),
    );
  }
}
