import 'package:arna/arna.dart';

class Typography extends StatelessWidget {
  const Typography({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Styles.normal,
        child: SizedBox(
          width: deviceWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.largeTitleTextStyle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.titleTextStyle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.textStyle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.buttonTextStyle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.subtitleTextStyle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  "Lorem ipsum dolor",
                  style: ArnaTheme.of(context).textTheme.captionTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
