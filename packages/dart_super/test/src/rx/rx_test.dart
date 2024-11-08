import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

void main() {
  group('RxMerge', () {
    test('should merge Rx objects', () {
      final rx1 = RxInt(10);
      final rx2 = RxString('Hello');

      final mergedRx = RxMerge<Object>([rx1, rx2]);

      expect('${mergedRx.children}', '[$rx1, $rx2]');

      var listenerCalled = false;

      mergedRx.addListener(() {
        listenerCalled = true;
      });

      rx1.state = 20;
      rx2.state = 'World';

      expect(listenerCalled, true);

      mergedRx.removeListener(() {
        listenerCalled = true;
      });

      expect('${mergedRx.children}', '[$rx1, $rx2]');
      expect(mergedRx.toString(), '${RxMerge<Object>([rx1, rx2])}');
    });
  });

  group('RxListener', () {
    test('should capture Rx objects', () {
      RxInt rx1() => RxInt(10);
      RxString rx2() => RxString('Hello');

      RxListener.listen();

      expect(RxListener.isListening, isTrue);

      final rxObjects = '[${rx1()}, ${rx2()}]';

      final capturedRx = RxListener.listenedRx<dynamic>();

      expect(RxListener.isListening, isFalse);

      expect('${capturedRx.children}', rxObjects);
    });

    test('should throw an error if no Rx objects are captured', () {
      expect(RxListener.getRxList, throwsA(isA<StateError>()));
    });
  });
}
