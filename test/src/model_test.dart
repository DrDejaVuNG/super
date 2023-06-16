import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class TestModel extends SuperModel {
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

    test('toString() returns the correct string representation', () {
      final testModel = TestModel(1, 'John Doe');

      expect(testModel.toString(), 'TestModel([1, John Doe])');
    });
  });
}
