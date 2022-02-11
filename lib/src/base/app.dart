import 'package:arna/arna.dart';

enum ArnaThemeMode { system, light, dark }

class ArnaApp extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final ArnaThemeData? theme;
  final ArnaThemeMode? themeMode;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final bool useInheritedMediaQuery;

  const ArnaApp({
    Key? key,
    this.navigatorKey,
    this.home,
    this.theme,
    this.themeMode = ArnaThemeMode.system,
    Map<String, WidgetBuilder> this.routes = const {},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    List<NavigatorObserver> this.navigatorObservers = const [],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const [Locale('en', 'US')],
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
        super(key: key);

  const ArnaApp.router({
    Key? key,
    this.routeInformationProvider,
    required RouteInformationParser<Object> this.routeInformationParser,
    required RouterDelegate<Object> this.routerDelegate,
    this.backButtonDispatcher,
    this.theme,
    this.themeMode = ArnaThemeMode.system,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const [Locale('en', 'US')],
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
  })  : navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null,
        super(key: key);

  @override
  _ArnaAppState createState() => _ArnaAppState();

  static HeroController createArnaHeroController() => HeroController();
}

class ArnaScrollBehavior extends ScrollBehavior {
  const ArnaScrollBehavior();

  @override
  Widget buildScrollbar(context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return ArnaScrollbar(controller: details.controller, child: child);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}

class _ArnaAppState extends State<ArnaApp> {
  late HeroController _heroController;

  bool get _usesRouter => widget.routerDelegate != null;

  @override
  void initState() {
    super.initState();
    _heroController = ArnaApp.createArnaHeroController();
  }

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
    if (widget.localizationsDelegates != null) {
      yield* widget.localizationsDelegates!;
    }
    yield DefaultMaterialLocalizations.delegate;
    yield DefaultCupertinoLocalizations.delegate;
  }

  Widget _inspectorSelectButtonBuilder(
    BuildContext context,
    VoidCallback onPressed,
  ) =>
      ArnaIconButton(icon: Icons.search, onPressed: onPressed);

  WidgetsApp _buildWidgetApp(BuildContext context) {
    final ArnaThemeData effectiveThemeData = ArnaTheme.of(context);
    final Color color = ArnaDynamicColor.resolve(
      widget.color ?? effectiveThemeData.primaryColor,
      context,
    );

    if (_usesRouter) {
      return WidgetsApp.router(
        key: GlobalObjectKey(this),
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser!,
        routerDelegate: widget.routerDelegate!,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: widget.builder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        textStyle: effectiveThemeData.textTheme.textStyle,
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
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          CupertinoPageRoute<T>(settings: settings, builder: builder),
      home: widget.home,
      routes: widget.routes!,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      builder: widget.builder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      textStyle: effectiveThemeData.textTheme.textStyle,
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
  Widget build(BuildContext context) {
    final ArnaThemeMode mode = widget.themeMode ?? ArnaThemeMode.system;
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);
    final bool useDarkTheme = mode == ArnaThemeMode.dark ||
        (mode == ArnaThemeMode.system && platformBrightness == Brightness.dark);

    ArnaThemeData theme = useDarkTheme
        ? const ArnaThemeData(brightness: Brightness.dark)
        : const ArnaThemeData(brightness: Brightness.light);

    return ScrollConfiguration(
      behavior: widget.scrollBehavior ?? const ArnaScrollBehavior(),
      child: ArnaTheme(
        data: widget.theme ?? theme,
        child: HeroControllerScope(
          controller: _heroController,
          child: Focus(
            canRequestFocus: false,
            onKey: (FocusNode node, RawKeyEvent event) {
              if (event is! RawKeyDownEvent ||
                  event.logicalKey != LogicalKeyboardKey.escape) {
                return KeyEventResult.ignored;
              }
              return Tooltip.dismissAllToolTips()
                  ? KeyEventResult.handled
                  : KeyEventResult.ignored;
            },
            child: _buildWidgetApp(context),
          ),
        ),
      ),
    );
  }
}
