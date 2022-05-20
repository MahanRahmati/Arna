import 'package:arna/arna.dart';

import '/strings.dart';

class TextField extends StatelessWidget {
  const TextField({super.key});

  @override
  Widget build(BuildContext context) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.text_fields_outlined,
        color: ArnaDynamicColor.resolve(ArnaColors.iconColor, context),
      ),
      title: Strings.textField,
      child: const ArnaTextField(),
    );
  }
}
