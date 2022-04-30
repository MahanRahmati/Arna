import 'dart:async';
import 'dart:collection';

import 'package:arna/arna.dart';

/// Manages [ArnaSnackBar]s for descendant [ArnaScaffold]s.
///
/// This class provides APIs for showing snack bars at the bottom of the
/// screen.
///
/// To display one of these notifications, obtain the
/// [ArnaScaffoldMessengerState] for the current [BuildContext] via
/// [ArnaScaffoldMessenger.of] and use the
/// [ArnaScaffoldMessengerState.showSnackBar] function.
///
/// When the [ArnaScaffoldMessenger] has nested [ArnaScaffold] descendants, the
/// ArnaScaffoldMessenger will only present the notification to the root
/// ArnaScaffold of the subtree of ArnaScaffolds. In order to
/// show notifications for the inner, nested ArnaScaffolds, set a new scope by
/// instantiating a new ArnaScaffoldMessenger in between the levels of nesting.
///
/// See also:
///
///  * [ArnaSnackBar], which is a temporary notification typically shown near
///    the bottom of the app using the
///    [ArnaScaffoldMessengerState.showSnackBar] method.
///  * [debugCheckHasArnaScaffoldMessenger], which asserts that the given
///    context has a [ArnaScaffoldMessenger] ancestor.
class ArnaScaffoldMessenger extends StatefulWidget {
  /// Creates a widget that manages [ArnaSnackBar]s for [ArnaScaffold]
  /// descendants.
  const ArnaScaffoldMessenger({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// A less elegant but more expedient solution is to assign a [GlobalKey] to
  /// the [ArnaScaffoldMessenger], then use the `key.currentState` property to
  /// obtain the [ArnaScaffoldMessengerState] rather than using the
  /// [ArnaScaffoldMessenger.of] function. The [ArnaApp.scaffoldMessengerKey]
  /// refers to the root ArnaScaffoldMessenger that is provided by default.
  ///
  /// If there is no [ArnaScaffoldMessenger] in scope, then this will assert in
  /// debug mode, and throw an exception in release mode.
  ///
  /// See also:
  ///
  ///  * [maybeOf], which is a similar function but will return null instead of
  ///    throwing if there is no [ArnaScaffoldMessenger] ancestor.
  ///  * [debugCheckHasArnaScaffoldMessenger], which asserts that the given
  ///    context has a [ArnaScaffoldMessenger] ancestor.
  static ArnaScaffoldMessengerState of(BuildContext context) {
    assert(debugCheckHasArnaScaffoldMessenger(context));

    final _ArnaScaffoldMessengerScope scope = context
        .dependOnInheritedWidgetOfExactType<_ArnaScaffoldMessengerScope>()!;
    return scope._scaffoldMessengerState;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// Will return null if an [ArnaScaffoldMessenger] is not found in the given
  /// context.
  ///
  /// See also:
  ///
  ///  * [of], which is a similar function, except that it will throw an
  ///    exception if a [ArnaScaffoldMessenger] is not found in the given
  ///    context.
  static ArnaScaffoldMessengerState? maybeOf(BuildContext context) {
    final _ArnaScaffoldMessengerScope? scope = context
        .dependOnInheritedWidgetOfExactType<_ArnaScaffoldMessengerScope>();
    return scope?._scaffoldMessengerState;
  }

  @override
  ArnaScaffoldMessengerState createState() => ArnaScaffoldMessengerState();
}

/// State for an [ArnaScaffoldMessenger].
///
/// An [ArnaScaffoldMessengerState] object can be used to [showSnackBar] for
/// every registered [ArnaScaffold] that is a descendant of the associated
/// [ArnaScaffoldMessenger]. ArnaScaffolds will register to receive
/// [ArnaSnackBar]s from their closest ArnaScaffoldMessenger ancestor.
///
/// Typically obtained via [ArnaScaffoldMessenger.of].
class ArnaScaffoldMessengerState extends State<ArnaScaffoldMessenger>
    with TickerProviderStateMixin {
  final LinkedHashSet<ArnaScaffoldState> _scaffolds =
      LinkedHashSet<ArnaScaffoldState>();
  final Queue<
      ArnaScaffoldFeatureController<ArnaSnackBar,
          ArnaSnackBarClosedReason>> _snackBars = Queue<
      ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>>();
  AnimationController? _snackBarController;
  Timer? _snackBarTimer;
  bool? _accessibleNavigation;

  @override
  void didChangeDependencies() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    // If we transition from accessible navigation to non-accessible navigation
    // and there is a SnackBar that would have timed out that has already
    // completed its timer, dismiss that SnackBar. If the timer hasn't finished
    // yet, let it timeout as normal.
    if ((_accessibleNavigation ?? false) &&
        !mediaQuery.accessibleNavigation &&
        _snackBarTimer != null &&
        !_snackBarTimer!.isActive) {
      hideCurrentSnackBar(reason: ArnaSnackBarClosedReason.timeout);
    }
    _accessibleNavigation = mediaQuery.accessibleNavigation;
    super.didChangeDependencies();
  }

  /// Register scaffold.
  void _register(ArnaScaffoldState scaffold) {
    _scaffolds.add(scaffold);
    if (_isRoot(scaffold)) {
      if (_snackBars.isNotEmpty) scaffold._updateSnackBar();
    }
  }

  /// Unregister scaffold.
  void _unregister(ArnaScaffoldState scaffold) {
    final bool removed = _scaffolds.remove(scaffold);
    // ScaffoldStates should only be removed once.
    assert(removed);
  }

  /// Update scaffold.
  void _updateScaffolds() {
    for (final ArnaScaffoldState scaffold in _scaffolds) {
      if (_isRoot(scaffold)) {
        scaffold._updateSnackBar();
      }
    }
  }

  // Nested Scaffolds are handled by the ArnaScaffoldMessenger by only
  // presenting an ArnaSnackBar in the root ArnaScaffold of the nested set.
  /// Check whether this scaffold is root or not.
  bool _isRoot(ArnaScaffoldState scaffold) {
    final ArnaScaffoldState? parent =
        scaffold.context.findAncestorStateOfType<ArnaScaffoldState>();
    return parent == null || !_scaffolds.contains(parent);
  }

  // SNACKBAR API

  /// Shows  a [ArnaSnackBar] across all registered [ArnaScaffold]s.
  ///
  /// A scaffold can show at most one snack bar at a time. If this function is
  /// called while another snack bar is already visible, the given snack bar
  /// will be added to a queue and displayed after the earlier snack bars have
  /// closed.
  ///
  /// To remove the [ArnaSnackBar] with an exit animation, use
  /// [hideCurrentSnackBar] or call [ArnaScaffoldFeatureController.close]
  /// on the returned [ArnaScaffoldFeatureController]. To remove a
  /// [ArnaSnackBar] suddenly (without an animation), use
  /// [removeCurrentSnackBar].
  ///
  /// See [ArnaScaffoldMessenger.of] for information about how to obtain the
  /// [ArnaScaffoldMessengerState].
  ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>
      showSnackBar(ArnaSnackBar snackBar) {
    _snackBarController ??= ArnaSnackBar.createAnimationController(vsync: this)
      ..addStatusListener(_handleArnaSnackBarStatusChanged);
    if (_snackBars.isEmpty) {
      assert(_snackBarController!.isDismissed);
      _snackBarController!.forward();
    }
    late ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>
        controller;
    controller =
        ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>._(
      snackBar.withAnimation(_snackBarController!, fallbackKey: UniqueKey()),
      Completer<ArnaSnackBarClosedReason>(),
      () {
        assert(_snackBars.first == controller);
        hideCurrentSnackBar();
      },
      null, // SnackBar doesn't use a builder function so setState() wouldn't rebuild it
    );
    setState(() => _snackBars.addLast(controller));
    _updateScaffolds();
    return controller;
  }

  void _handleArnaSnackBarStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        assert(_snackBars.isNotEmpty);
        setState(() => _snackBars.removeFirst());
        _updateScaffolds();
        if (_snackBars.isNotEmpty) _snackBarController!.forward();
        break;
      case AnimationStatus.completed:
        setState(() {
          assert(_snackBarTimer == null);
          // build will create a new timer if necessary to dismiss the snackBar.
        });
        _updateScaffolds();
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.reverse:
        break;
    }
  }

  /// Removes the current [ArnaSnackBar] (if any) immediately from registered
  /// [ArnaScaffold]s.
  ///
  /// The removed snack bar does not run its normal exit animation. If there
  /// are any queued snack bars, they begin their entrance animation
  /// immediately.
  void removeCurrentSnackBar(
      {ArnaSnackBarClosedReason reason = ArnaSnackBarClosedReason.remove}) {
    if (_snackBars.isEmpty) return;
    final Completer<ArnaSnackBarClosedReason> completer =
        _snackBars.first._completer;
    if (!completer.isCompleted) completer.complete(reason);
    _snackBarTimer?.cancel();
    _snackBarTimer = null;
    // This will trigger the animation's status callback.
    _snackBarController!.value = 0.0;
  }

  /// Removes the current [ArnaSnackBar] by running its normal exit animation.
  ///
  /// The closed completer is called after the animation is complete.
  void hideCurrentSnackBar(
      {ArnaSnackBarClosedReason reason = ArnaSnackBarClosedReason.hide}) {
    if (_snackBars.isEmpty ||
        _snackBarController!.status == AnimationStatus.dismissed) return;
    final Completer<ArnaSnackBarClosedReason> completer =
        _snackBars.first._completer;
    if (_accessibleNavigation!) {
      _snackBarController!.value = 0.0;
      completer.complete(reason);
    } else {
      _snackBarController!.reverse().then<void>((void value) {
        assert(mounted);
        if (!completer.isCompleted) completer.complete(reason);
      });
    }
    _snackBarTimer?.cancel();
    _snackBarTimer = null;
  }

  /// Removes all the snackBars currently in queue by clearing the queue
  /// and running normal exit animation on the current snackBar.
  void clearSnackBars() {
    if (_snackBars.isEmpty ||
        _snackBarController!.status == AnimationStatus.dismissed) return;
    final ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>
        currentSnackbar = _snackBars.first;
    _snackBars.clear();
    _snackBars.add(currentSnackbar);
    hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _accessibleNavigation = mediaQuery.accessibleNavigation;

    if (_snackBars.isNotEmpty) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route == null || route.isCurrent) {
        if (_snackBarController!.isCompleted && _snackBarTimer == null) {
          final ArnaSnackBar snackBar = _snackBars.first._widget;
          _snackBarTimer = Timer(Styles.snackbarDuration, () {
            assert(
              _snackBarController!.status == AnimationStatus.forward ||
                  _snackBarController!.status == AnimationStatus.completed,
            );
            // Look up MediaQuery again in case the setting changed.
            final MediaQueryData mediaQuery = MediaQuery.of(context);
            if (mediaQuery.accessibleNavigation && snackBar.action != null) {
              return;
            }
            hideCurrentSnackBar(reason: ArnaSnackBarClosedReason.timeout);
          });
        }
      }
    }

    return _ArnaScaffoldMessengerScope(
      scaffoldMessengerState: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _snackBarController?.dispose();
    _snackBarTimer?.cancel();
    _snackBarTimer = null;
    super.dispose();
  }
}

class _ArnaScaffoldMessengerScope extends InheritedWidget {
  const _ArnaScaffoldMessengerScope({
    Key? key,
    required Widget child,
    required ArnaScaffoldMessengerState scaffoldMessengerState,
  })  : _scaffoldMessengerState = scaffoldMessengerState,
        super(key: key, child: child);

  final ArnaScaffoldMessengerState _scaffoldMessengerState;

  @override
  bool updateShouldNotify(_ArnaScaffoldMessengerScope old) =>
      _scaffoldMessengerState != old._scaffoldMessengerState;
}

/// Implements the basic layout structure.
///
/// This class provides APIs for showing drawers and bottom sheets.
///
/// To display a persistent bottom sheet, obtain the
/// [ArnaScaffoldState] for the current [BuildContext] via [ArnaScaffold.of]
/// and use the [ArnaScaffoldState.showBottomSheet] function.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
///  * [ArnaScaffoldState], which is the state associated with this widget.
class ArnaScaffold extends StatefulWidget {
  /// Creates a basic layout structure in the Arna style.
  const ArnaScaffold({
    Key? key,
    this.headerBarLeading,
    this.title,
    this.actions,
    this.searchField,
    required this.body,
    this.isDialog = false,
  }) : super(key: key);

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common
  /// operations. For less common operations, consider using a
  /// [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar]
  /// built by this widget. The height of each action is constrained to be no
  /// bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The [ArnaSearchField] of the scaffold.
  final ArnaSearchField? searchField;

  /// The body widget of the scaffold.
  /// The primary content of the scaffold.
  ///
  /// Displayed below the [ArnaHeaderBar], above the bottom of the ambient
  /// [MediaQuery]'s [MediaQueryData.viewInsets].
  ///
  /// The widget in the body of the scaffold is positioned at the top-left of
  /// the available space between the headerbar and the bottom of the scaffold.
  /// To center this widget instead, consider putting it in a [Center] widget
  /// and having that be the body. To expand this widget instead, consider
  /// putting it in a [SizedBox.expand].
  ///
  /// If you have a column of widgets that should normally fit on the screen,
  /// but may overflow and would in such cases need to scroll, consider using a
  /// [ListView] as the body of the scaffold. This is also a good choice for
  /// the case where your body is a scrollable list.
  final Widget body;

  /// Whether the scaffold is inside dialog or not.
  final bool isDialog;

  /// Finds the [ArnaScaffoldState] from the closest instance of this class
  /// that encloses the given context.
  ///
  /// If no instance of this class encloses the given context, will cause an
  /// assert in debug mode, and throw an exception in release mode.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// A more efficient solution is to split your build function into several
  /// widgets. This introduces a new context from which you can obtain the
  /// [ArnaScaffold]. In this solution, you would have an outer widget that
  /// creates the [ArnaScaffold] populated by instances of your new inner
  /// widgets, and then in these inner widgets you would use [ArnaScaffold.of].
  ///
  /// A less elegant but more expedient solution is assign a [GlobalKey] to the
  /// [ArnaScaffold], then use the `key.currentState` property to obtain the
  /// [ArnaScaffoldState] rather than using the [ArnaScaffold.of] function.
  ///
  /// If there is no [ArnaScaffold] in scope, then this will throw an
  /// exception. To return null if there is no [ArnaScaffold], use [maybeOf]
  /// instead.
  static ArnaScaffoldState of(BuildContext context) {
    final ArnaScaffoldState? result =
        context.findAncestorStateOfType<ArnaScaffoldState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ArnaScaffold.of() called with a context that does not contain a ArnaScaffold.',
      ),
      ErrorDescription(
        'No ArnaScaffold ancestor could be found starting from the context that was passed to ArnaScaffold.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the ArnaScaffold widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the ArnaScaffold. For an example of this, please see the '
        'documentation for ArnaScaffold.of(). ',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the ArnaScaffold. In this solution, '
        'you would have an outer widget that creates the ArnaScaffold populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use ArnaScaffold.of().\n'
        'A less elegant but more expedient solution is assign a GlobalKey to the ArnaScaffold, '
        'then use the key.currentState property to obtain the ArnaScaffoldState rather than '
        'using the ArnaScaffold.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [ArnaScaffoldState] from the closest instance of this class
  /// that encloses the given context.
  ///
  /// If no instance of this class encloses the given context, will return
  /// null. To throw an exception instead, use [of] instead of this function.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [of], a similar function to this one that throws if no instance
  ///    encloses the given context. Also includes some sample code in its
  ///    documentation.
  static ArnaScaffoldState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ArnaScaffoldState>();
  }

  @override
  State<ArnaScaffold> createState() => ArnaScaffoldState();
}

/// The [State] for a [ArnaScaffold].
class ArnaScaffoldState extends State<ArnaScaffold>
    with TickerProviderStateMixin {
  // Used for the snackbar API.
  ArnaScaffoldMessengerState? _scaffoldMessenger;

  // SNACKBAR API
  ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>?
      _messengerSnackBar;

  // This is used to update the _messengerSnackBar by the
  // ArnaScaffoldMessenger.
  void _updateSnackBar() {
    final ArnaScaffoldFeatureController<ArnaSnackBar, ArnaSnackBarClosedReason>?
        messengerSnackBar = _scaffoldMessenger!._snackBars.isNotEmpty
            ? _scaffoldMessenger!._snackBars.first
            : null;

    if (_messengerSnackBar != messengerSnackBar) {
      setState(() => _messengerSnackBar = messengerSnackBar);
    }
  }

  @override
  void didChangeDependencies() {
    // Using maybeOf is valid here since both the ArnaScaffold and
    // ArnaScaffoldMessenger are currently available for managing SnackBars.
    final ArnaScaffoldMessengerState? currentScaffoldMessenger =
        ArnaScaffoldMessenger.maybeOf(context);
    // If our ArnaScaffoldMessenger has changed, unregister with the old one
    // first.
    if (_scaffoldMessenger != null &&
        (currentScaffoldMessenger == null ||
            _scaffoldMessenger != currentScaffoldMessenger)) {
      _scaffoldMessenger?._unregister(this);
    }
    // Register with the current ScaffoldMessenger, if there is one.
    _scaffoldMessenger = currentScaffoldMessenger;
    _scaffoldMessenger?._register(this);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scaffoldMessenger?._unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MediaQueryData metrics = MediaQuery.of(context);
        return MediaQuery(
          data: metrics.copyWith(
            padding: metrics.padding.copyWith(
              top: widget.isDialog ? 0 : metrics.padding.top,
              bottom: widget.isDialog ? 0 : metrics.padding.bottom,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ArnaDynamicColor.resolve(
                ArnaColors.backgroundColor,
                context,
              ),
            ),
            child: Column(
              children: <Widget>[
                ArnaHeaderBar(
                  leading: widget.headerBarLeading,
                  middle: widget.title != null
                      ? Text(
                          widget.title!,
                          style: ArnaTheme.of(context).textTheme.title,
                        )
                      : null,
                  actions: widget.actions,
                ),
                if (widget.searchField != null) widget.searchField!,
                Flexible(child: widget.body),
                if (_messengerSnackBar != null) _messengerSnackBar!._widget,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// An interface for controlling a feature of a [ArnaScaffold].
///
/// Commonly obtained from [ArnaScaffoldMessengerState.showSnackBar].
class ArnaScaffoldFeatureController<T extends Widget, U> {
  /// Creates an interface for controlling a feature of a [ArnaScaffold].
  const ArnaScaffoldFeatureController._(
    this._widget,
    this._completer,
    this.close,
    this.setState,
  );
  final T _widget;
  final Completer<U> _completer;

  /// Completes when the feature controlled by this object is no longer visible.
  Future<U> get closed => _completer.future;

  /// Remove the feature from the scaffold.
  final VoidCallback close;

  /// Mark the feature as needing to rebuild.
  final StateSetter? setState;
}

/// Asserts that the given context has a [ArnaScaffoldMessenger] ancestor.
///
/// Used by various widgets to make sure that they are only used in an
/// appropriate context.
///
/// To invoke this function, use the following pattern, typically in the
/// relevant Widget's build method:
///
/// ```dart
/// assert(debugCheckHasArnaScaffoldMessenger(context));
/// ```
///
/// This method can be expensive (it walks the element tree).
///
/// Does nothing if asserts are disabled. Always returns true.
bool debugCheckHasArnaScaffoldMessenger(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<ArnaScaffoldMessenger>() ==
        null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No ScaffoldMessenger widget found.'),
        ErrorDescription(
            '${context.widget.runtimeType} widgets require a ScaffoldMessenger widget ancestor.'),
        ...context.describeMissingAncestor(
            expectedAncestorType: ArnaScaffoldMessenger),
        ErrorHint(
          'Typically, the ScaffoldMessenger widget is introduced by the ArnaApp '
          'at the top of your application widget tree.',
        ),
      ]);
    }
    return true;
  }());
  return true;
}
