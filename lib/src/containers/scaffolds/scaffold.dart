import 'dart:math' as math;

import 'package:arna/arna.dart';

/// The [ArnaScaffold]'s slots.
enum _ArnaScaffoldSlot {
  /// The [ArnaScaffold]'s body.
  body,

  /// The [ArnaScaffold]'s headerBar.
  headerBar,

  /// The [ArnaScaffold]'s drawer.
  drawer,
}

/// The [ArnaScaffold]'s Layout
class _ArnaScaffoldLayout extends MultiChildLayoutDelegate {
  /// Creates an ArnaScaffoldLayout.
  _ArnaScaffoldLayout();

  @override
  void performLayout(Size size) {
    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    final BoxConstraints fullWidthConstraints = looseConstraints.tighten(
      width: size.width,
    );
    final double bottom = size.height;
    double contentTop = 0.0;
    double headerBarHeight = 0.0;

    if (hasChild(_ArnaScaffoldSlot.headerBar)) {
      headerBarHeight = layoutChild(
        _ArnaScaffoldSlot.headerBar,
        fullWidthConstraints,
      ).height;
      contentTop = headerBarHeight;
      positionChild(_ArnaScaffoldSlot.headerBar, Offset.zero);
    }

    if (hasChild(_ArnaScaffoldSlot.body)) {
      final double bodyMaxHeight = math.max(0.0, bottom - contentTop);
      final BoxConstraints bodyConstraints = BoxConstraints(
        maxWidth: fullWidthConstraints.maxWidth,
        maxHeight: bodyMaxHeight,
      );
      layoutChild(_ArnaScaffoldSlot.body, bodyConstraints);
      positionChild(_ArnaScaffoldSlot.body, Offset(0.0, contentTop));
    }

    if (hasChild(_ArnaScaffoldSlot.drawer)) {
      layoutChild(_ArnaScaffoldSlot.drawer, BoxConstraints.tight(size));
      positionChild(_ArnaScaffoldSlot.drawer, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(_ArnaScaffoldLayout oldDelegate) => false;
}

/// Implements the basic layout structure.
///
/// This class provides APIs for showing drawer.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaScaffold extends StatefulWidget {
  /// Creates a basic layout structure in the Arna style.
  const ArnaScaffold({
    super.key,
    this.headerBar,
    this.body,
    this.drawer,
    this.onDrawerChanged,
    this.resizeToAvoidBottomInset,
    this.restorationId,
  });

  /// A header bar to display at the top of the scaffold.
  final PreferredSizeWidget? headerBar;

  /// The primary content of the scaffold.
  ///
  /// Displayed below the [headerBar], above the bottom of the ambient
  /// [MediaQuery]'s [MediaQueryData.viewInsets], and behind the [drawer].
  /// If [resizeToAvoidBottomInset] is false then the body is not resized when
  /// the onscreen keyboard appears, i.e. it is not inset by
  /// `viewInsets.bottom`.
  ///
  /// The widget in the body of the scaffold is positioned at the top-left of
  /// the available space between the header bar and the bottom of the scaffold.
  /// To center this widget instead, consider putting it in a [Center] widget
  /// and having that be the body. To expand this widget instead, consider
  /// putting it in a [SizedBox.expand].
  final Widget? body;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from either left-to-right ([TextDirection.ltr]) or
  /// right-to-left ([TextDirection.rtl])
  ///
  /// Typically an [ArnaDrawer].
  ///
  /// To open the drawer, use the [ArnaScaffoldState.openDrawer] function.
  ///
  /// To close the drawer, use either [ArnaScaffoldState.closeDrawer],
  /// [Navigator.pop] or press the escape key on the keyboard.
  final ArnaDrawer? drawer;

  /// Optional callback that is called when the [ArnaScaffold.drawer] is opened
  /// or closed.
  final ArnaDrawerCallback? onDrawerChanged;

  /// If true the [body] should size itself to avoid the onscreen keyboard
  /// whose height is defined by the ambient [MediaQuery]'s
  /// [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool? resizeToAvoidBottomInset;

  /// Restoration ID to save and restore the state of the [ArnaScaffold].
  ///
  /// If it is non-null, the scaffold will persist and restore whether the
  /// [drawer] was open or closed.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// Finds the [ArnaScaffoldState] from the closest instance of this class that
  /// encloses the given context.
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
  /// If there is no [ArnaScaffold] in scope, then this will throw an exception.
  /// To return null if there is no [ArnaScaffold], use [maybeOf] instead.
  static ArnaScaffoldState of(BuildContext context) {
    final ArnaScaffoldState? result =
        context.findAncestorStateOfType<ArnaScaffoldState>();
    if (result != null) {
      return result;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ArnaScaffold.of() called with a context that does not contain an ArnaScaffold.',
      ),
      ErrorDescription(
        'No ArnaScaffold ancestor could be found starting from the context that was passed to ArnaScaffold.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the ArnaScaffold widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the ArnaScaffold. For an example of this, please see the '
        'documentation for ArnaScaffold.of().',
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

  /// Finds the [ArnaScaffoldState] from the closest instance of this class that
  /// encloses the given context.
  ///
  /// If no instance of this class encloses the given context, will return null.
  /// To throw an exception instead, use [of] instead of this function.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [of], a similar function to this one that throws if no instance
  ///    encloses the given context.
  static ArnaScaffoldState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ArnaScaffoldState>();
  }

  /// Whether the [ArnaScaffold] that most tightly encloses the given context
  /// has a drawer.
  ///
  /// If this is being used during a build (for example to decide whether to
  /// show an "open drawer" button), set the `registerForUpdates` argument to
  /// true. This will then set up an [InheritedWidget] relationship with the
  /// [ArnaScaffold] so that the client widget gets rebuilt whenever the
  /// [hasDrawer] value changes.
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  ///
  ///  * [ArnaScaffold.of], which provides access to the [ArnaScaffoldState]
  ///    object.
  static bool hasDrawer(
    BuildContext context, {
    bool registerForUpdates = true,
  }) {
    if (registerForUpdates) {
      final _ArnaScaffoldScope? scaffold =
          context.dependOnInheritedWidgetOfExactType<_ArnaScaffoldScope>();
      return scaffold?.hasDrawer ?? false;
    } else {
      final ArnaScaffoldState? scaffold =
          context.findAncestorStateOfType<ArnaScaffoldState>();
      return scaffold?.hasDrawer ?? false;
    }
  }

  @override
  ArnaScaffoldState createState() => ArnaScaffoldState();
}

/// State for an [ArnaScaffold].
///
/// Retrieve an [ArnaScaffoldState] from the current [BuildContext] using
/// [ArnaScaffold.of].
class ArnaScaffoldState extends State<ArnaScaffold> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_drawerOpened, 'drawer_open');
  }

  final GlobalKey<ArnaDrawerControllerState> _drawerKey =
      GlobalKey<ArnaDrawerControllerState>();

  final GlobalKey _bodyKey = GlobalKey();

  /// Whether this scaffold has a non-null [ArnaScaffold.headerBar].
  bool get hasHeaderBar => widget.headerBar != null;

  /// Whether this scaffold has a non-null [ArnaScaffold.drawer].
  bool get hasDrawer => widget.drawer != null;

  final RestorableBool _drawerOpened = RestorableBool(false);

  /// Whether the [ArnaScaffold.drawer] is opened.
  ///
  /// See also:
  ///
  ///  * [ArnaScaffoldState.openDrawer], which opens the [ArnaScaffold.drawer]
  ///    of an [ArnaScaffold].
  bool get isDrawerOpen => _drawerOpened.value;

  void _drawerOpenedCallback(bool isOpened) {
    if (_drawerOpened.value != isOpened && _drawerKey.currentState != null) {
      setState(() => _drawerOpened.value = isOpened);
      widget.onDrawerChanged?.call(isOpened);
    }
  }

  /// Opens the [ArnaDrawer] (if any).
  ///
  /// If the scaffold has a non-null [ArnaScaffold.drawer], this function will
  /// cause the drawer to begin its entrance animation.
  ///
  /// To close the drawer, use either [ArnaScaffoldState.closeDrawer] or
  /// [Navigator.pop].
  ///
  /// See [ArnaScaffold.of] for information about how to obtain the
  /// [ArnaScaffoldState].
  void openDrawer() => _drawerKey.currentState?.open();

  /// Closes [ArnaScaffold.drawer] if it is currently opened.
  ///
  /// See [ArnaScaffold.of] for information about how to obtain the
  /// [ArnaScaffoldState].
  void closeDrawer() {
    if (hasDrawer && isDrawerOpen) {
      _drawerKey.currentState!.close();
    }
  }

  bool get _resizeToAvoidBottomInset => widget.resizeToAvoidBottomInset ?? true;

  @override
  void dispose() {
    _drawerOpened.dispose();
    super.dispose();
  }

  void _addIfNonNull(
    List<LayoutId> children,
    Widget? child,
    Object childId, {
    required bool removeLeftPadding,
    required bool removeTopPadding,
    required bool removeRightPadding,
    required bool removeBottomPadding,
    bool removeBottomInset = false,
    bool maintainBottomViewPadding = false,
  }) {
    MediaQueryData data = MediaQuery.of(context).removePadding(
      removeLeft: removeLeftPadding,
      removeTop: removeTopPadding,
      removeRight: removeRightPadding,
      removeBottom: removeBottomPadding,
    );
    if (removeBottomInset) {
      data = data.removeViewInsets(removeBottom: true);
    }

    if (maintainBottomViewPadding && data.viewInsets.bottom != 0.0) {
      data = data.copyWith(
        padding: data.padding.copyWith(bottom: data.viewPadding.bottom),
      );
    }

    if (child != null) {
      children.add(
        LayoutId(
          id: childId,
          child: MediaQuery(data: data, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    final List<LayoutId> children = <LayoutId>[];
    _addIfNonNull(
      children,
      widget.body == null
          ? null
          : KeyedSubtree(key: _bodyKey, child: widget.body!),
      _ArnaScaffoldSlot.body,
      removeLeftPadding: false,
      removeTopPadding: widget.headerBar != null,
      removeRightPadding: false,
      removeBottomPadding: false,
      removeBottomInset: _resizeToAvoidBottomInset,
    );

    if (widget.headerBar != null) {
      _addIfNonNull(
        children,
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.headerBar!.preferredSize.height +
                MediaQuery.of(context).padding.top,
          ),
          child: widget.headerBar,
        ),
        _ArnaScaffoldSlot.headerBar,
        removeLeftPadding: false,
        removeTopPadding: false,
        removeRightPadding: false,
        removeBottomPadding: true,
      );
    }

    if (widget.drawer != null) {
      _addIfNonNull(
        children,
        ArnaDrawerController(
          key: _drawerKey,
          drawerCallback: _drawerOpenedCallback,
          isDrawerOpen: _drawerOpened.value,
          drawer: widget.drawer!,
        ),
        _ArnaScaffoldSlot.drawer,
        // remove the side padding from the side we're not touching
        removeLeftPadding: textDirection == TextDirection.rtl,
        removeTopPadding: false,
        removeRightPadding: textDirection == TextDirection.ltr,
        removeBottomPadding: false,
      );
    }

    return _ArnaScaffoldScope(
      hasDrawer: hasDrawer,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ArnaColors.backgroundColor.resolveFrom(context),
        ),
        child: CustomMultiChildLayout(
          delegate: _ArnaScaffoldLayout(),
          children: children,
        ),
      ),
    );
  }
}

/// The [ArnaScaffold]'s scope.
class _ArnaScaffoldScope extends InheritedWidget {
  /// Creates an ArnaScaffoldScope.
  const _ArnaScaffoldScope({
    required this.hasDrawer,
    required super.child,
  });

  /// Whether this scaffold has a non-null [ArnaScaffold.drawer].
  final bool hasDrawer;

  @override
  bool updateShouldNotify(_ArnaScaffoldScope oldWidget) {
    return hasDrawer != oldWidget.hasDrawer;
  }
}
