import 'package:arna/arna.dart';

import '/strings.dart';

class TextField extends StatelessWidget {
  const TextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArnaExpansionPanel(
      leading: Icon(Icons.text_fields_outlined),
      title: Strings.textField,
      child: ArnaTextField(
        clearButtonMode: ArnaOverlayVisibilityMode.editing,
        maxLength: 100,
        maxLines: null,
      ),
    );
  }
}
