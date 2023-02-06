import 'package:arna/arna.dart';
import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:flutter/material.dart' show DefaultMaterialLocalizations;
import 'package:flutter/services.dart' show LogicalKeyboardKey, RawKeyDownEvent;

/// An application that uses Arna design.
///
/// It builds upon a [WidgetsApp] by Arna specific defaulting such as fonts and
/// scrolling physics.
///
/// The [ArnaApp] configures the top-level [Navigator] to search for routes in
/// the following order:
///
///  1. For the `/` route, the [home] property, if non-null, is used.
///
///  2. Otherwise, the [routes] table is used, if it has an entry for the
///     route.
///
///  3. Otherwise, [onGenerateRoute] is called, if provided. It should return a
///     non-null value for any _valid_ route not handled by [home] and
///     [routes].
///
///  4. Finally if all else fails [onUnknownRoute] is called.
///
/// If a [Navigator] is created, at least one of these options must handle the
/// `/` route, since it is used when an invalid [initialRoute] is specified on
/// startup (e.g. by another application launching this one with an intent on
/// Android; see [dart:ui.PlatformDispatcher.defaultRouteName]).
///
/// This widget also configures the observer of the top-level [Navigator] (if
/// any) to perform [Hero] animations.
///
/// {@tool snippet}
/// This example shows how to create an [ArnaApp] that disables the "debug"
/// banner with a [home] route that will be displayed when the app is launched.
///
/// ```dart
/// const ArnaApp(
///   home: ArnaScaffold(
///     headerBar: ArnaHeaderBar(
///       title: 'Home',
///     ),
///   ),
///   debugShowCheckedModeBanner: false,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// This example shows how to create an [ArnaApp] that uses the [routes] `Map`
/// to define the "home" route and an "about" route.
///
/// ```dart
/// ArnaApp(
///   routes: <String, WidgetBuilder>{
///     '/': (BuildContext context) {
///       return const ArnaScaffold(
///         headerBar: ArnaHeaderBar(
///           title: 'Home Route',
///         ),
///       );
///     },
///     '/about': (BuildContext context) {
///       return const ArnaScaffold(
///         headerBar: ArnaHeaderBar(
///           title: 'About Route',
///         ),
///       );
///     }
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// This example shows how to create an [ArnaApp] that defines a [theme] that
/// will be used for Arna widgets in the app.
///
/// ```dart
/// const ArnaApp(
///   theme: ArnaThemeData(
///     brightness: Brightness.dark,
///   ),
///   home: ArnaScaffold(
///     headerBar: ArnaHeaderBar(
///       title: 'ArnaApp Theme',
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///
///  * [ArnaScaffold], which provides standard app elements like an
///    [ArnaHeaderBar] and an [ArnaDrawer].
///  * [Navigator], which is used to manage the app's stack of pages.
///  * [ArnaPageRoute], which defines an app page that transitions in an
///    arna-specific way.
///  * [WidgetsApp], which defines the basic app elements but does not depend
///    on the arna library.
///  * The Flutter Internationalization Tutorial,
///    <https://flutter.dev/tutorials/internationalization/>.
class ArnaApp extends StatefulWidget {
  /// Creates an ArnaApp.
  ///
  /// At least one of [home], [routes], [onGenerateRoute], or [builder] must be
  /// non-null. If only [routes] is given, it must include an entry for the
  /// [Navigator.defaultRouteName] (`/`), since that is the route used when the
  /// application is launched with an intent that specifies an otherwise
  /// unsupported route.
  ///
  /// This class creates an instance of [WidgetsApp].
  ///
  /// The boolean arguments, [routes], and [navigatorObservers], must not be
  /// null.
  const ArnaApp({
    super.key,
    this.navigatorKey,
    this.home,
    this.theme,
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    List<NavigatorObserver> this.navigatorObservers =
        const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.useInheritedMediaQuery = false,
  })  : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        routerConfig = null;

  /// Creates an [ArnaApp] that uses the [Router] instead of a [Navigator].
  ///
  /// {@macro flutter.widgets.WidgetsApp.router}
  const ArnaApp.router({
    super.key,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.theme,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.useInheritedMediaQuery = false,
  })  : assert(routerDelegate != null || routerConfig != null),
        navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null;

  /// {@macro flutter.widgets.widgetsApp.navigatorKey}
  final GlobalKey<NavigatorState>? navigatorKey;

  /// {@macro flutter.widgets.widgetsApp.home}
  final Widget? home;

  /// The top-level [ArnaTheme] styling.
  final ArnaThemeData? theme;

  /// The application's top-level routing table.
  ///
  /// When a named route is pushed with [Navigator.pushNamed], the route name
  /// is looked up in this map. If the name is present, the associated
  /// [widgets.WidgetBuilder] is used to construct an [ArnaPageRoute] that
  /// performs an appropriate transition, including [Hero] animations, to the
  /// new route.
  ///
  /// {@macro flutter.widgets.widgetsApp.routes}
  final Map<String, WidgetBuilder>? routes;

  /// {@macro flutter.widgets.widgetsApp.initialRoute}
  final String? initialRoute;

  /// {@macro flutter.widgets.widgetsApp.onGenerateRoute}
  final RouteFactory? onGenerateRoute;

  /// {@macro flutter.widgets.widgetsApp.onGenerateInitialRoutes}
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// {@macro flutter.widgets.widgetsApp.onUnknownRoute}
  final RouteFactory? onUnknownRoute;

  /// {@macro flutter.widgets.widgetsApp.navigatorObservers}
  final List<NavigatorObserver>? navigatorObservers;

  /// {@macro flutter.widgets.widgetsApp.routeInformationProvider}
  final RouteInformationProvider? routeInformationProvider;

  /// {@macro flutter.widgets.widgetsApp.routeInformationParser}
  final RouteInformationParser<Object>? routeInformationParser;

  /// {@macro flutter.widgets.widgetsApp.routerDelegate}
  final RouterDelegate<Object>? routerDelegate;

  /// {@macro flutter.widgets.widgetsApp.backButtonDispatcher}
  final BackButtonDispatcher? backButtonDispatcher;

  /// {@macro flutter.widgets.widgetsApp.routerConfig}
  final RouterConfig<Object>? routerConfig;

  /// {@macro flutter.widgets.widgetsApp.builder}
  ///
  /// Arna specific features such as [showArnaDialog] and [showArnaMenu], and
  /// widgets such as [ArnaTooltip], [ArnaPopupMenuButton], also require a
  /// [Navigator] to properly function.
  final TransitionBuilder? builder;

  /// {@macro flutter.widgets.widgetsApp.title}
  ///
  /// This value is passed unmodified to [WidgetsApp.title].
  final String title;

  /// {@macro flutter.widgets.widgetsApp.onGenerateTitle}
  ///
  /// This value is passed unmodified to [WidgetsApp.onGenerateTitle].
  final GenerateAppTitle? onGenerateTitle;

  /// {@macro flutter.widgets.widgetsApp.color}
  final Color? color;

  /// {@macro flutter.widgets.widgetsApp.locale}
  final Locale? locale;

  /// {@macro flutter.widgets.widgetsApp.localizationsDelegates}
  ///
  /// Internationalized apps that require translations for one of the locales
  /// listed in [GlobalMaterialLocalizations] should specify this parameter and
  /// list the [supportedLocales] that the application can handle.
  ///
  /// ```dart
  /// import 'package:flutter_localizations/flutter_localizations.dart';
  /// ArnaApp(
  ///   localizationsDelegates: <LocalizationsDelegate<Object>>[
  ///     // ... app-specific localization delegate(s) here
  ///     GlobalMaterialLocalizations.delegate,
  ///     GlobalWidgetsLocalizations.delegate,
  ///   ],
  ///   supportedLocales: <Locale>[
  ///     Locale('en', 'US'), // English
  ///     Locale('he', 'IL'), // Hebrew
  ///     // ... other locales the app supports
  ///   ],
  ///   // ...
  /// )
  /// ```
  ///
  /// ## Adding localizations for a new locale
  ///
  /// The information that follows applies to the unusual case of an app adding
  /// translations for a language not already supported by
  /// [GlobalMaterialLocalizations].
  ///
  /// Delegates that produce [WidgetsLocalizations] and [MaterialLocalizations]
  /// are included automatically. Apps can provide their own versions of these
  /// localizations by creating implementations of
  /// [LocalizationsDelegate<WidgetsLocalizations>] or
  /// [LocalizationsDelegate<MaterialLocalizations>] whose load methods return
  /// custom versions of [WidgetsLocalizations] or [MaterialLocalizations].
  ///
  /// For example: to add support to [MaterialLocalizations] for a locale it
  /// doesn't already support, say `const Locale('foo', 'BR')`, one first
  /// creates a subclass of [MaterialLocalizations] that provides the
  /// translations:
  ///
  /// ```dart
  /// class FooLocalizations extends MaterialLocalizations {
  ///   FooLocalizations();
  ///   @override
  ///   String get okButtonLabel => 'foo';
  ///   // ...
  ///   // lots of other getters and methods to override!
  /// }
  ///
  /// ```
  ///
  /// One must then create a [LocalizationsDelegate] subclass that can provide
  /// an instance of the [MaterialLocalizations] subclass. In this case, this is
  /// essentially just a method that constructs a `FooLocalizations` object. A
  /// [SynchronousFuture] is used here because no asynchronous work takes place
  /// upon "loading" the localizations object.
  ///
  /// ```dart
  /// // continuing from previous example...
  /// class FooLocalizationsDelegate
  ///     extends LocalizationsDelegate<MaterialLocalizations> {}
  ///   const FooLocalizationsDelegate();
  ///   @override
  ///   bool isSupported(Locale locale) {
  ///     return locale == const Locale('foo', 'BR');
  ///   }
  ///   @override
  ///   Future<FooLocalizations> load(Locale locale) {
  ///     assert(locale == const Locale('foo', 'BR'));
  ///     return SynchronousFuture<FooLocalizations>(FooLocalizations());
  ///   }
  ///   @override
  ///   bool shouldReload(FooLocalizationsDelegate old) => false;
  /// }
  /// ```
  ///
  /// Constructing an [ArnaApp] with a `FooLocalizationsDelegate` overrides the
  /// automatically included delegate for [MaterialLocalizations] because only
  /// the first delegate of each [LocalizationsDelegate.type] is used and the
  /// automatically included delegates are added to the end of the app's
  /// [localizationsDelegates] list.
  ///
  /// ```dart
  /// const ArnaApp(
  ///   localizationsDelegates: <LocalizationsDelegate<Object>>[
  ///     const FooLocalizationsDelegate(),
  ///   ],
  ///   // ...
  /// )
  /// ```
  /// See also:
  ///
  ///  * [supportedLocales], which must be specified along with
  ///    [localizationsDelegates].
  ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value which
  ///    provides material localizations for many languages.
  ///  * The Flutter Internationalization Tutorial,
  ///    <https://flutter.dev/tutorials/internationalization/>.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// {@macro flutter.widgets.widgetsApp.localeListResolutionCallback}
  ///
  /// This callback is passed along to the [WidgetsApp] built by this widget.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// {@macro flutter.widgets.LocaleResolutionCallback}
  ///
  /// This callback is passed along to the [WidgetsApp] built by this widget.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// {@macro flutter.widgets.widgetsApp.supportedLocales}
  ///
  /// It is passed along unmodified to the [WidgetsApp] built by this widget.
  ///
  /// See also:
  ///
  ///  * [localizationsDelegates], which must be specified for localized
  ///    applications.
  ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value which
  ///    provides material localizations for many languages.
  ///  * The Flutter Internationalization Tutorial,
  ///    <https://flutter.dev/tutorials/internationalization/>.
  final Iterable<Locale> supportedLocales;

  /// Turns on a performance overlay.
  ///
  /// See also:
  ///
  ///  * <https://flutter.dev/debugging/#performance-overlay>
  final bool showPerformanceOverlay;

  /// Turns on checkerboarding of raster cache images.
  final bool checkerboardRasterCacheImages;

  /// Turns on checkerboarding of layers rendered to offscreen bitmaps.
  final bool checkerboardOffscreenLayers;

  /// Turns on an overlay that shows the accessibility information reported by
  /// the framework.
  final bool showSemanticsDebugger;

  /// {@macro flutter.widgets.widgetsApp.debugShowCheckedModeBanner}
  final bool debugShowCheckedModeBanner;

  /// {@macro flutter.widgets.widgetsApp.shortcuts}
  /// {@tool snippet}
  /// This example shows how to add a single shortcut for
  /// [LogicalKeyboardKey.select] to the default shortcuts without needing to
  /// add your own [Shortcuts] widget.
  ///
  /// Alternatively, you could insert a [Shortcuts] widget with just the mapping
  /// you want to add between the [WidgetsApp] and its child and get the same
  /// effect.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return WidgetsApp(
  ///     shortcuts: <ShortcutActivator, Intent>{
  ///       ... WidgetsApp.defaultShortcuts,
  ///       const SingleActivator(LogicalKeyboardKey.select):
  ///           const ActivateIntent(),
  ///     },
  ///     color: const Color(0xFFFF0000),
  ///     builder: (BuildContext context, Widget? child) {
  ///       return const Placeholder();
  ///     },
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// {@macro flutter.widgets.widgetsApp.shortcuts.seeAlso}
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// {@macro flutter.widgets.widgetsApp.actions}
  /// {@tool snippet}
  /// This example shows how to add a single action handling an
  /// [ActivateAction] to the default actions without needing to add your own
  /// [Actions] widget.
  ///
  /// Alternatively, you could insert an [Actions] widget with just the mapping
  /// you want to add between the [WidgetsApp] and its child and get the same
  /// effect.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return WidgetsApp(
  ///     actions: <Type, Action<Intent>>{
  ///       ... WidgetsApp.defaultActions,
  ///       ActivateAction: CallbackAction<Intent>(
  ///         onInvoke: (Intent intent) {
  ///           // Do something here...
  ///           return null;
  ///         },
  ///       ),
  ///     },
  ///     color: const Color(0xFFFF0000),
  ///     builder: (BuildContext context, Widget? child) {
  ///       return const Placeholder();
  ///     },
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  /// {@macro flutter.widgets.widgetsApp.actions.seeAlso}
  final Map<Type, Action<Intent>>? actions;

  /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
  final String? restorationScopeId;

  /// {@macro flutter.widgets.scrollBehavior}
  ///
  /// When null, defaults to [ArnaScrollBehavior].
  ///
  /// See also:
  ///
  ///  * [ScrollConfiguration], which controls how [Scrollable] widgets behave
  ///    in a subtree.
  final ScrollBehavior? scrollBehavior;

  /// {@macro flutter.widgets.widgetsApp.useInheritedMediaQuery}
  final bool useInheritedMediaQuery;

  @override
  State<ArnaApp> createState() => _ArnaAppState();

  /// The [HeroController] used for Arna page transitions.
  ///
  /// Used by [ArnaApp].
  static HeroController createArnaHeroController() => HeroController();
}

/// Describes how [Scrollable] widgets behave for [ArnaApp]s.
///
/// {@macro flutter.widgets.scrollBehavior}
///
/// Setting an [ArnaScrollBehavior] will result in descendant [Scrollable]
/// widgets.
/// When executing on desktop platforms, an [ArnaScrollbar] is applied to the
/// child.
///
/// See also:
///
///  * [ScrollBehavior], the default scrolling behavior extended by this class.
class ArnaScrollBehavior extends ScrollBehavior {
  /// Creates an ArnaScrollBehavior that adds [ArnaScrollbar]s on desktop
  /// platforms.
  const ArnaScrollBehavior();

  @override
  Widget buildScrollbar(
    final BuildContext context,
    final Widget child,
    final ScrollableDetails details,
  ) {
    switch (axisDirectionToAxis(details.direction)) {
      case Axis.horizontal:
        return child;
      case Axis.vertical:
        switch (getPlatform(context)) {
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            return ArnaScrollbar(
              controller: details.controller,
              child: child,
            );
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.iOS:
            return child;
        }
    }
  }

  @override
  Widget buildOverscrollIndicator(
    final BuildContext context,
    final Widget child,
    final ScrollableDetails details,
  ) {
    return child;
  }
}

/// The [State] for an [ArnaApp].
class _ArnaAppState extends State<ArnaApp> {
  late HeroController _heroController;

  bool get _usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  @override
  void initState() {
    super.initState();
    _heroController = ArnaApp.createArnaHeroController();
  }

  // Combine the Localizations for Material with the ones contributed by the
  // localizationsDelegates parameter, if any.
  // Only the first delegate of a particular LocalizationsDelegate.type is
  // loaded so the localizationsDelegate parameter can be used to override
  // _MaterialLocalizationsDelegate.
  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return <LocalizationsDelegate<dynamic>>[
      if (widget.localizationsDelegates != null)
        ...widget.localizationsDelegates!,
      DefaultMaterialLocalizations.delegate,
      DefaultCupertinoLocalizations.delegate,
    ];
  }

  Widget _inspectorSelectButtonBuilder(
    final BuildContext context,
    final VoidCallback onPressed,
  ) {
    return ArnaButton(
      icon: Icons.search,
      onPressed: onPressed,
      buttonType: ButtonType.pill,
    );
  }

  ArnaThemeData _themeBuilder(final BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);

    if (widget.theme == null) {
      return platformBrightness == Brightness.dark
          ? ArnaThemeData.dark().copyWith(accentColor: widget.color)
          : ArnaThemeData.light().copyWith(accentColor: widget.color);
    }

    if (widget.theme!.brightness == null) {
      return platformBrightness == Brightness.dark
          ? ArnaThemeData.dark().copyWith(
              accentColor: widget.theme!.accentColor,
            )
          : ArnaThemeData.light().copyWith(
              accentColor: widget.theme!.accentColor,
            );
    }
    return widget.theme!;
  }

  Widget _arnaBuilder(final BuildContext context, final Widget? child) {
    final ArnaThemeData theme = _themeBuilder(context);
    final Color effectiveSelectionColor = theme.accentColor.withOpacity(0.42);
    final Color effectiveCursorColor = theme.accentColor;

    return DefaultSelectionStyle(
      selectionColor: effectiveSelectionColor,
      cursorColor: effectiveCursorColor,
      child: AnimatedArnaTheme(
        data: theme,
        child: widget.builder != null
            ? Builder(
                builder: (final BuildContext context) {
                  // Why are we surrounding a builder with a builder?
                  //
                  // The widget.builder may contain code that invokes
                  // ArnaTheme.of(), which should return the theme we selected
                  // above in AnimatedArbaTheme. However, if we invoke
                  // widget.builder() directly as the child of AnimatedArnaTheme
                  // then there is no Context separating them, and the
                  // widget.builder() will not find the theme. Therefore, we
                  // surround widget.builder with yet another builder so that a
                  // context separates them and ArnaTheme.of() correctly
                  // resolves to the theme we passed to AnimatedArnaTheme.
                  return widget.builder!(context, child);
                },
              )
            : child ?? const SizedBox.shrink(),
      ),
    );
  }

  WidgetsApp _buildWidgetApp(final BuildContext context) {
    final ArnaThemeData effectiveThemeData = ArnaTheme.of(context);
    final Color color = ArnaDynamicColor.resolve(
      widget.color ?? effectiveThemeData.accentColor,
      context,
    );

    if (_usesRouter) {
      return WidgetsApp.router(
        key: GlobalObjectKey(this),
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser,
        routerDelegate: widget.routerDelegate,
        routerConfig: widget.routerConfig,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: _arnaBuilder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        textStyle: effectiveThemeData.textTheme.body,
        color: color,
        locale: widget.locale,
        localizationsDelegates: _localizationsDelegates,
        localeResolutionCallback: widget.localeResolutionCallback,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        supportedLocales: widget.supportedLocales,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        inspectorSelectButtonBuilder: _inspectorSelectButtonBuilder,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
        useInheritedMediaQuery: widget.useInheritedMediaQuery,
      );
    }

    return WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      navigatorObservers: widget.navigatorObservers!,
      pageRouteBuilder: <T>(
        final RouteSettings settings,
        final WidgetBuilder builder,
      ) {
        return ArnaPageRoute<T>(settings: settings, builder: builder);
      },
      home: widget.home,
      routes: widget.routes!,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      builder: _arnaBuilder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      textStyle: effectiveThemeData.textTheme.body,
      color: color,
      locale: widget.locale,
      localizationsDelegates: _localizationsDelegates,
      localeResolutionCallback: widget.localeResolutionCallback,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      inspectorSelectButtonBuilder: _inspectorSelectButtonBuilder,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      useInheritedMediaQuery: widget.useInheritedMediaQuery,
    );
  }

  @override
  Widget build(final BuildContext context) {
    Widget result = _buildWidgetApp(context);
    result = Focus(
      canRequestFocus: false,
      onKey: (final FocusNode node, final RawKeyEvent event) {
        if (event is! RawKeyDownEvent ||
            event.logicalKey != LogicalKeyboardKey.escape) {
          return KeyEventResult.ignored;
        }
        return ArnaTooltip.dismissAllToolTips()
            ? KeyEventResult.handled
            : KeyEventResult.ignored;
      },
      child: result,
    );

    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const ArnaScrollBehavior(),
      child: HeroControllerScope(
        controller: _heroController,
        child: result,
      ),
    );
  }
}
