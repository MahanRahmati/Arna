import 'package:arna/arna.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ArnaStateProperty.resolveWith()', () {
    final ArnaStateProperty<ArnaState> value =
        ArnaStateProperty.resolveWith<ArnaState>(
      (final Set<ArnaState> states) => states.first,
    );
    expect(value.resolve(<ArnaState>{ArnaState.hovered}), ArnaState.hovered);
    expect(value.resolve(<ArnaState>{ArnaState.focused}), ArnaState.focused);
    expect(value.resolve(<ArnaState>{ArnaState.pressed}), ArnaState.pressed);
    expect(value.resolve(<ArnaState>{ArnaState.selected}), ArnaState.selected);
    expect(value.resolve(<ArnaState>{ArnaState.disabled}), ArnaState.disabled);
  });

  test('ArnaStatePropertyAll', () {
    const ArnaStatePropertyAll<int> value = ArnaStatePropertyAll<int>(123);
    expect(value.resolve(<ArnaState>{}), 123);
    expect(value.resolve(<ArnaState>{ArnaState.hovered}), 123);
    expect(value.resolve(<ArnaState>{ArnaState.focused}), 123);
    expect(value.resolve(<ArnaState>{ArnaState.pressed}), 123);
    expect(value.resolve(<ArnaState>{ArnaState.selected}), 123);
    expect(value.resolve(<ArnaState>{ArnaState.disabled}), 123);
  });

  test("Can interpolate between two ArnaStateProperty's", () {
    const ArnaStateProperty<TextStyle?> textStyle1 =
        ArnaStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14.0));
    const ArnaStateProperty<TextStyle?> textStyle2 =
        ArnaStatePropertyAll<TextStyle?>(TextStyle(fontSize: 20.0));

    // Using `0.0` interpolation value.
    TextStyle textStyle = ArnaStateProperty.lerp<TextStyle?>(
      textStyle1,
      textStyle2,
      0.0,
      TextStyle.lerp,
    )!
        .resolve(enabled)!;
    expect(textStyle.fontSize, 14.0);

    // Using `0.5` interpolation value.
    textStyle = ArnaStateProperty.lerp<TextStyle?>(
      textStyle1,
      textStyle2,
      0.5,
      TextStyle.lerp,
    )!
        .resolve(enabled)!;
    expect(textStyle.fontSize, 17.0);

    // Using `1.0` interpolation value.
    textStyle = ArnaStateProperty.lerp<TextStyle?>(
      textStyle1,
      textStyle2,
      1.0,
      TextStyle.lerp,
    )!
        .resolve(enabled)!;
    expect(textStyle.fontSize, 20.0);
  });
}

Set<ArnaState> enabled = <ArnaState>{};
