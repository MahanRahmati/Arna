import 'package:arna/arna.dart';

class ArnaScaffold extends StatelessWidget {
  final Widget headerBarLeading;
  final String? title;
  final Widget headerBarTrailing;
  final Widget body;

  const ArnaScaffold({
    Key? key,
    this.headerBarLeading = const SizedBox.shrink(),
    this.title,
    this.headerBarTrailing = const SizedBox.shrink(),
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor(context)),
      child: Column(
        children: [
          ArnaHeaderBar(
            leading: headerBarLeading,
            middle: Text(title ?? "", style: titleText(context)),
            trailing: headerBarTrailing,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
