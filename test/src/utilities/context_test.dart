import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const instance = 'example';
    Super.create<String>(instance);
    final string = context.read<String>();
    return Text(string);
  }
}

void main() {
  testWidgets('context.read() should retrieve an instance from the manager',
      (tester) async {
    await tester
        .pumpWidget(const SuperApp(child: MaterialApp(home: MyWidget())));

    expect(find.text('example'), findsOneWidget);
  });
}
