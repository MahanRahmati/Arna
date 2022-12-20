import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/rendering.dart' show BoxParentData, BoxHitTestResult;

/// A single fixed-height row that typically contains some text as well as a
/// leading or trailing icon.
///
/// List tiles are typically used in [ListView]s, or arranged in [Column]s.
///
/// The [title] and [subtitle] are all limited to one line so it is a
/// responsibility of the caller to take care of text wrapping.
///
/// The [trailing] widget is not constrained and is therefore a responsibility
/// of the caller to ensure reasonable size of the [trailing] widget.
///
/// The [padding] and [leadingToTitle] can be overwritten if necessary.
///
/// See also:
///
///  * [ArnaCheckboxListTile], [ArnaRadioListTile], and [ArnaSwitchListTile],
///    widgets that combine [ArnaListTile] with other controls.
class ArnaListTile extends StatefulWidget {
  /// Creates a list tile.
  ///
  /// The [title] parameter is required. It is used to convey the most important
  /// information of list tile.
  ///
  /// The [subtitle] parameter is used to display additional information. It is
  /// placed below the [title].
  ///
  /// The [leading] parameter is typically an [Icon] or an [Image] and it comes
  /// at the start of the tile.
  ///
  /// The [trailing] parameter is typically an [Icon], or an [ArnaButton].
  /// It is placed at the very end of the tile.
  ///
  /// The [onTap] parameter is used to provide an action that is called when the
  /// tile is tapped.
  ///
  /// The [onLongPress] parameter is used to provide an action that is called
  /// when the tile is long-pressed.
  ///
  /// The [padding] parameter sets the padding of the content inside the tile.
  ///
  /// The [leadingToTitle] specifies the horizontal space between [leading] and
  /// [title] widgets.
  const ArnaListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.leadingToTitle = Styles.largePadding,
    this.enabled = true,
    this.showBackground = true,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// A widget displayed at the start of the [ArnaListTile]. This is typically
  /// [Icon] or an [Image].
  final Widget? leading;

  /// A [title] is used to convey the central information.
  final String title;

  /// A [subtitle] is used to display additional information. It is located
  /// below [title].
  final String? subtitle;

  /// A widget displayed at the end of the [ArnaListTile]. This is usually an
  /// [Icon].
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// Padding of the content inside [ArnaListTile].
  final EdgeInsetsGeometry? padding;

  /// The horizontal space between [leading] widget and [title].
  final double leadingToTitle;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color and the
  /// [onTap] and [onLongPress] callbacks are inoperative.
  final bool enabled;

  /// Whether to show background or not.
  final bool showBackground;

  /// The cursor for a mouse pointer when it enters or is hovering over the list tile.
  final MouseCursor cursor;

  /// The semantic label of the list tile.
  final String? semanticLabel;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a long-press will produce a short vibration, when feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [ArnaFeedback] for providing platform-specific feedback to certain actions.
  final bool enableFeedback;

  @override
  State<ArnaListTile> createState() => _ArnaListTileState();
}

/// The [State] for an [ArnaListTile].
class _ArnaListTileState extends State<ArnaListTile> {
  bool _hover = false;
  bool get _isEnabled => widget.onTap != null || widget.onLongPress != null;

  void _handleTap() {
    if (_isEnabled && widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleLongPress() {
    if (_isEnabled && widget.onLongPress != null) {
      widget.onLongPress!();
    }
  }

  void _handleEnter(final dynamic event) {
    if (!_hover && widget.showBackground && mounted) {
      setState(() => _hover = true);
    }
  }

  void _handleExit(final dynamic event) {
    if (_hover && widget.showBackground && mounted) {
      setState(() => _hover = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final Color cardColor = ArnaColors.cardColor.resolveFrom(context);

    final Widget title = Text(
      widget.title,
      maxLines: 1,
      style: ArnaTheme.of(context).textTheme.body!.copyWith(
            color: widget.showBackground
                ? !_isEnabled && widget.enabled
                    ? ArnaColors.disabledColor.resolveFrom(context)
                    : ArnaColors.primaryTextColor.resolveFrom(context)
                : ArnaColors.primaryTextColor.resolveFrom(context),
          ),
    );

    final Widget? subtitle = (widget.subtitle != null)
        ? Text(
            widget.subtitle!,
            maxLines: 1,
            style: ArnaTheme.of(context).textTheme.subtitle!.copyWith(
                  color: widget.showBackground
                      ? !_isEnabled && widget.enabled
                          ? ArnaColors.disabledColor.resolveFrom(context)
                          : ArnaColors.secondaryTextColor.resolveFrom(context)
                      : ArnaColors.secondaryTextColor.resolveFrom(context),
                ),
          )
        : null;

    return MergeSemantics(
      child: Semantics(
        label: widget.semanticLabel,
        container: true,
        enabled: _isEnabled,
        child: MouseRegion(
          cursor: widget.cursor,
          onEnter: _handleEnter,
          onExit: _handleExit,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            child: AnimatedContainer(
              constraints: const BoxConstraints(
                minHeight: Styles.listTileHeight,
              ),
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              color: !_isEnabled && widget.showBackground
                  ? ArnaColors.transparent
                  : _hover
                      ? ArnaDynamicColor.applyOverlay(cardColor)
                      : cardColor,
              padding: widget.padding ?? Styles.listTilePadding,
              alignment: Alignment.center,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: !_isEnabled && widget.enabled
                      ? ArnaColors.disabledColor.resolveFrom(context)
                      : ArnaColors.iconColor.resolveFrom(context),
                ),
                child: _ArnaListTile(
                  leading: widget.leading,
                  title: title,
                  subtitle: subtitle,
                  trailing: widget.trailing,
                  textDirection: Directionality.of(context),
                  leadingToTitle: widget.leadingToTitle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Identifies the children of a _ListTileElement.
enum _ArnaListTileSlot {
  /// Leading.
  leading,

  /// Title.
  title,

  /// Subtitle.
  subtitle,

  /// Trailing.
  trailing,
}

/// _ArnaListTile class.
class _ArnaListTile extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_ArnaListTileSlot> {
  /// Creates an ArnaListTile.
  const _ArnaListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.textDirection,
    required this.leadingToTitle,
  });

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final Widget title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// A direction in which text flows.
  final TextDirection textDirection;

  /// The horizontal space between [leading] widget and [title].
  final double leadingToTitle;

  @override
  Iterable<_ArnaListTileSlot> get slots => _ArnaListTileSlot.values;

  @override
  Widget? childForSlot(final _ArnaListTileSlot slot) {
    switch (slot) {
      case _ArnaListTileSlot.leading:
        return leading;
      case _ArnaListTileSlot.title:
        return title;
      case _ArnaListTileSlot.subtitle:
        return subtitle;
      case _ArnaListTileSlot.trailing:
        return trailing;
    }
  }

  @override
  _RenderArnaListTile createRenderObject(final BuildContext context) {
    return _RenderArnaListTile(
      textDirection: textDirection,
      leadingToTitle: leadingToTitle,
    );
  }

  @override
  void updateRenderObject(
    final BuildContext context,
    final _RenderArnaListTile renderObject,
  ) {
    renderObject
      ..textDirection = textDirection
      ..leadingToTitle = leadingToTitle;
  }
}

/// _RenderArnaListTile class.
class _RenderArnaListTile extends RenderBox
    with SlottedContainerRenderObjectMixin<_ArnaListTileSlot> {
  /// Renders an ArnaListTile.
  _RenderArnaListTile({
    required final TextDirection textDirection,
    required final double leadingToTitle,
  })  : _textDirection = textDirection,
        _leadingToTitle = leadingToTitle;

  RenderBox? get leading => childForSlot(_ArnaListTileSlot.leading);
  RenderBox? get title => childForSlot(_ArnaListTileSlot.title);
  RenderBox? get subtitle => childForSlot(_ArnaListTileSlot.subtitle);
  RenderBox? get trailing => childForSlot(_ArnaListTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (title != null) title!,
      if (subtitle != null) subtitle!,
      if (trailing != null) trailing!,
    ];
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(final TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  double get leadingToTitle => _leadingToTitle;
  double _leadingToTitle;

  set leadingToTitle(final double value) {
    if (_leadingToTitle == value) {
      return;
    }
    _leadingToTitle = value;
    markNeedsLayout();
  }

  final TextBaseline _titleBaselineType = TextBaseline.alphabetic;

  final TextBaseline _subtitleBaselineType = TextBaseline.alphabetic;

  final double _minVerticalPadding = Styles.smallPadding;

  final double _minLeadingWidth = Styles.largePadding;

  @override
  bool get sizedByParent => false;

  static double _minWidth(final RenderBox? box, final double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(final RenderBox? box, final double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(final double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _leadingToTitle
        : 0.0;
    return leadingWidth +
        math.max(_minWidth(title, height), _minWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(final double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _leadingToTitle
        : 0.0;
    return leadingWidth +
        math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  double get _defaultTileHeight {
    return subtitle != null
        ? Styles.listTileTwoLineHeight
        : Styles.listTileHeight;
  }

  @override
  double computeMinIntrinsicHeight(final double width) {
    return math.max(
      _defaultTileHeight,
      title!.getMinIntrinsicHeight(width) +
          (subtitle?.getMinIntrinsicHeight(width) ?? 0.0),
    );
  }

  @override
  double computeMaxIntrinsicHeight(final double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(final TextBaseline baseline) {
    final BoxParentData parentData = title!.parentData! as BoxParentData;
    return parentData.offset.dy + title!.getDistanceToActualBaseline(baseline)!;
  }

  static double? _boxBaseline(
    final RenderBox box,
    final TextBaseline baseline,
  ) {
    return box.getDistanceToBaseline(baseline);
  }

  static Size _layoutBox(
    final RenderBox? box,
    final BoxConstraints constraints,
  ) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(final RenderBox box, final Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(final BoxConstraints constraints) {
    assert(
      debugCannotComputeDryLayout(
        reason:
            'Layout requires baseline metrics, which are only available after a full layout.',
      ),
    );
    return Size.zero;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasSubtitle = subtitle != null;
    final bool hasTrailing = trailing != null;
    final bool isTwoLine = hasSubtitle;
    final bool isOneLine = !hasSubtitle;

    const BoxConstraints maxIconHeightConstraint = BoxConstraints(
      maxHeight: Styles.listTileHeight,
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints = looseConstraints.enforce(
      maxIconHeightConstraint,
    );

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);
    assert(
      tileWidth != leadingSize.width || tileWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget',
    );
    assert(
      tileWidth != trailingSize.width || tileWidth == 0.0,
      'Trailing widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget',
    );

    final double titleStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) + _leadingToTitle
        : 0.0;
    final double adjustedTrailingWidth =
        hasTrailing ? trailingSize.width + _leadingToTitle : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );
    final Size titleSize = _layoutBox(title, textConstraints);
    final Size subtitleSize = _layoutBox(subtitle, textConstraints);

    double? titleBaseline;
    double? subtitleBaseline;
    if (isTwoLine) {
      titleBaseline = Styles.titleBaseline;
      subtitleBaseline = Styles.subtitleBaseline;
    } else {
      assert(isOneLine);
    }

    final double defaultTileHeight = _defaultTileHeight;

    double tileHeight;
    double titleY;
    double? subtitleY;
    if (!hasSubtitle) {
      tileHeight = math.max(
        defaultTileHeight,
        titleSize.height + 2.0 * _minVerticalPadding,
      );
      titleY = (tileHeight - titleSize.height) / 2.0;
    } else {
      titleY = titleBaseline! - _boxBaseline(title!, _titleBaselineType)!;
      subtitleY =
          subtitleBaseline! - _boxBaseline(subtitle!, _subtitleBaselineType)!;
      tileHeight = defaultTileHeight;

      // If the title and subtitle overlap, move the title upwards by half the overlap and the subtitle down by the
      // same amount, and adjust tileHeight so that both titles fit.
      final double titleOverlap = titleY + titleSize.height - subtitleY;
      if (titleOverlap > 0.0) {
        titleY -= titleOverlap / 2.0;
        subtitleY += titleOverlap / 2.0;
      }

      // If the title or subtitle overflow tileHeight then punt: title and subtitle are arranged in a column,
      // tileHeight = column height plus _minVerticalPadding on top and bottom.
      if (titleY < _minVerticalPadding ||
          (subtitleY + subtitleSize.height + _minVerticalPadding) >
              tileHeight) {
        tileHeight =
            titleSize.height + subtitleSize.height + 2.0 * _minVerticalPadding;
        titleY = _minVerticalPadding;
        subtitleY = titleSize.height + _minVerticalPadding;
      }
    }

    // This attempts to implement the redlines for the vertical position of the leading and trailing icons on the spec
    // page:
    // The interpretation for these redlines is as follows:
    //  - For large tiles (> 70dp), both leading and trailing controls should be a fixed distance from top (14dp).
    //  - For smaller tiles, trailing should always be centered. Leading can be centered or closer to the top. It
    //    should never be further than 14dp to the top.
    final double leadingY;
    final double trailingY;
    if (tileHeight > Styles.base * 10) {
      leadingY = Styles.base * 2;
      trailingY = Styles.base * 2;
    } else {
      leadingY =
          math.min((tileHeight - leadingSize.height) / 2.0, Styles.base * 2);
      trailingY = (tileHeight - trailingSize.height) / 2.0;
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading) {
            _positionBox(
              leading!,
              Offset(tileWidth - leadingSize.width, leadingY),
            );
          }
          _positionBox(title!, Offset(adjustedTrailingWidth, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(adjustedTrailingWidth, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(trailing!, Offset(0.0, trailingY));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(0.0, leadingY));
          }
          _positionBox(title!, Offset(titleStart, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(titleStart, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(
              trailing!,
              Offset(tileWidth - trailingSize.width, trailingY),
            );
          }
          break;
        }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(final PaintingContext context, final Offset offset) {
    void doPaint(final RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(final Offset position) => true;

  @override
  bool hitTestChildren(
    final BoxHitTestResult result, {
    required final Offset position,
  }) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (final BoxHitTestResult result, final Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
