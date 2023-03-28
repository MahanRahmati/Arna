import 'package:arna/arna.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Navigation bar updates destinations when tapped', (
    final WidgetTester tester,
  ) async {
    int mutatedIndex = -1;
    final Widget widget = _buildWidget(
      ArnaNavigationBar(
        destinations: const <ArnaNavigationDestination>[
          ArnaNavigationDestination(
            icon: Icons.ac_unit,
            label: 'AC',
          ),
          ArnaNavigationDestination(
            icon: Icons.access_alarm,
            label: 'Alarm',
          ),
        ],
        onDestinationSelected: (final int i) {
          mutatedIndex = i;
        },
      ),
    );

    await tester.pumpWidget(widget);

    expect(find.text('AC'), findsOneWidget);
    expect(find.text('Alarm'), findsOneWidget);

    await tester.tap(find.text('Alarm'));
    expect(mutatedIndex, 1);

    await tester.tap(find.text('AC'));
    expect(mutatedIndex, 0);
  });

  testWidgets('ArnaNavigationBar adds bottom padding to height', (
    final WidgetTester tester,
  ) async {
    const double bottomPadding = 40.0;

    await tester.pumpWidget(
      _buildWidget(
        ArnaNavigationBar(
          destinations: const <ArnaNavigationDestination>[
            ArnaNavigationDestination(
              icon: Icons.ac_unit,
              label: 'AC',
            ),
            ArnaNavigationDestination(
              icon: Icons.access_alarm,
              label: 'Alarm',
            ),
          ],
          onDestinationSelected: (final int i) {},
        ),
      ),
    );

    final double defaultSize =
        tester.getSize(find.byType(ArnaNavigationBar)).height;
    expect(defaultSize, 78);

    await tester.pumpWidget(
      _buildWidget(
        MediaQuery(
          data: const MediaQueryData(
            padding: EdgeInsets.only(bottom: bottomPadding),
          ),
          child: ArnaNavigationBar(
            destinations: const <ArnaNavigationDestination>[
              ArnaNavigationDestination(
                icon: Icons.ac_unit,
                label: 'AC',
              ),
              ArnaNavigationDestination(
                icon: Icons.access_alarm,
                label: 'Alarm',
              ),
            ],
            onDestinationSelected: (final int i) {},
          ),
        ),
      ),
    );

    final double expectedHeight = defaultSize + bottomPadding;
    expect(
      tester.getSize(find.byType(ArnaNavigationBar)).height,
      expectedHeight,
    );
  });
}

Widget _buildWidget(final Widget child) {
  return ArnaApp(
    home: ArnaScaffold(
      navigationBar: Center(
        child: child,
      ),
    ),
  );
}
