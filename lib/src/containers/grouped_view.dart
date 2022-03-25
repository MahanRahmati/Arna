import 'package:arna/arna.dart';

/// An Arna-styled grouped view.
class ArnaGroupedView extends StatelessWidget {
  /// Creates an array of children.
  const ArnaGroupedView({
    Key? key,
    this.title,
    required this.children,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  }) : super(key: key);

  /// The title of grouped view.
  final String? title;

  /// The children of grouped view.
  final List<Widget> children;

  /// The axis which the items are aligned.
  ///
  /// Defaults to [Axis.vertical].
  final Axis direction;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for a [Row] or the top for a [Column]) of the
  /// main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  ///
  /// After allocating space to children, there might be some remaining free
  /// space. This value controls whether to maximize or minimize the amount of
  /// free space, subject to the incoming layout constraints.
  ///
  /// If some children have a non-zero flex factors (and none have a fit of
  /// [FlexFit.loose]), they will expand to consume all the available space and
  /// there will be no remaining free space to maximize or minimize, making this
  /// value irrelevant to the final layout.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  ///
  /// For example, [CrossAxisAlignment.center], the default, centers the
  /// children in the cross axis (e.g., horizontally for a [Column]).
  final CrossAxisAlignment crossAxisAlignment;

  /// Determines the order to lay children out horizontally and how to interpret
  /// `start` and `end` in the horizontal direction.
  ///
  /// Defaults to the ambient [Directionality].
  ///
  /// If [textDirection] is [TextDirection.rtl], then the direction in which
  /// text flows starts from right to left. Otherwise, if [textDirection] is
  /// [TextDirection.ltr], then the direction in which text flows starts from
  /// left to right.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the order in which
  /// the children are positioned (left-to-right or right-to-left), and the
  /// meaning of the [mainAxisAlignment] property's [MainAxisAlignment.start] and
  /// [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and either the
  /// [mainAxisAlignment] is either [MainAxisAlignment.start] or
  /// [MainAxisAlignment.end], or there's more than one child, then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  ///
  /// If the [direction] is [Axis.vertical], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [textDirection] (or the ambient [Directionality]) must not be null.
  final TextDirection? textDirection;

  /// Determines the order to lay children out vertically and how to interpret
  /// `start` and `end` in the vertical direction.
  ///
  /// Defaults to [VerticalDirection.down].
  ///
  /// If the [direction] is [Axis.vertical], this controls which order children
  /// are painted in (down or up), the meaning of the [mainAxisAlignment]
  /// property's [MainAxisAlignment.start] and [MainAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.vertical], and either the [mainAxisAlignment]
  /// is either [MainAxisAlignment.start] or [MainAxisAlignment.end], or there's
  /// more than one child, then the [verticalDirection] must not be null.
  ///
  /// If the [direction] is [Axis.horizontal], this controls the meaning of the
  /// [crossAxisAlignment] property's [CrossAxisAlignment.start] and
  /// [CrossAxisAlignment.end] values.
  ///
  /// If the [direction] is [Axis.horizontal], and the [crossAxisAlignment] is
  /// either [CrossAxisAlignment.start] or [CrossAxisAlignment.end], then the
  /// [verticalDirection] must not be null.
  final VerticalDirection verticalDirection;

  /// If aligning items according to their baseline, which baseline to use.
  ///
  /// This must be set if using baseline alignment. There is no default because there is no
  /// way for the framework to know the correct baseline _a priori_.
  final TextBaseline? textBaseline;

  Widget _buildChild() {
    final List<Widget> items = <Widget>[];
    if (children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        items.add(children[i]);
        if (children.length - i != 1) {
          items.add(
            direction == Axis.vertical
                ? const ArnaHorizontalDivider()
                : const ArnaVerticalDivider(),
          );
        }
      }
    }
    return direction == Axis.vertical
        ? Column(
            children: items,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
          )
        : Row(
            children: items,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.listPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Styles.padding,
                Styles.padding,
                Styles.padding,
                Styles.largePadding,
              ),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      title!,
                      style: ArnaTheme.of(context).textTheme.titleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          AnimatedContainer(
            duration: Styles.basicDuration,
            curve: Styles.basicCurve,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: Styles.borderRadius,
              border: Border.all(
                color: ArnaDynamicColor.resolve(
                  ArnaColors.borderColor,
                  context,
                ),
              ),
              color: ArnaDynamicColor.resolve(ArnaColors.cardColor, context),
            ),
            child: ClipRRect(
              borderRadius: Styles.listBorderRadius,
              child: _buildChild(),
            ),
          ),
        ],
      ),
    );
  }
}
