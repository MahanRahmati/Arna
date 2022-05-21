import 'dart:math' as math;

import 'package:arna/arna.dart';
import 'package:flutter/rendering.dart' show BoxParentData, BoxHitTestResult;

/// A single fixed-height row that typically contains some text as well as a leading or trailing icon.
/// List tiles are typically used in [ListView]s, or arranged in [Column]s.
///
/// See also:
///
///  * [ArnaCheckboxListTile], [ArnaRadioListTile], and [ArnaSwitchListTile], widgets that combine [ArnaListTile] with
///    other controls.
class ArnaListTile extends StatefulWidget {
  /// Creates a list tile.
  const ArnaListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.actionable = false,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
    this.enableFeedback = true,
  });

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list tile.
  final String title;

  /// Additional content displayed below the title.
  final String? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this list tile.
  final GestureLongPressCallback? onLongPress;

  /// Whether to show disable state or not.
  final bool actionable;

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

  void _handleEnter(dynamic event) {
    if (!_hover && mounted) {
      setState(() => _hover = true);
    }
  }

  void _handleExit(dynamic event) {
    if (_hover && mounted) {
      setState(() => _hover = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = ArnaDynamicColor.resolve(ArnaColors.cardColor, context);
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
              duration: Styles.basicDuration,
              curve: Styles.basicCurve,
              color: !_isEnabled
                  ? widget.actionable
                      ? ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context)
                      : ArnaColors.transparent
                  : _hover
                      ? ArnaDynamicColor.applyOverlay(cardColor)
                      : cardColor,
              padding: Styles.tilePadding,
              child: _ArnaListTile(
                leading: widget.leading,
                title: Text(
                  widget.title,
                  style: ArnaTheme.of(context).textTheme.body!.copyWith(
                        color: ArnaDynamicColor.resolve(
                          !_isEnabled && widget.actionable ? ArnaColors.disabledColor : ArnaColors.primaryTextColor,
                          context,
                        ),
                      ),
                ),
                subtitle: (widget.subtitle != null)
                    ? Text(
                        widget.subtitle!,
                        style: ArnaTheme.of(context).textTheme.subtitle!.copyWith(
                              color: ArnaDynamicColor.resolve(
                                !_isEnabled && widget.actionable
                                    ? ArnaColors.disabledColor
                                    : ArnaColors.secondaryTextColor,
                                context,
                              ),
                            ),
                      )
                    : null,
                trailing: widget.trailing,
                textDirection: Directionality.of(context),
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
class _ArnaListTile extends RenderObjectWidget with SlottedMultiChildRenderObjectWidgetMixin<_ArnaListTileSlot> {
  /// Creates an ArnaListTile.
  const _ArnaListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.textDirection,
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

  @override
  Iterable<_ArnaListTileSlot> get slots => _ArnaListTileSlot.values;

  @override
  Widget? childForSlot(_ArnaListTileSlot slot) {
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
  _RenderArnaListTile createRenderObject(BuildContext context) {
    return _RenderArnaListTile(textDirection: textDirection);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderArnaListTile renderObject) {
    renderObject.textDirection = textDirection;
  }
}

/// _RenderArnaListTile class.
class _RenderArnaListTile extends RenderBox with SlottedContainerRenderObjectMixin<_ArnaListTileSlot> {
  /// Renders an ArnaListTile.
  _RenderArnaListTile({
    required TextDirection textDirection,
  }) : _textDirection = textDirection;

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
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  final TextBaseline _titleBaselineType = TextBaseline.alphabetic;

  final TextBaseline _subtitleBaselineType = TextBaseline.alphabetic;

  final double _horizontalTitleGap = Styles.largePadding;

  final double _minVerticalPadding = Styles.padding;

  final double _minLeadingWidth = Styles.largePadding;

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth =
        leading != null ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) + _horizontalTitleGap : 0.0;
    return leadingWidth + math.max(_minWidth(title, height), _minWidth(subtitle, height)) + _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth =
        leading != null ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) + _horizontalTitleGap : 0.0;
    return leadingWidth + math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) + _maxWidth(trailing, height);
  }

  double get _defaultTileHeight {
    return subtitle != null ? Styles.listTileTwoLineHeight : Styles.listTileHeight;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return math.max(
      _defaultTileHeight,
      title!.getMinIntrinsicHeight(width) + (subtitle?.getMinIntrinsicHeight(width) ?? 0.0),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    final BoxParentData parentData = title!.parentData! as BoxParentData;
    return parentData.offset.dy + title!.getDistanceToActualBaseline(baseline)!;
  }

  static double? _boxBaseline(RenderBox box, TextBaseline baseline) {
    return box.getDistanceToBaseline(baseline);
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason: 'Layout requires baseline metrics, which are only available after a full layout.',
    ));
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

    const BoxConstraints maxIconHeightConstraint = BoxConstraints(maxHeight: Styles.listTileHeight);
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints = looseConstraints.enforce(maxIconHeightConstraint);

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

    final double titleStart = hasLeading ? math.max(_minLeadingWidth, leadingSize.width) + _horizontalTitleGap : 0.0;
    final double adjustedTrailingWidth = hasTrailing ? trailingSize.width + _horizontalTitleGap : 0.0;
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
      tileHeight = math.max(defaultTileHeight, titleSize.height + 2.0 * _minVerticalPadding);
      titleY = (tileHeight - titleSize.height) / 2.0;
    } else {
      titleY = titleBaseline! - _boxBaseline(title!, _titleBaselineType)!;
      subtitleY = subtitleBaseline! - _boxBaseline(subtitle!, _subtitleBaselineType)!;
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
      if (titleY < _minVerticalPadding || (subtitleY + subtitleSize.height + _minVerticalPadding) > tileHeight) {
        tileHeight = titleSize.height + subtitleSize.height + 2.0 * _minVerticalPadding;
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
      leadingY = math.min((tileHeight - leadingSize.height) / 2.0, Styles.base * 2);
      trailingY = (tileHeight - trailingSize.height) / 2.0;
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(tileWidth - leadingSize.width, leadingY));
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
            _positionBox(trailing!, Offset(tileWidth - trailingSize.width, trailingY));
          }
          break;
        }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
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
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
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
