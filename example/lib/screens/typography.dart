import 'package:arna/arna.dart';

import '/strings.dart';

class Typography extends StatelessWidget {
  const Typography({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Styles.normal,
        child: SizedBox(
          width: ArnaHelpers.deviceWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.display,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.headline,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.body,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.button,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.subtitle,
                ),
              ),
              Padding(
                padding: Styles.normal,
                child: Text(
                  Strings.lorem,
                  style: ArnaTheme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
