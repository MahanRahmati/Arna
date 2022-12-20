import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/rendering.dart' show CustomSemanticsAction;

/// A list whose items the user can interactively reorder by dragging.
///
/// All list items must have a key.
class ArnaReorderableList extends StatefulWidget {
  /// Creates a reorderable list from a pre-built list of widgets.
  ///
  /// This constructor is appropriate for lists with a small number of children because constructing the [List]
  /// requires doing work for every child that could possibly be displayed in the list view instead of just those
  /// children that are actually visible.
  ///
  /// See also:
  ///
  ///   * [ArnaReorderableList.builder], which allows you to build a reorderable list where the items are built as
  ///     needed when scrolling the list.
  ArnaReorderableList({
    super.key,
    required final List<Widget> children,
    required this.onReorder,
    this.onReorderStart,
    this.onReorderEnd,
    this.itemExtent,
    this.prototypeItem,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.showBackground = false,
  })  : assert(
          itemExtent == null || prototypeItem == null,
          'You can only pass itemExtent or prototypeItem, not both',
        ),
        assert(
          children.every((final Widget w) => w.key != null),
          'All children of this widget must have a key.',
        ),
        itemBuilder =
            ((final BuildContext context, final int index) => children[index]),
        itemCount = children.length;

  /// Creates a reorderable list from widget items that are created on demand.
  ///
  /// This constructor is appropriate for list views with a large number of children because the builder is called only
  /// for those children that are actually visible.
  ///
  /// The [itemBuilder] callback will be called only with indices greater than or equal to zero and less than
  /// [itemCount].
  ///
  /// The [itemBuilder] should always return a non-null widget, and actually create the widget instances when called.
  /// Avoid using a builder that returns a previously-constructed widget; if the list view's children are created in
  /// advance, or all at once when the [ArnaReorderableList] itself is created, it is more efficient to use the
  /// [ArnaReorderableList] constructor. Even more efficient, however, is to create the instances on demand using this
  /// constructor's [itemBuilder] callback.
  ///
  /// See also:
  ///
  ///   * [ArnaReorderableList], which allows you to build a reorderable list with all the items passed into the
  ///     constructor.
  const ArnaReorderableList.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.onReorder,
    this.onReorderStart,
    this.onReorderEnd,
    this.itemExtent,
    this.prototypeItem,
    this.proxyDecorator,
    this.buildDefaultDragHandles = true,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.anchor = 0.0,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.showBackground = false,
  })  : assert(itemCount >= 0),
        assert(
          itemExtent == null || prototypeItem == null,
          'You can only pass itemExtent or prototypeItem, not both',
        );

  /// {@macro flutter.widgets.reorderable_list.itemBuilder}
  final IndexedWidgetBuilder itemBuilder;

  /// {@macro flutter.widgets.reorderable_list.itemCount}
  final int itemCount;

  /// {@macro flutter.widgets.reorderable_list.onReorder}
  final ReorderCallback onReorder;

  /// {@macro flutter.widgets.reorderable_list.onReorderStart}
  final void Function(int index)? onReorderStart;

  /// {@macro flutter.widgets.reorderable_list.onReorderEnd}
  final void Function(int index)? onReorderEnd;

  /// {@macro flutter.widgets.reorderable_list.proxyDecorator}
  final ReorderItemProxyDecorator? proxyDecorator;

  /// If true: on desktop platforms, a drag handle is stacked over the center of each item's trailing edge; on mobile
  /// platforms, a long press anywhere on the item starts a drag.
  ///
  /// The default desktop drag handle is just an [Icons.drag_indicator_outlined] wrapped by a
  /// [ReorderableDragStartListener]. On mobile platforms, the entire item is wrapped with a
  /// [ReorderableDelayedDragStartListener].
  ///
  /// To change the appearance or the layout of the drag handles, make this parameter false and wrap each list item, or
  /// a widget within each list item, with [ReorderableDragStartListener] or [ReorderableDelayedDragStartListener], or
  /// a custom subclass of [ReorderableDragStartListener].
  final bool buildDefaultDragHandles;

  /// {@macro flutter.widgets.reorderable_list.padding}
  final EdgeInsets? padding;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// {@macro flutter.widgets.scroll_view.controller}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.scroll_view.primary}
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [scrollController] is null.
  final bool? primary;

  /// {@macro flutter.widgets.scroll_view.physics}
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.scroll_view.shrinkWrap}
  final bool shrinkWrap;

  /// {@macro flutter.widgets.scroll_view.anchor}
  final double anchor;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  final double? cacheExtent;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.scroll_view.keyboardDismissBehavior}
  ///
  /// The default is [ScrollViewKeyboardDismissBehavior.manual]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.list_view.itemExtent}
  final double? itemExtent;

  /// {@macro flutter.widgets.list_view.prototypeItem}
  final Widget? prototypeItem;

  /// Whether to show background or not.
  final bool showBackground;

  @override
  State<ArnaReorderableList> createState() => _ArnaReorderableListState();
}

class _ArnaReorderableListState extends State<ArnaReorderableList> {
  Widget _wrapWithSemantics(final Widget child, final int index) {
    void reorder(final int startIndex, final int endIndex) {
      if (startIndex != endIndex) {
        widget.onReorder(startIndex, endIndex);
      }
    }

    // First, determine which semantics actions apply.
    final Map<CustomSemanticsAction, VoidCallback> semanticsActions =
        <CustomSemanticsAction, VoidCallback>{};

    // Create the appropriate semantics actions.
    void moveToStart() => reorder(index, 0);
    void moveToEnd() => reorder(index, widget.itemCount);
    void moveBefore() => reorder(index, index - 1);
    // To move after, we go to index+2 because we are moving it to the space before index+2, which is after the space
    // at index+1.
    void moveAfter() => reorder(index, index + 2);

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    // If the item can move to before its current position in the list.
    if (index > 0) {
      semanticsActions[
              CustomSemanticsAction(label: localizations.reorderItemToStart)] =
          moveToStart;
      String reorderItemBefore = localizations.reorderItemUp;
      if (widget.scrollDirection == Axis.horizontal) {
        reorderItemBefore = Directionality.of(context) == TextDirection.ltr
            ? localizations.reorderItemLeft
            : localizations.reorderItemRight;
      }
      semanticsActions[CustomSemanticsAction(label: reorderItemBefore)] =
          moveBefore;
    }

    // If the item can move to after its current position in the list.
    if (index < widget.itemCount - 1) {
      String reorderItemAfter = localizations.reorderItemDown;
      if (widget.scrollDirection == Axis.horizontal) {
        reorderItemAfter = Directionality.of(context) == TextDirection.ltr
            ? localizations.reorderItemRight
            : localizations.reorderItemLeft;
      }
      semanticsActions[CustomSemanticsAction(label: reorderItemAfter)] =
          moveAfter;
      semanticsActions[
              CustomSemanticsAction(label: localizations.reorderItemToEnd)] =
          moveToEnd;
    }

    // We pass toWrap with a GlobalKey into the item so that when it gets dragged, the accessibility framework can
    // preserve the selected state of the dragging item.
    //
    // We also apply the relevant custom accessibility actions for moving the item up, down, to the start, and to the
    // end of the list.
    return MergeSemantics(
      child: Semantics(
        customSemanticsActions: semanticsActions,
        child: child,
      ),
    );
  }

  Widget _itemBuilder(final BuildContext context, final int index) {
    final Widget item = widget.itemBuilder(context, index);
    assert(
      () {
        if (item.key == null) {
          throw FlutterError(
            'Every item of ArnaReorderableList must have a key.',
          );
        }
        return true;
      }(),
    );

    final Widget itemWithSemantics = _wrapWithSemantics(item, index);
    final Key itemGlobalKey = _ArnaReorderableListChildGlobalKey(
      item.key!,
      this,
    );

    if (widget.buildDefaultDragHandles) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
          switch (widget.scrollDirection) {
            case Axis.horizontal:
              return Stack(
                key: itemGlobalKey,
                children: <Widget>[
                  itemWithSemantics,
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: 0,
                    end: 0,
                    bottom: Styles.padding,
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_indicator_outlined,
                          color: ArnaColors.iconColor.resolveFrom(context),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            case Axis.vertical:
              return Stack(
                key: itemGlobalKey,
                children: <Widget>[
                  itemWithSemantics,
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 0,
                    bottom: 0,
                    end: Styles.padding,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_indicator_outlined,
                          color: ArnaColors.iconColor.resolveFrom(context),
                        ),
                      ),
                    ),
                  ),
                ],
              );
          }

        case TargetPlatform.iOS:
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return ReorderableDelayedDragStartListener(
            key: itemGlobalKey,
            index: index,
            child: itemWithSemantics,
          );
      }
    }

    return KeyedSubtree(
      key: itemGlobalKey,
      child: itemWithSemantics,
    );
  }

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasOverlay(context));

    final Widget child = CustomScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.scrollController,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      anchor: widget.anchor,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: Clip.antiAlias,
      slivers: <Widget>[
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverReorderableList(
            itemBuilder: _itemBuilder,
            itemExtent: widget.itemExtent,
            prototypeItem: widget.prototypeItem,
            itemCount: widget.itemCount,
            onReorder: widget.onReorder,
            onReorderStart: widget.onReorderStart,
            onReorderEnd: widget.onReorderEnd,
            proxyDecorator: widget.proxyDecorator,
          ),
        ),
      ],
    );

    return widget.showBackground
        ? ArnaCard(
            child: ClipRRect(
              borderRadius: Styles.listBorderRadius,
              child: child,
            ),
          )
        : child;
  }
}

/// A global key that takes its identity from the object and uses a value of a particular type to identify itself.
///
/// The difference with GlobalObjectKey is that it uses [==] instead of [identical] of the objects used to generate
/// widgets.
@optionalTypeArgs
class _ArnaReorderableListChildGlobalKey extends GlobalObjectKey {
  const _ArnaReorderableListChildGlobalKey(
    this.subKey,
    this.state,
  ) : super(subKey);

  final Key subKey;
  final State state;

  @override
  bool operator ==(final Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _ArnaReorderableListChildGlobalKey &&
        other.subKey == subKey &&
        other.state == state;
  }

  @override
  int get hashCode => Object.hash(subKey, state);
}
