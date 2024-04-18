## Table of Contents

- [Features](#features)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Beginner Counter App](#beginner-counter-app)
  - [Professional Counter App](#professional-counter-app)
  - [Counter App Test](#counter-app-test)
  - [Counter App Breakdown](#counter-app-breakdown)
- [Super Framework APIs](#super-framework-apis)
  - [SuperApp](#superapp)
  - [SuperController](#supercontroller)
  - [SuperModel](#supermodel)
- [Widgets in the Super Framework](#widgets-in-the-super-framework)
  - [SuperWidget](#superwidget)
  - [SuperBuilder](#superbuilder)
  - [SuperConsumer](#superconsumer)
    - [Asynchronous State](#asynchronous-state)
  - [SuperListener](#superlistener)
  - [AsyncBuilder](#asyncbuilder)
- [Rx Types](#rx-types)
  - [RxT](#rxt)
    - [RxT SubTypes](#rxt-subtypes)
  - [RxNotifier](#rxnotifier)
    - [Asynchronous State](#asynchronous-state-1)
  - [Rx Collections](#rx-collections)
- [Dependency Injection](#dependency-injection)
  - [of](#of)
  - [init](#init)
  - [create](#create)
  - [delete](#delete)
  - [deleteAll](#deleteall)
- [Useful APIs](#useful-apis)
  - [context.read](#contextread)
  - [context.watch](#contextwatch)
- [Additional Information](#additional-information)
  - [Super Structure](#super-structure)
  - [API Reference](#api-reference)
- [Requirements](#requirements)
- [Maintainers](#maintainers)
- [Dev Note](#dev-note)
- [Credits](#credits)

---

## Getting Started

Add Super to your pubspec.yaml file:

```yaml
dependencies:
  flutter_super:
```

Import the Super package into your project:

```dart
import 'package:flutter_super/flutter_super.dart';
```

<br>

## Usage

### Beginner Counter App

![](https://raw.githubusercontent.com/DrDejaVuNG/images/main/images/flutter_super/counter_app_novice.png)

<br>

### Professional Counter App

![](https://raw.githubusercontent.com/DrDejaVuNG/images/main/images/flutter_super/counter_app.png)

<br>

### Counter App Test

![](https://github.com/DrDejaVuNG/images/blob/main/images/flutter_super/counter_app_test.png?raw=true)

<br>

Lets break down the Counter App Example.

### Counter App Breakdown

The `main.dart` file serves as the entry point for the application. It sets up the necessary framework for the project by wrapping the root widget with `SuperApp`, which enables the  `Super` framework.

```dart
void main() {
  runApp(
    // Adding SuperApp enables the framework for the project
    const SuperApp(child: MyApp()), // Step 1
  );
}
```

`MyApp` is the root widget of the application. It is a stateless widget that returns a `MaterialApp` as its child. The `MaterialApp` sets the home view of the application to be `HomeView`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}
```

`CountNotifier` is an `RxNotifier` class. It manages the state and logic for the counter functionality in the application.<br>
After the `CountNotifier` is defined, we define a getter to inject the dependency so that it can be accessed globally and be mocked easily during testing.

```dart
// Inject Dependency for global access (It can easily be mocked later).
CountNotifier get countNotifier => Super.init(CountNotifier());

// The notifier class manages the state in the application.
class CountNotifier extends RxNotifier<int> {
  // Step 2
  @override
  int initial() {
    return 0;
  }

  void increment() => state++; // Step 3
}
```

`HomeView` is a widget that displays the count and provides an increment button. It extends `StatelessWidget` to define the `view` and provides the build method to create the widget.

```dart
class HomeView extends StatelessWidget {
  // Step 4
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // SuperBuilder listens and rebuilds only when the state changes.
    return Scaffold(
      body: Center(
        child: SuperBuilder(
          builder: (context) {
            return Text(
              '${countNotifier.state}',
              style: Theme.of(context).textTheme.displayLarge,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the count state by calling the increment() method
        onPressed: countNotifier.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

By separating the logic into the `CountNotifier` class and the UI into the `HomeView`, the application achieves a clear separation of concerns between the business logic layer and the presentation layer. The `HomeView` widget is responsible for rendering the UI based on the state provided by the `CountNotifier`, while the `CountNotifier` handles the underlying logic and state management for the count functionality.

<br>

## Super Framework APIs

### SuperApp

A stateful widget that represents the root of the Super framework.
The [child] parameter is required and represents the main content of the app.

The [config] parameter is an optional [SuperAppConfig] object that allows you to customize the behavior of the Super framework.

The [mocks] parameter is an optional list of objects used for mocking dependencies during testing.
The `mocks` property provides a way to inject mock objects into the application's dependency graph during testing.
These mock objects can replace real dependencies, such as database connections or network clients, allowing for controlled and predictable testing scenarios.

**Important:** When using the `mocks` property, make sure to provide instantiated mock objects, not just their types.
For example, instead of `[MockAuthRepo]`, use `[MockAuthRepo()]` to ensure that the mock object is used.
Adding the type without instantiating the mock object will result in the mock not being utilized.

When [testMode] is set to `true`, the Super framework is activated in test mode.
Test mode can be used to enable additional testing features or behaviors specific to the Super framework.
By default, test mode is set to `false`.

The [enableLog] property takes an optional boolean value that enables or disables logging in the Super framework.

Example usage:

```dart
SuperApp(
  config: SuperAppConfig(
    mocks: [
      MockAuthRepo(),
      MockDatabase(),
    ],
    testMode: true,
    enableLog: kDebugMode,
    onInit: asyncFunction,
    loading: SizedBox(),
    onError: (err, stk) => SizedBox();
  ),
  child: const MyApp(),
);
```

<br>

### SuperController

A mixin class that provides a lifecycle for controllers used in the application.

The `SuperController` mixin class allows you to define the lifecycle of your controller classes.
It provides methods that are called at specific points in the widget lifecycle, allowing you to initialize resources, handle events, and clean up resources when the controller is no longer needed. Since it is tied to the widget itself, the BuildContext of the widget is accessible from the controller after it is alive.

Example usage:

```dart
class SampleController extends SuperController {
  final _count = 0.rx; // RxInt(0);
  final _loading = false.rx; // RxBool(false);

  int get count => _count.state;
  bool get loading => _loading.state;

  @override
  void onAlive() {
    ctrlContext.showTextSnackBar('Controller Alive');
  }

  void increment() {
    _count.state++;
  }

  void toggleLoading() {
    _loading.state = !_loading.state;
  }

  @override
  void onDisable() {
    _count.dispose(); // Dispose Rx object.
    _loading.dispose();
    super.onDisable();
  }
}
```

In the example above, `SampleController` extends `SuperController` and defines a `count` variable that is managed by an `Rx` object. The `increment()` method is used to increment the count state. The `onDisable()` method is overridden to dispose of the `Rx` object when the controller is disabled. <br>
As seen in the `SampleController` above, a controller may contain multiple states required by it's corresponding widget, however, for the sake of keeping a controller clean and focused, if there exists a state with multiple events, it is recommended to define an `RxNotifier` for that state.

**Important:** It is recommended to define Rx objects as private and only provide a getter for accessing the state.
This helps prevent the state from being changed outside of the controller, ensuring that the state is only modified through defined methods within the controller (e.g., `increment()` in the example).

<br>

### SuperModel

A class that provides value equality checking for classes.
Classes that extend this class should implement the `props` getter, which returns a list of the class properties that should be used for equality checking.

Example usage:

```dart
class UserModel with SuperModel {
  UserModel(this.id, this.name);

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name]; // Important
}

final _user = UserModel(1, 'Paul').rx;
final user2 = UserModel(1, 'Paul');

_user.state == user2; // true
_user.state = user2; // Will not trigger a rebuild
```

<br>

## Widgets in the Super Framework

### SuperWidget

A [StatelessWidget] that provides the base functionality for widgets that work with a [SuperController].

This widget serves as a foundation for building widgets that require a controller to manage their state and lifecycle.
By extending [SuperWidget] and providing a concrete implementation of [initController()], you can easily associate a controller with the widget. When used with a controller, the controller lifecycle is bound to the widget. It also utilizes a `controller` getter as the widget controller reference.

Example Usage:

```dart
class MyWidget extends SuperWidget<MyController> {
  @override
  MyController initController() => MyController();

  // Widget implementation...
}
```

**Important:** It is recommended to use one controller per widget to ensure proper encapsulation and separation of concerns. Each widget should have its own dedicated controller for managing its state and lifecycle. This approach promotes clean and modular code by keeping the responsibilities of each widget and its associated controller separate.

If you have a widget that doesn't require state management or interaction with a controller, it is best to use a vanilla [StatelessWidget] instead. Using a controller in a widget that doesn't have any state could add unnecessary complexity and overhead.

<br>

### SuperBuilder

The [SuperBuilder] widget allows you to rebuild a part of your UI in response to changes in an [Rx] object. 
It takes a [builder] callback function that receives a [BuildContext] and returns the widget to be built.

The [builder] callback will be invoked whenever the [Rx] object changes its state, triggering a rebuild of 
the widget. The [Rx] object can be accessed within the [builder] callback, allowing you to incorporate its state into your UI.

Example usage:

```dart
SuperBuilder(
  builder: (context) {
    // return widget here based on Rx state
  }
)
```
**Important:** You need to make use of an [Rx] object state in the builder method, otherwise it will result in an error.

**Note:** If you'd prefer to specify the `Rx` object outside the builder method, i.e you opted to make your `Rx` objects non-private then make use of the `SuperConsumer` widget.

The [buildWhen] parameter is an optional condition that determines whether the [builder] should be called when the [Rx] object changes.
If [buildWhen] evaluates to `false`, the [builder] will not be called, and the child widget will not be rebuilt.

Example usage:

```dart
SuperBuilder(
  buildWhen: () => controller.count > 3,
  builder: (context) {
    // return widget here based on Rx state
  }
)
```

<br>

### SuperConsumer

[SuperConsumer] is a StatefulWidget that listens to changes in an [RxT] or [RxNotifier] object and rebuilds its child widget whenever the [Rx] object's state changes.

The [SuperConsumer] widget takes a [builder] function, which is called whenever the [Rx] object changes. The [builder] function receives the current [BuildContext] and the latest state of the [Rx] object, and returns the widget tree to be built.

Example usage:

```dart
CounterNotifier get counterNotifier => Super.init(CounterNotifier());

// ...

SuperConsumer<int>(
  rx: counterNotifier,
  builder: (context, state) {
    return Text('Count: $state');
  },
)
```

In the above example, a [SuperConsumer] widget is created and given a `CounterNotifier` object called counterNotifier. Whenever the state of the counterNotifier changes, the  builder function is called with the latest state, and it returns a [Text] widget displaying the count.

#### Asynchronous State

The [SuperConsumer] widget can also be used for 
asynchronous state.

The optional [loading] parameter can be used to specify a widget
to be displayed while an RxNotifier is in loading state.

Example usage:

```dart
CounterNotifier get counterNotifier => Super.init(CounterNotifier());

class CounterNotifier extends RxNotifier<int> {
  @override
  int initial() {
    return 0; // Initial state
  }

  Future<void> getData() async {
    toggleLoading(); // set loading to true
    state = await Future.delayed(const Duration(seconds: 3), () => 5);
  }
}

SuperConsumer<int>(
  rx: counterNotifier,
  loading: const CircularProgressIndicator();
  builder: (context, state) {
    return Text('Count: $state');
  },
)
```

As seen above, a [SuperConsumer] widget is created and given
an [RxNotifier] object called counterNotifier. When the widget is built, if the RxNotifier is in loading state, the loading widget will be displayed.
When the asynchronous method completes and the state is updated, the
builder function is called with the state.

<br>

### SuperListener

The [SuperListener] widget listens to changes in the provided rx object
and calls the [listener] callback when the rx object changes its state.

The [listener] callback is called once when the rx object changes
its state.

The [child] parameter is an optional child widget to be rendered by
this widget.

The [listenWhen] parameter is an optional condition that determines whether
the [listener] should be called when the rx object changes. If
[listenWhen] evaluates to `true`, the [listener]
will be called; otherwise, it will be skipped.

Example usage:

```dart
SuperListener<int>(
  listen: () => controller.count;
  listenWhen: (count) => count > 5,
  listener: (context) {
    // Handle the state change here
  }, // Will only call the listener if count is greater than 5
  child: Text('Counter'),
)
```

**Important:** You need to make use of an [Rx] object state in the listen parameter, otherwise it will result in an error.

<br>

### AsyncBuilder

A stateful widget that builds itself based on the state of an asynchronous computation.

The [builder] parameter is a required callback function that returns the widget to be built.

The [future] parameter represents an asynchronous computation that will trigger a rebuild when completed.

The [stream] parameter represents an asynchronous data stream that will trigger a rebuild when new data is available.

The [initialData] parameter represents the initial data that will be used to create the snapshots until a non-null [future] or [stream] has completed.

The [loading] parameter represents a widget to display while the asynchronous computation is in progress. Note: The [loading] widget will not be displayed if [initialData] is not null.

The [error] parameter represents a widget builder that constructs an error widget when an error occurs in the asynchronous computation.

Example usage:

```dart
AsyncBuilder<int>(
  initialData: 5,
  future: Future.delayed(const Duration(seconds: 2), () => 10),
  builder: (data) => Text('Data: $data'),
  error: (error, stackTrace) => Text('Error: $error'),
  loading: const CircularProgressIndicator.adaptive(),
),
```

**Important:** Either a future or a stream should be used at a time, using both at the same time will result in an error.

<br>

## Rx Types

### RxT

A reactive container for holding a state of type `T`.

The `RxT` class is a specialization of the `Rx` class that represents a reactive state. It allows you to store and update a state of type `T` and automatically notifies its listeners when the state changes.

Example usage:

```dart
final _counter = RxT<int>(0); // same as RxInt(0) or 0.rx 

void increment() {
  _counter.state++;
}
```

#### RxT SubTypes

- RxInt
- RxString
- RxBool
- RxDouble

It is best used for local state i.e state used in a single controller.

**Note:** When using the RxT class, it is important to call the `dispose()` method on the object when it is no longer needed to prevent memory leaks. This can be done using the onDisable method of your controller.

<br>

### RxNotifier

An abstract base class for creating reactive notifiers that manage a state of type `T`.

The `RxNotifier` class provides a foundation for creating reactive notifiers that encapsulate a piece of immutable state and notify their listeners when the state changes. Subclasses of `RxNotifier` must override the `initial` method to provide the initial state and implement the logic for updating the state.

Example usage:

```dart
CounterNotifier get counterNotifier => Super.init(CounterNotifier());

class CounterNotifier extends RxNotifier<int> {
  @override
  int initial() {
    return 0; // Initial state
  }

  void increment() {
    state++; // Update the state
  }
}
```

#### Asynchronous State

An `RxNotifier` can also be used for asynchronous state. 

By default the loading state is set to false so that none asynchronous 
state can be utilized.

Example usage:

```dart
BooksNotifier get booksNotifier => Super.init(BooksNotifier());

class BooksNotifier extends RxNotifier<List<Book>> {
  @override
  List<Book> initial() {
    return []; // Initial state
  }

  void getBooks() async {
    toggleLoading(); // set loading to true
    state = await booksRepo.getBooks(); // Update the state
  }
}
```

It is best used for global state i.e state used in multiple controllers but it could also be used for a single controller to abstract a state and its events e.g if a state has a lot of events, rather than complicating the controller, an RxNotifier could be used for that singular state instead.

**Important:** Unlike in the example above, it is important to make use of an error handling approach such as a try catch block or the .result extension when dealing with asynchronous requests, this is so as to handle exceptions which may be thrown from the asynchronous method.

**Note:** When using the RxNotifier class, it is important to call the `dispose()` method on the object when it is no longer needed to prevent memory leaks. This can be done using the onDisable method of your controller.

<br>

### Rx Collections

These are similar to RxT but do not require the use of .state, they extend the functionality of the regular dart collections by being reactive.

- RxMap
- RxSet
- RxList

<br>

## Dependency Injection

The [autoDispose] parameter of `create` and `init` is an optional boolean value that determines whether the Super framework should automatically dispose of dependencies when they are no longer needed.
By default, [autoDispose] is set to `true`, enabling automatic disposal.
Set [autoDispose] to `false` if you want to manually handle the disposal of resources in your application.

### of

Retrieves the instance of a dependency from the manager and enables the controller if the dependency extends `SuperController`.
```dart
Super.of<T>();
```

<br>

### init

Initializes and retrieves the instance of a dependency, or creates a new instance if it doesn't exist.
```dart
Super.init<T>(T instance, {bool autoDispose = true});
```

<br>

### create

Creates a singleton instance of a dependency and registers it with the manager.
```dart
Super.create<T>(T instance, {bool autoDispose = true});
```

<br>

### delete

Deletes the instance of a dependency from the manager.
```dart
Super.delete<T>();
```

<br>

### deleteAll

Deletes all instances of dependencies from the manager.
```dart
Super.deleteAll();
```

<br>

## Useful APIs

### context.read

Works exactly like `Super.of<T>()` but with BuildContext and is familiar
```dart
context.read<T>();
```

<br>

### context.watch

This returns the state of an Rx object i.e RxT or RxNotifier,
and rebuilds the widget when the state changes.
```dart
context.watch<T>(Rx rx);
```

Example usage:

```dart
final count = 0.rx; // Quick example
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch(count);
    return Scaffold(
      body: Center(
        child: Text(
          '$state',
           style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
```

This can be used instead of the SuperBuilder/SuperConsumer widgets.
It is worth noting however that, unlike those APIs which rebuild only
the widget in their builder methods, this will rebuild the entire widget.

<br>
