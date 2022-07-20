import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/strings.dart';

class Pickers extends ConsumerWidget {
  const Pickers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArnaExpansionPanel(
      leading: Icon(
        Icons.calendar_today_outlined,
        color: ArnaColors.iconColor.resolveFrom(context),
      ),
      title: Strings.pickers,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ArnaTextButton(
            label: Strings.datePicker,
            onPressed: () async {
              final DateTime? pickedDate = await showArnaDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              );
              if (pickedDate != null) {
                showArnaSnackbar(
                  context: context,
                  message:
                      '${pickedDate.year}/${pickedDate.month}/${pickedDate.day}',
                );
              }
            },
            tooltipMessage: Strings.add,
          ),
        ],
      ),
    );
  }
}
