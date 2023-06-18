import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class TestModel with SuperModel {
  TestModel(this.id, this.name);
  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

void main() {
  group('SuperModel', () {
    test('props getter returns the correct list of properties', () {
      final testModel = TestModel(1, 'John Doe');

      expect(testModel.props, [1, 'John Doe']);
    });

    test('identical objects return true when compared', () {
      final testModel1 = TestModel(1, 'John Doe');
      final testModel2 = TestModel(1, 'John Doe');

      expect(testModel1 == testModel2, true);
    });

    test('non-identical objects return false when compared', () {
      final testModel1 = TestModel(1, 'John Doe');
      final testModel2 = TestModel(2, 'John Doe');

      expect(testModel1 == testModel2, false);
    });

    test('toString() returns the correct string representation', () {
      final testModel = TestModel(1, 'John Doe');

      expect(testModel.toString(), 'TestModel([1, John Doe])');
    });
  });
}
