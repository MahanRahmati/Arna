import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show DefaultMaterialLocalizations;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'semantics_tester.dart';

void main() {
  testWidgets('ArnaScaffold drawer callback test', (
    final WidgetTester tester,
  ) async {
    bool isDrawerOpen = false;

    await tester.pumpWidget(
      ArnaApp(
        home: ArnaScaffold(
          drawer: const ArnaDrawer(),
          onDrawerChanged: (final bool isOpen) {
            isDrawerOpen = isOpen;
          },
          body: Container(),
        ),
      ),
    );

    final ArnaScaffoldState scaffoldState = tester.state(
      find.byType(ArnaScaffold),
    );

    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    expect(isDrawerOpen, true);
  });

  testWidgets('ArnaScaffold drawer callback test - only call when changed', (
    final WidgetTester tester,
  ) async {
    // Regression test for https://github.com/flutter/flutter/issues/87914
    const bool onDrawerChangedCalled = false;

    await tester.pumpWidget(
      ArnaApp(
        home: ArnaScaffold(
          drawer: const ArnaDrawer(),
          body: Container(),
        ),
      ),
    );

    await tester.flingFrom(Offset.zero, const Offset(10.0, 0.0), 10.0);
    expect(onDrawerChangedCalled, false);

    await tester.pumpAndSettle();
  });

  testWidgets('ArnaScaffold control test', (final WidgetTester tester) async {
    final Key bodyKey = UniqueKey();
    Widget boilerplate(final Widget child) {
      return Localizations(
        locale: const Locale('en', 'us'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      );
    }

    await tester.pumpWidget(
      boilerplate(
        ArnaScaffold(
          headerBar: ArnaHeaderBar(title: 'Title'),
          body: Container(key: bodyKey),
        ),
      ),
    );
    expect(tester.takeException(), isFlutterError);

    await tester.pumpWidget(
      ArnaApp(
        home: ArnaScaffold(
          headerBar: ArnaHeaderBar(title: 'Title'),
          body: Container(key: bodyKey),
        ),
      ),
    );
    RenderBox bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 544.0)));

    await tester.pumpWidget(
      boilerplate(
        MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 100.0),
          ),
          child: ArnaScaffold(
            headerBar: ArnaHeaderBar(title: 'Title'),
            body: Container(key: bodyKey),
          ),
        ),
      ),
    );

    bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 444.0)));

    await tester.pumpWidget(
      boilerplate(
        MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 100.0),
          ),
          child: ArnaScaffold(
            headerBar: ArnaHeaderBar(title: 'Title'),
            body: Container(key: bodyKey),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );

    bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 544.0)));
  });

  testWidgets('Scaffold large bottom padding test', (
    final WidgetTester tester,
  ) async {
    final Key bodyKey = UniqueKey();

    Widget boilerplate(final Widget child) {
      return Localizations(
        locale: const Locale('en', 'us'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      );
    }

    await tester.pumpWidget(
      boilerplate(
        MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 700.0),
          ),
          child: ArnaScaffold(
            body: Container(key: bodyKey),
          ),
        ),
      ),
    );

    final RenderBox bodyBox = tester.renderObject(find.byKey(bodyKey));
    expect(bodyBox.size, equals(const Size(800.0, 0.0)));

    await tester.pumpWidget(
      boilerplate(
        MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 500.0),
          ),
          child: ArnaScaffold(
            body: Container(key: bodyKey),
          ),
        ),
      ),
    );

    expect(bodyBox.size, equals(const Size(800.0, 100.0)));

    await tester.pumpWidget(
      boilerplate(
        MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 580.0),
          ),
          child: ArnaScaffold(
            headerBar: ArnaHeaderBar(title: 'Title'),
            body: Container(key: bodyKey),
          ),
        ),
      ),
    );

    expect(bodyBox.size, equals(const Size(800.0, 0.0)));
  });

  group('close button', () {
    Future<void> expectCloseIcon(
      final WidgetTester tester,
      final PageRoute<void> Function() routeBuilder,
      final String type,
    ) async {
      await tester.pumpWidget(
        ArnaApp(
          home: ArnaScaffold(
            headerBar: ArnaHeaderBar(),
            body: const Text('Page 1'),
          ),
        ),
      );

      tester.state<NavigatorState>(find.byType(Navigator)).push(routeBuilder());

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.byType(ArnaCloseButton),
        findsOneWidget,
        reason: "didn't find close button for $type",
      );
    }

    PageRoute<void> arnaRouteBuilder() {
      return ArnaPageRoute<void>(
        builder: (final BuildContext context) {
          return ArnaScaffold(
            headerBar: ArnaHeaderBar(),
            body: const Text('Page 2'),
          );
        },
        fullscreenDialog: true,
      );
    }

    PageRoute<void> pageRouteBuilder() {
      return PageRouteBuilder<void>(
        pageBuilder: (
          final BuildContext context,
          final Animation<double> animation,
          final Animation<double> secondaryAnimation,
        ) {
          return ArnaScaffold(
            headerBar: ArnaHeaderBar(),
            body: const Text('Page 2'),
          );
        },
        fullscreenDialog: true,
      );
    }

    PageRoute<void> customPageRouteBuilder() {
      return _CustomPageRoute<void>(
        builder: (final BuildContext context) {
          return ArnaScaffold(
            headerBar: ArnaHeaderBar(),
            body: const Text('Page 2'),
          );
        },
        fullscreenDialog: true,
      );
    }

    testWidgets(
      'Close button shows correctly',
      (final WidgetTester tester) async {
        await expectCloseIcon(
          tester,
          arnaRouteBuilder,
          'arnaRouteBuilder',
        );
      },
      variant: TargetPlatformVariant.all(),
    );

    testWidgets(
      'Close button shows correctly with PageRouteBuilder',
      (final WidgetTester tester) async {
        await expectCloseIcon(tester, pageRouteBuilder, 'pageRouteBuilder');
      },
      variant: TargetPlatformVariant.all(),
    );

    testWidgets(
      'Close button shows correctly with custom page route',
      (final WidgetTester tester) async {
        await expectCloseIcon(
          tester,
          customPageRouteBuilder,
          'customPageRouteBuilder',
        );
      },
      variant: TargetPlatformVariant.all(),
    );
  });

  group('body size', () {
    testWidgets('body size with container', (final WidgetTester tester) async {
      final Key testKey = UniqueKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ArnaScaffold(
              body: Container(key: testKey),
            ),
          ),
        ),
      );
      expect(
        tester.element(find.byKey(testKey)).size,
        const Size(800.0, 600.0),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byKey(testKey))
            .localToGlobal(Offset.zero),
        Offset.zero,
      );
    });

    testWidgets('body size with sized container', (
      final WidgetTester tester,
    ) async {
      final Key testKey = UniqueKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ArnaScaffold(
              body: Container(
                key: testKey,
                height: 100.0,
              ),
            ),
          ),
        ),
      );
      expect(
        tester.element(find.byKey(testKey)).size,
        const Size(800.0, 100.0),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byKey(testKey))
            .localToGlobal(Offset.zero),
        Offset.zero,
      );
    });

    testWidgets('body size with centered container', (
      final WidgetTester tester,
    ) async {
      final Key testKey = UniqueKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ArnaScaffold(
              body: Center(
                child: Container(key: testKey),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.element(find.byKey(testKey)).size,
        const Size(800.0, 600.0),
      );
      expect(
        tester
            .renderObject<RenderBox>(find.byKey(testKey))
            .localToGlobal(Offset.zero),
        Offset.zero,
      );
    });

    testWidgets('body size with button', (final WidgetTester tester) async {
      final Key testKey = UniqueKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ArnaScaffold(
              body: ArnaButton.text(
                key: testKey,
                onPressed: () {},
                label: '',
              ),
            ),
          ),
        ),
      );
      expect(tester.element(find.byKey(testKey)).size, const Size(49.0, 49.0));
      expect(
        tester
            .renderObject<RenderBox>(find.byKey(testKey))
            .localToGlobal(Offset.zero),
        Offset.zero,
      );
    });
  });

  testWidgets('Open drawer hides underlying semantics tree', (
    final WidgetTester tester,
  ) async {
    const String bodyLabel = 'I am the body';
    const String navigationBarLabel = 'a bar in an app';
    const String drawerLabel = 'I am the reason for this test';

    final SemanticsTester semantics = SemanticsTester(tester);
    await tester.pumpWidget(
      const ArnaApp(
        home: ArnaScaffold(
          body: Text(bodyLabel),
          navigationBar: Text(navigationBarLabel),
          drawer: ArnaDrawer(child: Text(drawerLabel)),
        ),
      ),
    );

    expect(semantics, includesNodeWith(label: bodyLabel));
    expect(semantics, includesNodeWith(label: navigationBarLabel));
    expect(semantics, isNot(includesNodeWith(label: drawerLabel)));

    final ArnaScaffoldState state = tester.firstState(
      find.byType(ArnaScaffold),
    );
    state.openDrawer();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(semantics, isNot(includesNodeWith(label: bodyLabel)));
    expect(semantics, isNot(includesNodeWith(label: navigationBarLabel)));
    expect(semantics, includesNodeWith(label: drawerLabel));

    semantics.dispose();
  });

  testWidgets('ArnaScaffold and extreme window padding', (
    final WidgetTester tester,
  ) async {
    final Key headerBar = UniqueKey();
    final Key body = UniqueKey();
    final Key drawer = UniqueKey();
    final Key navigationBar = UniqueKey();
    final Key insideHeaderBar = UniqueKey();
    final Key insideBody = UniqueKey();
    final Key insideDrawer = UniqueKey();
    final Key insideNavigationBar = UniqueKey();
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('en', 'us'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: const MediaQueryData(
              padding: EdgeInsets.only(
                left: 20.0,
                top: 30.0,
                right: 50.0,
                bottom: 60.0,
              ),
              viewInsets: EdgeInsets.only(bottom: 200.0),
            ),
            child: ArnaScaffold(
              headerBar: PreferredSize(
                preferredSize: const Size(11.0, 13.0),
                child: Container(
                  key: headerBar,
                  child: SafeArea(
                    child: Placeholder(key: insideHeaderBar),
                  ),
                ),
              ),
              body: Container(
                key: body,
                child: SafeArea(
                  child: Placeholder(key: insideBody),
                ),
              ),
              drawer: ArnaDrawer(
                key: drawer,
                child: SafeArea(
                  child: Placeholder(key: insideDrawer),
                ),
              ),
              navigationBar: SizedBox(
                key: navigationBar,
                height: 85.0,
                child: SafeArea(
                  child: Placeholder(key: insideNavigationBar),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // open drawer

    final ArnaScaffoldState scaffoldState = tester.state(
      find.byType(ArnaScaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byKey(headerBar)),
      const Rect.fromLTRB(0.0, 0.0, 800.0, 43.0),
    );
    expect(
      tester.getRect(find.byKey(body)),
      const Rect.fromLTRB(0.0, 43.0, 800.0, 400.0),
    );
    expect(
      tester.getRect(find.byKey(drawer)),
      const Rect.fromLTRB(800.0, 0.0, 800.0, 600.0),
    );
    expect(
      tester.getRect(find.byKey(navigationBar)),
      const Rect.fromLTRB(0.0, 515.0, 800.0, 600.0),
    );
    expect(
      tester.getRect(find.byKey(insideHeaderBar)),
      const Rect.fromLTRB(20.0, 30.0, 750.0, 43.0),
    );
    expect(
      tester.getRect(find.byKey(insideBody)),
      const Rect.fromLTRB(20.0, 43.0, 750.0, 400.0),
    );
    expect(
      tester.getRect(find.byKey(insideDrawer)),
      const Rect.fromLTRB(800.0, 30.0, 800.0, 540.0),
    );
    expect(
      tester.getRect(find.byKey(insideNavigationBar)),
      const Rect.fromLTRB(20.0, 515.0, 750.0, 540.0),
    );
  });

  testWidgets('Nested scaffold body insets', (final WidgetTester tester) async {
    // Regression test for https://github.com/flutter/flutter/issues/20295
    final Key bodyKey = UniqueKey();

    Widget buildFrame({
      final bool? innerResizeToAvoidBottomInset,
      final bool? outerResizeToAvoidBottomInset,
    }) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 100.0),
          ),
          child: Builder(
            builder: (final BuildContext context) {
              return ArnaScaffold(
                resizeToAvoidBottomInset: outerResizeToAvoidBottomInset,
                body: Builder(
                  builder: (final BuildContext context) {
                    return ArnaScaffold(
                      resizeToAvoidBottomInset: innerResizeToAvoidBottomInset,
                      body: Container(key: bodyKey),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    await tester.pumpWidget(
      buildFrame(
        innerResizeToAvoidBottomInset: true,
        outerResizeToAvoidBottomInset: true,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));

    await tester.pumpWidget(
      buildFrame(
        innerResizeToAvoidBottomInset: false,
        outerResizeToAvoidBottomInset: true,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));

    await tester.pumpWidget(
      buildFrame(
        innerResizeToAvoidBottomInset: true,
        outerResizeToAvoidBottomInset: false,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));

    // This is the only case where the body is not bottom inset.
    await tester.pumpWidget(
      buildFrame(
        innerResizeToAvoidBottomInset: false,
        outerResizeToAvoidBottomInset: false,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 600.0));

    await tester.pumpWidget(
      buildFrame(),
    ); // resizeToAvoidBottomInset default is true
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));

    await tester.pumpWidget(
      buildFrame(
        outerResizeToAvoidBottomInset: false,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));
    await tester.pumpWidget(
      buildFrame(
        innerResizeToAvoidBottomInset: false,
      ),
    );
    expect(tester.getSize(find.byKey(bodyKey)), const Size(800.0, 500.0));
  });

  group('FlutterError control test', () {
    testWidgets('Call to ArnaScaffold.of() without context', (
      final WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ArnaApp(
          home: Builder(
            builder: (final BuildContext context) {
              ArnaScaffold.of(context).openDrawer();
              return Container();
            },
          ),
        ),
      );
      final dynamic exception = tester.takeException();
      expect(exception, isFlutterError);
      final FlutterError error = exception as FlutterError;
      expect(error.diagnostics.length, 5);
      expect(error.diagnostics[2].level, DiagnosticLevel.hint);
      expect(
        error.diagnostics[2].toStringDeep(),
        equalsIgnoringHashCodes(
          'There are several ways to avoid this problem. The simplest is to\n'
          'use a Builder to get a context that is "under" the ArnaScaffold.\n'
          'For an example of this, please see the documentation for\n'
          'ArnaScaffold.of().\n',
        ),
      );
      expect(error.diagnostics[3].level, DiagnosticLevel.hint);
      expect(
        error.diagnostics[3].toStringDeep(),
        equalsIgnoringHashCodes(
          'A more efficient solution is to split your build function into\n'
          'several widgets. This introduces a new context from which you can\n'
          'obtain the ArnaScaffold. In this solution, you would have an\n'
          'outer widget that creates the ArnaScaffold populated by instances\n'
          'of your new inner widgets, and then in these inner widgets you\n'
          'would use ArnaScaffold.of().\n'
          'A less elegant but more expedient solution is assign a GlobalKey\n'
          'to the ArnaScaffold, then use the key.currentState property to\n'
          'obtain the ArnaScaffoldState rather than using the\n'
          'ArnaScaffold.of() function.\n',
        ),
      );
      expect(error.diagnostics[4], isA<DiagnosticsProperty<Element>>());
      expect(
        error.toStringDeep(),
        'FlutterError\n'
        '   ArnaScaffold.of() called with a context that does not contain an\n'
        '   ArnaScaffold.\n'
        '   No ArnaScaffold ancestor could be found starting from the context\n'
        '   that was passed to ArnaScaffold.of(). This usually happens when\n'
        '   the context provided is from the same StatefulWidget as that\n'
        '   whose build function actually creates the ArnaScaffold widget\n'
        '   being sought.\n'
        '   There are several ways to avoid this problem. The simplest is to\n'
        '   use a Builder to get a context that is "under" the ArnaScaffold.\n'
        '   For an example of this, please see the documentation for\n'
        '   ArnaScaffold.of().\n'
        '   A more efficient solution is to split your build function into\n'
        '   several widgets. This introduces a new context from which you can\n'
        '   obtain the ArnaScaffold. In this solution, you would have an\n'
        '   outer widget that creates the ArnaScaffold populated by instances\n'
        '   of your new inner widgets, and then in these inner widgets you\n'
        '   would use ArnaScaffold.of().\n'
        '   A less elegant but more expedient solution is assign a GlobalKey\n'
        '   to the ArnaScaffold, then use the key.currentState property to\n'
        '   obtain the ArnaScaffoldState rather than using the\n'
        '   ArnaScaffold.of() function.\n'
        '   The context used was:\n'
        '     Builder\n',
      );
      await tester.pumpAndSettle();
    });
  });

  testWidgets('Drawer can be dismissed with escape keyboard shortcut', (
    final WidgetTester tester,
  ) async {
    // Regression test for https://github.com/flutter/flutter/issues/106131
    bool isDrawerOpen = false;

    await tester.pumpWidget(
      ArnaApp(
        home: ArnaScaffold(
          drawer: const ArnaDrawer(),
          onDrawerChanged: (final bool isOpen) {
            isDrawerOpen = isOpen;
          },
          body: Container(),
        ),
      ),
    );

    final ArnaScaffoldState scaffoldState = tester.state(
      find.byType(ArnaScaffold),
    );

    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
    expect(isDrawerOpen, true);

    // Try to dismiss the drawer with the shortcut key
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(isDrawerOpen, false);
  });
}

class _CustomPageRoute<T> extends PageRoute<T> {
  _CustomPageRoute({
    required this.builder,
    RouteSettings super.settings = const RouteSettings(),
    this.maintainState = true,
    super.fullscreenDialog,
  }) : assert(builder != null);

  final WidgetBuilder builder;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  final bool maintainState;

  @override
  Widget buildPage(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    return child;
  }
}
