import 'package:arna/arna.dart';

/// A rounded square that represents a user.
///
/// Typically used with a user's profile image, or, in the absence of such an image, the user's initials. A given
/// user's initials should always be paired with the same background color, for consistency.
///
/// If [foregroundImage] fails then [backgroundImage] is used. If [backgroundImage] fails too, [backgroundColor] is
/// used.
///
/// The [onBackgroundImageError] parameter must be null if the [backgroundImage] is null.
/// The [onForegroundImageError] parameter must be null if the [foregroundImage] is null.
///
/// {@tool snippet}
///
/// If the avatar is to have an image, the image should be specified in the [backgroundImage] property:
///
/// ```dart
/// ArnaAvatar(
///   backgroundImage: NetworkImage(userAvatarUrl),
/// )
/// ```
/// {@end-tool}
///
/// The image will be cropped to have a rounded square shape.
///
/// {@tool snippet}
///
/// If the avatar is to just have the user's initials, they are typically provided using a [Text] widget as the [child]
/// and a [backgroundColor]:
///
/// ```dart
/// ArnaAvatar(
///   backgroundColor: ArnaColors.blue,
///   child: const Text('AH'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ArnaListTile], which can combine an icon (such as an [ArnaAvatar]) with some text for a fixed height list
///    entry.
class ArnaAvatar extends StatelessWidget {
  /// Creates a rounded square that represents a user.
  const ArnaAvatar({
    super.key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.size,
  });

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget. If the [ArnaAvatar] is to have an image, use [backgroundImage] instead.
  final Widget? child;

  /// The color with which to fill the rounded square. Changing the background color will cause the avatar to animate
  /// to the new color.
  final Color? backgroundColor;

  /// The default text color for text in the rounded square.
  final Color? foregroundColor;

  /// The background image of the rounded square. Changing the background image will cause the avatar to animate to the
  /// new image.
  ///
  /// Typically used as a fallback image for [foregroundImage].
  ///
  /// If the [ArnaAvatar] is to have the user's initials, use [child] instead.
  final ImageProvider? backgroundImage;

  /// The foreground image of the rounded square.
  ///
  /// Typically used as profile image. For fallback use [backgroundImage].
  final ImageProvider? foregroundImage;

  /// An optional error callback for errors emitted when loading [backgroundImage].
  final ImageErrorListener? onBackgroundImageError;

  /// An optional error callback for errors emitted when loading [foregroundImage].
  final ImageErrorListener? onForegroundImageError;

  /// The size of the avatar.
  final double? size;

  @override
  Widget build(final BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final TextStyle textStyle = ArnaTheme.of(context)
        .textTheme
        .subtitle!
        .copyWith(color: foregroundColor);
    Color? effectiveBackgroundColor = backgroundColor;
    if (effectiveBackgroundColor == null) {
      effectiveBackgroundColor = ArnaDynamicColor.onBackgroundColor(
        textStyle.color!,
      );
    } else if (foregroundColor == null) {
      effectiveBackgroundColor = ArnaDynamicColor.onBackgroundColor(
        backgroundColor!,
      );
    }

    return AnimatedContainer(
      height: size ?? Styles.avatarSize,
      width: size ?? Styles.avatarSize,
      duration: Styles.basicDuration,
      curve: Styles.basicCurve,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: Styles.borderRadius,
        color: effectiveBackgroundColor,
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                onError: onBackgroundImageError,
                fit: BoxFit.cover,
              )
            : null,
      ),
      foregroundDecoration: foregroundImage != null
          ? BoxDecoration(
              borderRadius: Styles.borderRadius,
              image: DecorationImage(
                image: foregroundImage!,
                onError: onForegroundImageError,
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: child == null
          ? null
          : Center(
              child: MediaQuery(
                // Need to ignore the ambient textScaleFactor here so that the text doesn't escape the avatar when the
                // textScaleFactor is large.
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: IconTheme.merge(
                  data: IconThemeData(color: textStyle.color),
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: child!,
                  ),
                ),
              ),
            ),
    );
  }
}
