import 'package:arna/arna.dart';
import 'package:flutter/cupertino.dart' show CupertinoLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class StateMarker extends StatefulWidget {
  const StateMarker({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  StateMarkerState createState() => StateMarkerState();
}

class StateMarkerState extends State<StateMarker> {
  late String marker;

  @override
  Widget build(final BuildContext context) {
    return widget.child != null ? widget.child! : Container();
  }
}

void main() {
  testWidgets('Can nest apps', (final WidgetTester tester) async {
    await tester.pumpWidget(
      const ArnaApp(
        home: ArnaApp(
          home: Text('Home sweet home'),
        ),
      ),
    );

    expect(find.text('Home sweet home'), findsOneWidget);
  });

  testWidgets('Focus handling', (final WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();
    await tester.pumpWidget(
      ArnaApp(
        home: Center(
          child: ArnaTextField(
            focusNode: focusNode,
            autofocus: true,
          ),
        ),
      ),
    );

    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('Can place app inside FocusScope', (
    final WidgetTester tester,
  ) async {
    final FocusScopeNode focusScopeNode = FocusScopeNode();

    await tester.pumpWidget(
      FocusScope(
        autofocus: true,
        node: focusScopeNode,
        child: const ArnaApp(
          home: Text('Home'),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Do not rebuild page during a route transition', (
    final WidgetTester tester,
  ) async {
    int buildCounter = 0;
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            return ArnaButton(
              child: const Text('X'),
              onPressed: () => Navigator.of(context).pushNamed('/next'),
            );
          },
        ),
        routes: <String, WidgetBuilder>{
          '/next': (final BuildContext context) {
            return Builder(
              builder: (final BuildContext context) {
                ++buildCounter;
                return const Text('Y');
              },
            );
          },
        },
      ),
    );

    expect(buildCounter, 0);
    await tester.tap(find.text('X'));
    expect(buildCounter, 0);
    await tester.pump();
    expect(buildCounter, 1);
    await tester.pump(const Duration(milliseconds: 10));
    expect(buildCounter, 1);
    await tester.pump(const Duration(milliseconds: 10));
    expect(buildCounter, 1);
    await tester.pump(const Duration(milliseconds: 10));
    expect(buildCounter, 1);
    await tester.pump(const Duration(milliseconds: 10));
    expect(buildCounter, 1);
    await tester.pump(const Duration(seconds: 1));
    expect(buildCounter, 1);
    expect(find.text('Y'), findsOneWidget);
  });

  testWidgets('Do rebuild the home page if it changes', (
    final WidgetTester tester,
  ) async {
    int buildCounter = 0;
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            ++buildCounter;
            return const Text('A');
          },
        ),
      ),
    );
    expect(buildCounter, 1);
    expect(find.text('A'), findsOneWidget);
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            ++buildCounter;
            return const Text('B');
          },
        ),
      ),
    );
    expect(buildCounter, 2);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('Do not rebuild the home page if it does not actually change', (
    final WidgetTester tester,
  ) async {
    int buildCounter = 0;
    final Widget home = Builder(
      builder: (final BuildContext context) {
        ++buildCounter;
        return const Placeholder();
      },
    );
    await tester.pumpWidget(
      ArnaApp(home: home),
    );
    expect(buildCounter, 1);
    await tester.pumpWidget(
      ArnaApp(home: home),
    );
    expect(buildCounter, 1);
  });

  testWidgets(
      'Do rebuild pages that come from the routes table if the ArnaApp changes',
      (
    final WidgetTester tester,
  ) async {
    int buildCounter = 0;
    final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      '/': (final BuildContext context) {
        ++buildCounter;
        return const Placeholder();
      },
    };
    await tester.pumpWidget(
      ArnaApp(routes: routes),
    );
    expect(buildCounter, 1);
    await tester.pumpWidget(
      ArnaApp(routes: routes),
    );
    expect(buildCounter, 2);
  });

  testWidgets('Cannot pop the initial route', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ArnaApp(home: Text('Home')));

    expect(find.text('Home'), findsOneWidget);

    final NavigatorState navigator = tester.state(find.byType(Navigator));
    final bool result = await navigator.maybePop();

    expect(result, isFalse);

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Default initialRoute', (final WidgetTester tester) async {
    await tester.pumpWidget(
      ArnaApp(
        routes: <String, WidgetBuilder>{
          '/': (final BuildContext context) => const Text('route "/"'),
        },
      ),
    );

    expect(find.text('route "/"'), findsOneWidget);
  });

  testWidgets('One-step initial route', (final WidgetTester tester) async {
    await tester.pumpWidget(
      ArnaApp(
        initialRoute: '/a',
        routes: <String, WidgetBuilder>{
          '/': (final BuildContext context) => const Text('route "/"'),
          '/a': (final BuildContext context) => const Text('route "/a"'),
          '/a/b': (final BuildContext context) => const Text('route "/a/b"'),
          '/b': (final BuildContext context) => const Text('route "/b"'),
        },
      ),
    );

    expect(find.text('route "/"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a"'), findsOneWidget);
    expect(find.text('route "/a/b"', skipOffstage: false), findsNothing);
    expect(find.text('route "/b"', skipOffstage: false), findsNothing);
  });

  testWidgets('Return value from pop is correct',
      (final WidgetTester tester) async {
    late Future<Object?> result;
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            return ArnaButton(
              child: const Text('X'),
              onPressed: () async {
                result = Navigator.of(context).pushNamed<Object?>('/a');
              },
            );
          },
        ),
        routes: <String, WidgetBuilder>{
          '/a': (final BuildContext context) {
            return ArnaButton(
              child: const Text('Y'),
              onPressed: () => Navigator.of(context).pop('all done'),
            );
          },
        },
      ),
    );
    await tester.tap(find.text('X'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Y'), findsOneWidget);
    await tester.tap(find.text('Y'));
    await tester.pump();

    expect(await result, equals('all done'));
  });

  testWidgets('Two-step initial route', (final WidgetTester tester) async {
    final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      '/': (final BuildContext context) => const Text('route "/"'),
      '/a': (final BuildContext context) => const Text('route "/a"'),
      '/a/b': (final BuildContext context) => const Text('route "/a/b"'),
      '/b': (final BuildContext context) => const Text('route "/b"'),
    };

    await tester.pumpWidget(
      ArnaApp(
        initialRoute: '/a/b',
        routes: routes,
      ),
    );
    expect(find.text('route "/"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a/b"'), findsOneWidget);
    expect(find.text('route "/b"', skipOffstage: false), findsNothing);
  });

  testWidgets('Initial route with missing step', (
    final WidgetTester tester,
  ) async {
    final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      '/': (final BuildContext context) => const Text('route "/"'),
      '/a': (final BuildContext context) => const Text('route "/a"'),
      '/a/b': (final BuildContext context) => const Text('route "/a/b"'),
      '/b': (final BuildContext context) => const Text('route "/b"'),
    };

    await tester.pumpWidget(
      ArnaApp(
        initialRoute: '/a/b/c',
        routes: routes,
      ),
    );
    final dynamic exception = tester.takeException();
    expect(exception, isA<String>());
    if (exception is String) {
      expect(
        exception.startsWith('Could not navigate to initial route.'),
        isTrue,
      );
      expect(find.text('route "/"'), findsOneWidget);
      expect(find.text('route "/a"'), findsNothing);
      expect(find.text('route "/a/b"'), findsNothing);
      expect(find.text('route "/b"'), findsNothing);
    }
  });

  testWidgets('Make sure initialRoute is only used the first time', (
    final WidgetTester tester,
  ) async {
    final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      '/': (final BuildContext context) => const Text('route "/"'),
      '/a': (final BuildContext context) => const Text('route "/a"'),
      '/b': (final BuildContext context) => const Text('route "/b"'),
    };

    await tester.pumpWidget(
      ArnaApp(
        initialRoute: '/a',
        routes: routes,
      ),
    );
    expect(find.text('route "/"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a"'), findsOneWidget);
    expect(find.text('route "/b"', skipOffstage: false), findsNothing);

    // changing initialRoute has no effect
    await tester.pumpWidget(
      ArnaApp(
        initialRoute: '/b',
        routes: routes,
      ),
    );
    expect(find.text('route "/"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a"'), findsOneWidget);
    expect(find.text('route "/b"', skipOffstage: false), findsNothing);

    // removing it has no effect
    await tester.pumpWidget(ArnaApp(routes: routes));
    expect(find.text('route "/"', skipOffstage: false), findsOneWidget);
    expect(find.text('route "/a"'), findsOneWidget);
    expect(find.text('route "/b"', skipOffstage: false), findsNothing);
  });

  testWidgets('onGenerateRoute / onUnknownRoute', (
    final WidgetTester tester,
  ) async {
    final List<String> log = <String>[];
    await tester.pumpWidget(
      ArnaApp(
        onGenerateRoute: (final RouteSettings settings) {
          log.add('onGenerateRoute ${settings.name}');
          return null;
        },
        onUnknownRoute: (final RouteSettings settings) {
          log.add('onUnknownRoute ${settings.name}');
          return null;
        },
      ),
    );
    expect(tester.takeException(), isFlutterError);
    expect(log, <String>['onGenerateRoute /', 'onUnknownRoute /']);

    // Work-around for https://github.com/flutter/flutter/issues/65655.
    await tester.pumpWidget(Container());
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('ArnaApp with builder and no route information works.', (
    final WidgetTester tester,
  ) async {
    // Regression test for https://github.com/flutter/flutter/issues/18904
    await tester.pumpWidget(
      ArnaApp(
        builder: (final BuildContext context, final Widget? child) {
          return const SizedBox();
        },
      ),
    );
  });

  testWidgets("WidgetsApp don't rebuild routes when MediaQuery updates", (
    final WidgetTester tester,
  ) async {
    // Regression test for https://github.com/flutter/flutter/issues/37878
    int routeBuildCount = 0;
    int dependentBuildCount = 0;

    await tester.pumpWidget(
      WidgetsApp(
        color: const Color.fromARGB(255, 255, 255, 255),
        onGenerateRoute: (final _) {
          return PageRouteBuilder<void>(
            pageBuilder: (final _, final __, final ___) {
              routeBuildCount++;
              return Builder(
                builder: (final BuildContext context) {
                  dependentBuildCount++;
                  MediaQuery.of(context);
                  return Container();
                },
              );
            },
          );
        },
      ),
    );

    expect(routeBuildCount, equals(1));
    expect(dependentBuildCount, equals(1));

    // didChangeMetrics
    tester.binding.window.physicalSizeTestValue = const Size.square(42);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pump();

    expect(routeBuildCount, equals(1));
    expect(dependentBuildCount, equals(2));

    // didChangeTextScaleFactor
    tester.binding.platformDispatcher.textScaleFactorTestValue = 42;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );

    await tester.pump();

    expect(routeBuildCount, equals(1));
    expect(dependentBuildCount, equals(3));

    // didChangePlatformBrightness
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );

    await tester.pump();

    expect(routeBuildCount, equals(1));
    expect(dependentBuildCount, equals(4));

    // didChangeAccessibilityFeatures
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        FakeAccessibilityFeatures.allOn;
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );

    await tester.pump();

    expect(routeBuildCount, equals(1));
    expect(dependentBuildCount, equals(5));
  });

  testWidgets('Can get text scale from media query', (
    final WidgetTester tester,
  ) async {
    double? textScaleFactor;
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            textScaleFactor = MediaQuery.textScaleFactorOf(context);
            return Container();
          },
        ),
      ),
    );
    expect(textScaleFactor, isNotNull);
    expect(textScaleFactor, equals(1.0));
  });

  testWidgets('ArnaApp.navigatorKey', (final WidgetTester tester) async {
    final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ArnaApp(
        navigatorKey: key,
        color: const Color(0xFF112233),
        home: const Placeholder(),
      ),
    );
    expect(key.currentState, isA<NavigatorState>());
    await tester.pumpWidget(
      const ArnaApp(
        color: Color(0xFF112233),
        home: Placeholder(),
      ),
    );
    expect(key.currentState, isNull);
    await tester.pumpWidget(
      ArnaApp(
        navigatorKey: key,
        color: const Color(0xFF112233),
        home: const Placeholder(),
      ),
    );
    expect(key.currentState, isA<NavigatorState>());
  });

  testWidgets('Has default material and cupertino localizations', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            return Column(
              children: <Widget>[
                Text(MaterialLocalizations.of(context).selectAllButtonLabel),
                Text(CupertinoLocalizations.of(context).selectAllButtonLabel),
              ],
            );
          },
        ),
      ),
    );

    // Default US "select all" text.
    expect(find.text('Select all'), findsOneWidget);
    // Default Cupertino US "select all" text.
    expect(find.text('Select All'), findsOneWidget);
  });

  testWidgets('ArnaApp uses light theme when brightness is light', (
    final WidgetTester tester,
  ) async {
    // Mock the Window to explicitly report a light platformBrightness.
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;

    late ArnaThemeData appliedTheme;
    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(
          brightness: Brightness.light,
        ),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(appliedTheme.brightness, Brightness.light);

    // Mock the Window to explicitly report a dark platformBrightness.
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(
          brightness: Brightness.light,
        ),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(appliedTheme.brightness, Brightness.light);
  });

  testWidgets('ArnaApp uses darkTheme when brightness is dark',
      (final WidgetTester tester) async {
    // Mock the Window to explicitly report a light platformBrightness.
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;

    late ArnaThemeData appliedTheme;
    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(
          brightness: Brightness.dark,
        ),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(appliedTheme.brightness, Brightness.dark);

    // Mock the Window to explicitly report a dark platformBrightness.
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(
          brightness: Brightness.dark,
        ),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(appliedTheme.brightness, Brightness.dark);
  });

  testWidgets(
      'ArnaApp uses light theme when brightness is null and platformBrightness '
      'is light', (final WidgetTester tester) async {
    // Mock the Window to explicitly report a light platformBrightness.
    final TestWidgetsFlutterBinding binding = tester.binding;
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;

    late ArnaThemeData appliedTheme;

    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(appliedTheme.brightness, Brightness.light);
  });

  testWidgets(
      'ArnaApp uses darkTheme when brightness is null and platformBrightness '
      'is dark', (final WidgetTester tester) async {
    // Mock the Window to explicitly report a dark platformBrightness.
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;

    late ArnaThemeData appliedTheme;
    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(),
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(appliedTheme.brightness, Brightness.dark);
  });

  testWidgets('ArnaApp uses dark theme when platformBrightness is dark', (
    final WidgetTester tester,
  ) async {
    // Mock the Window to explicitly report a dark platformBrightness.
    final TestWidgetsFlutterBinding binding = tester.binding;
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    late ArnaThemeData appliedTheme;

    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(appliedTheme.brightness, Brightness.dark);
  });

  testWidgets('ArnaApp uses light theme when platformBrightness is light', (
    final WidgetTester tester,
  ) async {
    // Mock the Window to explicitly report a dark platformBrightness.
    final TestWidgetsFlutterBinding binding = tester.binding;
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;

    late ArnaThemeData appliedTheme;

    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            appliedTheme = ArnaTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(appliedTheme.brightness, Brightness.light);
  });

  testWidgets(
      'ArnaApp switches themes when the Window platformBrightness changes.', (
    final WidgetTester tester,
  ) async {
    // Mock the Window to explicitly report a light platformBrightness.
    final TestWidgetsFlutterBinding binding = tester.binding;
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;

    ArnaThemeData? themeBeforeBrightnessChange;
    ArnaThemeData? themeAfterBrightnessChange;

    await tester.pumpWidget(
      ArnaApp(
        theme: ArnaThemeData(),
        home: Builder(
          builder: (final BuildContext context) {
            if (themeBeforeBrightnessChange == null) {
              themeBeforeBrightnessChange = ArnaTheme.of(context);
            } else {
              themeAfterBrightnessChange = ArnaTheme.of(context);
            }
            return const SizedBox();
          },
        ),
      ),
    );

    // Switch the platformBrightness from light to dark and pump the widget tree
    // to process changes.
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();

    expect(themeBeforeBrightnessChange!.brightness, Brightness.light);
    expect(themeAfterBrightnessChange!.brightness, Brightness.dark);
  });

  testWidgets('ArnaApp can customize initial routes', (
    final WidgetTester tester,
  ) async {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ArnaApp(
        navigatorKey: navigatorKey,
        onGenerateInitialRoutes: (final String initialRoute) {
          expect(initialRoute, '/abc');
          return <Route<void>>[
            PageRouteBuilder<void>(
              pageBuilder: (
                final BuildContext context,
                final Animation<double> animation,
                final Animation<double> secondaryAnimation,
              ) {
                return const Text('non-regular page one');
              },
            ),
            PageRouteBuilder<void>(
              pageBuilder: (
                final BuildContext context,
                final Animation<double> animation,
                final Animation<double> secondaryAnimation,
              ) {
                return const Text('non-regular page two');
              },
            ),
          ];
        },
        initialRoute: '/abc',
        routes: <String, WidgetBuilder>{
          '/': (final BuildContext context) => const Text('regular page one'),
          '/abc': (final BuildContext context) =>
              const Text('regular page two'),
        },
      ),
    );
    expect(find.text('non-regular page two'), findsOneWidget);
    expect(find.text('non-regular page one'), findsNothing);
    expect(find.text('regular page one'), findsNothing);
    expect(find.text('regular page two'), findsNothing);
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('non-regular page two'), findsNothing);
    expect(find.text('non-regular page one'), findsOneWidget);
    expect(find.text('regular page one'), findsNothing);
    expect(find.text('regular page two'), findsNothing);
  });

  testWidgets('ArnaApp.navigatorKey can be updated', (
    final WidgetTester tester,
  ) async {
    final GlobalKey<NavigatorState> key1 = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ArnaApp(
        navigatorKey: key1,
        home: const Placeholder(),
      ),
    );
    expect(key1.currentState, isA<NavigatorState>());
    final GlobalKey<NavigatorState> key2 = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      ArnaApp(
        navigatorKey: key2,
        home: const Placeholder(),
      ),
    );
    expect(key2.currentState, isA<NavigatorState>());
    expect(key1.currentState, isNull);
  });

  testWidgets('ArnaApp.router works', (final WidgetTester tester) async {
    final PlatformRouteInformationProvider provider =
        PlatformRouteInformationProvider(
      initialRouteInformation: const RouteInformation(
        location: 'initial',
      ),
    );
    final SimpleNavigatorRouterDelegate delegate =
        SimpleNavigatorRouterDelegate(
      builder: (
        final BuildContext context,
        final RouteInformation information,
      ) {
        return Text(information.location!);
      },
      onPopPage: (
        final Route<void> route,
        final void result,
        final SimpleNavigatorRouterDelegate delegate,
      ) {
        delegate.routeInformation = const RouteInformation(
          location: 'popped',
        );
        return route.didPop(result);
      },
    );
    await tester.pumpWidget(
      ArnaApp.router(
        routeInformationProvider: provider,
        routeInformationParser: SimpleRouteInformationParser(),
        routerDelegate: delegate,
      ),
    );
    expect(find.text('initial'), findsOneWidget);

    // Simulate android back button intent.
    final ByteData message =
        const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
    await ServicesBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage('flutter/navigation', message, (final _) {});
    await tester.pumpAndSettle();
    expect(find.text('popped'), findsOneWidget);
  });

  testWidgets('ArnaApp.router route information parser is optional', (
    final WidgetTester tester,
  ) async {
    final SimpleNavigatorRouterDelegate delegate =
        SimpleNavigatorRouterDelegate(
      builder: (
        final BuildContext context,
        final RouteInformation information,
      ) {
        return Text(information.location!);
      },
      onPopPage: (
        final Route<void> route,
        final void result,
        final SimpleNavigatorRouterDelegate delegate,
      ) {
        delegate.routeInformation = const RouteInformation(
          location: 'popped',
        );
        return route.didPop(result);
      },
    );
    delegate.routeInformation = const RouteInformation(location: 'initial');
    await tester.pumpWidget(
      ArnaApp.router(
        routerDelegate: delegate,
      ),
    );
    expect(find.text('initial'), findsOneWidget);

    // Simulate android back button intent.
    final ByteData message =
        const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
    await ServicesBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage('flutter/navigation', message, (final _) {});
    await tester.pumpAndSettle();
    expect(find.text('popped'), findsOneWidget);
  });

  testWidgets(
      'ArnaApp.router throw if route information provider is provided but no '
      'route information parser', (final WidgetTester tester) async {
    final SimpleNavigatorRouterDelegate delegate =
        SimpleNavigatorRouterDelegate(
      builder: (
        final BuildContext context,
        final RouteInformation information,
      ) {
        return Text(information.location!);
      },
      onPopPage: (
        final Route<void> route,
        final void result,
        final SimpleNavigatorRouterDelegate delegate,
      ) {
        delegate.routeInformation = const RouteInformation(
          location: 'popped',
        );
        return route.didPop(result);
      },
    );
    delegate.routeInformation = const RouteInformation(location: 'initial');
    final PlatformRouteInformationProvider provider =
        PlatformRouteInformationProvider(
      initialRouteInformation: const RouteInformation(
        location: 'initial',
      ),
    );
    await tester.pumpWidget(
      ArnaApp.router(
        routeInformationProvider: provider,
        routerDelegate: delegate,
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets(
      'ArnaApp.router throw if route configuration is provided along with '
      'other delegate', (final WidgetTester tester) async {
    final SimpleNavigatorRouterDelegate delegate =
        SimpleNavigatorRouterDelegate(
      builder: (
        final BuildContext context,
        final RouteInformation information,
      ) {
        return Text(information.location!);
      },
      onPopPage: (
        final Route<void> route,
        final void result,
        final SimpleNavigatorRouterDelegate delegate,
      ) {
        delegate.routeInformation = const RouteInformation(
          location: 'popped',
        );
        return route.didPop(result);
      },
    );
    delegate.routeInformation = const RouteInformation(location: 'initial');
    final RouterConfig<RouteInformation> routerConfig =
        RouterConfig<RouteInformation>(routerDelegate: delegate);
    await tester.pumpWidget(
      ArnaApp.router(
        routerDelegate: delegate,
        routerConfig: routerConfig,
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('ArnaApp.router router config works',
      (final WidgetTester tester) async {
    final RouterConfig<RouteInformation> routerConfig =
        RouterConfig<RouteInformation>(
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: const RouteInformation(
          location: 'initial',
        ),
      ),
      routeInformationParser: SimpleRouteInformationParser(),
      routerDelegate: SimpleNavigatorRouterDelegate(
        builder: (
          final BuildContext context,
          final RouteInformation information,
        ) {
          return Text(information.location!);
        },
        onPopPage: (
          final Route<void> route,
          final void result,
          final SimpleNavigatorRouterDelegate delegate,
        ) {
          delegate.routeInformation = const RouteInformation(
            location: 'popped',
          );
          return route.didPop(result);
        },
      ),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
    await tester.pumpWidget(
      ArnaApp.router(
        routerConfig: routerConfig,
      ),
    );
    expect(find.text('initial'), findsOneWidget);

    // Simulate android back button intent.
    final ByteData message =
        const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute'));
    await ServicesBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage('flutter/navigation', message, (final _) {});
    await tester.pumpAndSettle();
    expect(find.text('popped'), findsOneWidget);
  });

  testWidgets('ArnaApp.builder can build app without a Navigator', (
    final WidgetTester tester,
  ) async {
    Widget? builderChild;
    await tester.pumpWidget(
      ArnaApp(
        builder: (final BuildContext context, final Widget? child) {
          builderChild = child;
          return Container();
        },
      ),
    );
    expect(builderChild, isNull);
  });

  testWidgets('ArnaApp has correct default ScrollBehavior', (
    final WidgetTester tester,
  ) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      ArnaApp(
        home: Builder(
          builder: (final BuildContext context) {
            capturedContext = context;
            return const Placeholder();
          },
        ),
      ),
    );
    expect(
      ScrollConfiguration.of(capturedContext).runtimeType,
      ArnaScrollBehavior,
    );
  });

  testWidgets('A ScrollBehavior can be set for ArnaApp', (
    final WidgetTester tester,
  ) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      ArnaApp(
        scrollBehavior: const MockScrollBehavior(),
        home: Builder(
          builder: (final BuildContext context) {
            capturedContext = context;
            return const Placeholder();
          },
        ),
      ),
    );
    final ScrollBehavior scrollBehavior =
        ScrollConfiguration.of(capturedContext);
    expect(scrollBehavior.runtimeType, MockScrollBehavior);
    expect(
      scrollBehavior.getScrollPhysics(capturedContext).runtimeType,
      NeverScrollableScrollPhysics,
    );
  });

  testWidgets(
      'When `useInheritedMediaQuery` is true an existing MediaQuery is used if '
      'one is available', (final WidgetTester tester) async {
    late BuildContext capturedContext;
    final UniqueKey uniqueKey = UniqueKey();
    await tester.pumpWidget(
      MediaQuery(
        key: uniqueKey,
        data: const MediaQueryData(),
        child: ArnaApp(
          useInheritedMediaQuery: true,
          builder: (final BuildContext context, final Widget? child) {
            capturedContext = context;
            return const Placeholder();
          },
          color: const Color(0xFF123456),
        ),
      ),
    );
    expect(
      capturedContext.dependOnInheritedWidgetOfExactType<MediaQuery>()?.key,
      uniqueKey,
    );
  });
}

class MockScrollBehavior extends ScrollBehavior {
  const MockScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(final BuildContext context) =>
      const NeverScrollableScrollPhysics();
}

typedef SimpleRouterDelegateBuilder = Widget Function(
  BuildContext,
  RouteInformation,
);
typedef SimpleNavigatorRouterDelegatePopPage<T> = bool Function(
  Route<T> route,
  T result,
  SimpleNavigatorRouterDelegate delegate,
);

class SimpleRouteInformationParser
    extends RouteInformationParser<RouteInformation> {
  SimpleRouteInformationParser();

  @override
  Future<RouteInformation> parseRouteInformation(
    final RouteInformation information,
  ) {
    return SynchronousFuture<RouteInformation>(information);
  }

  @override
  RouteInformation restoreRouteInformation(
    final RouteInformation configuration,
  ) {
    return configuration;
  }
}

class SimpleNavigatorRouterDelegate extends RouterDelegate<RouteInformation>
    with PopNavigatorRouterDelegateMixin<RouteInformation>, ChangeNotifier {
  SimpleNavigatorRouterDelegate({
    required this.builder,
    required this.onPopPage,
  });

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  RouteInformation get routeInformation => _routeInformation;
  late RouteInformation _routeInformation;
  set routeInformation(final RouteInformation newValue) {
    _routeInformation = newValue;
    notifyListeners();
  }

  SimpleRouterDelegateBuilder builder;
  SimpleNavigatorRouterDelegatePopPage<void> onPopPage;

  @override
  Future<void> setNewRoutePath(final RouteInformation configuration) {
    _routeInformation = configuration;
    return SynchronousFuture<void>(null);
  }

  bool _handlePopPage(final Route<void> route, final void data) {
    return onPopPage(route, data, this);
  }

  @override
  Widget build(final BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: <Page<void>>[
        // We need at least two pages for the pop to propagate through.
        // Otherwise, the navigator will bubble the pop to the system navigator.
        const ArnaPage<void>(
          child: Text('base'),
        ),
        ArnaPage<void>(
          key: ValueKey<String>(routeInformation.location!),
          child: builder(context, routeInformation),
        ),
      ],
    );
  }
}
