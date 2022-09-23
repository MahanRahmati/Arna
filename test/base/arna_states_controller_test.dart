import 'package:arna/arna.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ArnaStatesController constructor', () {
    expect(ArnaStatesController().value, <ArnaState>{});
    expect(ArnaStatesController(<ArnaState>{}).value, <ArnaState>{});
    expect(
      ArnaStatesController(<ArnaState>{ArnaState.selected}).value,
      <ArnaState>{ArnaState.selected},
    );
  });

  test('ArnaStatesController update, listener', () {
    int count = 0;
    void valueChanged() {
      count += 1;
    }

    final ArnaStatesController controller = ArnaStatesController();
    controller.addListener(valueChanged);

    controller.update(ArnaState.selected, add: true);
    expect(controller.value, <ArnaState>{ArnaState.selected});
    expect(count, 1);
    controller.update(ArnaState.selected, add: true);
    expect(controller.value, <ArnaState>{ArnaState.selected});
    expect(count, 1);

    controller.update(ArnaState.hovered, add: false);
    expect(count, 1);
    expect(controller.value, <ArnaState>{ArnaState.selected});
    controller.update(ArnaState.selected, add: false);
    expect(count, 2);
    expect(controller.value, <ArnaState>{});

    controller.update(ArnaState.hovered, add: true);
    expect(controller.value, <ArnaState>{ArnaState.hovered});
    expect(count, 3);
    controller.update(ArnaState.hovered, add: true);
    expect(controller.value, <ArnaState>{ArnaState.hovered});
    expect(count, 3);
    controller.update(ArnaState.pressed, add: true);
    expect(controller.value, <ArnaState>{ArnaState.hovered, ArnaState.pressed});
    expect(count, 4);
    controller.update(ArnaState.selected, add: true);
    expect(
      controller.value,
      <ArnaState>{ArnaState.hovered, ArnaState.pressed, ArnaState.selected},
    );
    expect(count, 5);
    controller.update(ArnaState.selected, add: false);
    expect(controller.value, <ArnaState>{ArnaState.hovered, ArnaState.pressed});
    expect(count, 6);
    controller.update(ArnaState.selected, add: false);
    expect(controller.value, <ArnaState>{ArnaState.hovered, ArnaState.pressed});
    expect(count, 6);
    controller.update(ArnaState.pressed, add: false);
    expect(controller.value, <ArnaState>{ArnaState.hovered});
    expect(count, 7);
    controller.update(ArnaState.hovered, add: false);
    expect(controller.value, <ArnaState>{});
    expect(count, 8);

    controller.removeListener(valueChanged);
    controller.update(ArnaState.selected, add: true);
    expect(controller.value, <ArnaState>{ArnaState.selected});
    expect(count, 8);
  });

  test('ArnaStatesController const initial value', () {
    int count = 0;
    void valueChanged() {
      count += 1;
    }

    final ArnaStatesController controller = ArnaStatesController(
      const <ArnaState>{ArnaState.selected},
    );
    controller.addListener(valueChanged);

    controller.update(ArnaState.selected, add: true);
    expect(controller.value, <ArnaState>{ArnaState.selected});
    expect(count, 0);

    controller.update(ArnaState.selected, add: false);
    expect(controller.value, <ArnaState>{});
    expect(count, 1);
  });
}
