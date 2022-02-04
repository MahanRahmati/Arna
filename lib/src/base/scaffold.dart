import 'package:arna/arna.dart';

class ArnaScaffold extends StatelessWidget {
  final Widget headerBarLeading;
  final String? title;
  final Widget headerBarTrailing;
  final ArnaSearchField? searchField;
  final Widget body;

  const ArnaScaffold({
    Key? key,
    this.headerBarLeading = const SizedBox.shrink(),
    this.title,
    this.headerBarTrailing = const SizedBox.shrink(),
    this.searchField,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MediaQueryData metrics = MediaQuery.of(context);
        return MediaQuery(
          data: metrics.copyWith(
            padding: metrics.padding.copyWith(
              top: metrics.padding.top,
              bottom: metrics.padding.top,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(color: backgroundColor(context)),
            child: Column(
              children: [
                ArnaHeaderBar(
                  leading: headerBarLeading,
                  middle: Text(title ?? "", style: headline2(context)),
                  trailing: headerBarTrailing,
                ),
                if (searchField != null) searchField!,
                Flexible(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}
