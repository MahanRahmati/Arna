import 'package:arna/arna.dart';

class ArnaHeaderBar extends StatelessWidget {
  final Widget leading;
  final Widget middle;
  final Widget trailing;

  const ArnaHeaderBar({
    Key? key,
    this.leading = const SizedBox.shrink(),
    this.middle = const SizedBox.shrink(),
    this.trailing = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Container(
                height: Styles.headerBarHeight,
                color: ArnaTheme.of(context).barBackgroundColor,
                child: Padding(
                  padding: Styles.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [leading, middle, trailing],
                  ),
                ),
              ),
              const ArnaHorizontalDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
