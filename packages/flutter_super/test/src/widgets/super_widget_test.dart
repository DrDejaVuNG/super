// ignore_for_file: invalid_override_of_non_virtual_member,
// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

MyViewModel get myViewModel => Super.init(MyViewModel());

class MyViewModel extends SuperViewModel {
  bool initContextCalled = false;
  bool disableCalled = false;
  bool onBuildCalled = false;
  BuildContext? buildContext1;
  BuildContext? buildContext2;
  final num = 0.rx;
  final notifier = CounterNotifier();

  @override
  void initContext(BuildContext? context) {
    super.initContext(context);
    initContextCalled = true;
  }

  @override
  void onEnable() {
    super.onEnable();
    try {
      buildContext1 = ctrlContext;
    } catch (e) {
      return;
    }
  }

  @override
  void onBuild() {
    onBuildCalled = !onBuildCalled;
  }

  @override
  void onAlive() {
    buildContext2 = ctrlContext;
  }

  @override
  void disable() {
    disableCalled = true;
    super.disable();
  }
}

class CounterNotifier extends RxNotifier<int> {
  @override
  int initial() {
    return 5;
  }
}

class MySuperWidget extends SuperWidget<MyViewModel> {
  const MySuperWidget({super.key});

  @override
  MyViewModel initViewModel() => myViewModel;
  @override
  Widget build(BuildContext context) {
    final count = context.watch(ref.num);
    return Text('Value: $count');
  }
}

class ASuperWidget extends SuperWidget<MyViewModel> {
  const ASuperWidget({super.key});

  @override
  MyViewModel initViewModel() => myViewModel;
  @override
  Widget build(BuildContext context) {
    final num = context.watch(ref.notifier);
    return Text('Value: $num');
  }
}

void main() {
  group('SuperWidget', () {
    testWidgets('Initializes the view model', (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      final ref = widget.ref;
      expect(ref, isNotNull);
      expect(ref.buildContext1, isNull);
      expect(ref.buildContext2, isNotNull);
      expect(ref.initContextCalled, isTrue);
    });

    testWidgets('Builds the widget and updates in response to watch method',
        (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Value: 0'), findsOneWidget);

      final ref = widget.ref;
      ref.num.state = 1;

      await tester.pump();

      expect(find.text('Value: 1'), findsOneWidget);

      await tester.pumpWidget(Container());

      expect(ref.num.hasListeners, isTrue);
      ref.num.state = 2; // remove watch listener
      expect(ref.num.hasListeners, isFalse);
    });

    testWidgets('calls onBuild() when build method is called',
        (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      final ref = widget.ref;

      expect(ref.onBuildCalled, true);

      ref.num.state = 1;

      await tester.pump();

      expect(ref.onBuildCalled, false); // Called again
    });

    testWidgets('Disposes the view model', (WidgetTester tester) async {
      const widget = ASuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      final ref = widget.ref;

      expect(find.byType(Text), findsOneWidget);

      expect(find.text('Value: 5'), findsOneWidget);

      expect(ref.disableCalled, isFalse);

      await tester.pumpWidget(Container());

      expect(ref.disableCalled, isTrue);

      expect(ref.notifier.hasListeners, isTrue);
      ref.notifier.state = 2; // remove watch listener
      expect(ref.notifier.hasListeners, isFalse);
    });
  });
}
