<p align="center">Flutter package: <a href="https://pub.dev/packages/flutter_super">flutter_super</a>
</p>

<br>

<p align="center" height="100">
<img src="https://github.com/DrDejaVuNG/super/blob/main/screenshots/logo.png?raw=true" height="120" alt="Super" />
</p>

<p align="center">
<a href="https://pub.dev/packages/dart_super"><img src="https://img.shields.io/pub/v/dart_super.svg?logo=dart&label=pub&color=blue" alt="Pub"></a>
<a href="https://pub.dev/packages/dart_super/score"><img src="https://img.shields.io/pub/points/dart_super?logo=dart" alt="Pub points"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="verygoodanalysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/DrDejaVuNG/flutter_super" alt="License: MIT"></a>
<img src="https://raw.githubusercontent.com/DrDejaVuNG/super/fbe3c231bff2644b1a3d8dbabf964526dc862cbf/packages/dart_super/coverage_badge.svg" alt="Coverage" />
</p>

---

Super is a state management framework for Dart that aims to simplify
and streamline the development of reactive and scalable applications.

---

## Features

- Reactive state management.
- Simple dependency injection.
- Intuitive testing, dedicated testing library [super_test](https://pub.dev/packages/super_test).

---

## Table of Contents

- [Features](#features)
- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Counter App Example](#counter-app-example)
- [Super Framework APIs](#super-framework-apis)
  - [SuperController](#supercontroller)
  - [SuperModel](#supermodel)
- [Rx Types](#rx-types)
  - [RxT](#rxt)
    - [RxT SubTypes](#rxt-subtypes)
  - [RxNotifier](#rxnotifier)
    - [Asynchronous State](#asynchronous-state)
  - [Rx Collections](#rx-collections)
- [Dependency Injection](#dependency-injection)
  - [of](#of)
  - [init](#init)
  - [create](#create)
  - [delete](#delete)
  - [deleteAll](#deleteall)
- [Useful APIs](#useful-apis)
  - [Error Handling](#error-handling)
- [Additional Information](#additional-information)
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
  dart_super:
```

Import the Super package into your project:

```dart
import 'package:dart_super/dart_super.dart';
```

<br>

## Usage

### Counter App Example

The `main.dart` file serves as the entry point for the application. It sets up the necessary framework for the project by calling the `Super.activate()` method , which enables the  `Super` framework.

```dart
void main() {
  Super.activate(); // Activate the Super framework

  // Declare a state object
  final count = 0.rx;

  // The method used in the addListener method will be called
  // every time the state changes.
  rxWatch(() => print(count.state), stopWhen: () => count.state > 3);

  // Increment the state
  count.state++; // prints '1'
  count.state++; // prints '2'
  count.state++; // prints '3'
  count.state++; // doesn't print
}
```

By using the rxWatch method on the state object, we will be able to listen to changes in the state. When the state changes the given callback  will be called.

<br>

## Super Framework APIs

### SuperController

A mixin class that provides a lifecycle for controllers used in the application.

The `SuperController` mixin class allows you to define the lifecycle of your controller classes.
It provides methods that are called at specific points in the controller's lifecycle, allowing you to initialize resources, handle events, and clean up resources when the controller is no longer needed. 

Example usage:

```dart
class SampleController extends SuperController {
  final _count = 0.rx; // RxInt(0);
  final _loading = false.rx; // RxBool(false);

  int get count => _count.state;
  bool get loading => _loading.state;

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

// Adding a listener to the state object
_counter.addListener(() {
  print('Counter changed: ${_counter.state}');
});

// Updating the state
_counter.increment(); // This will trigger the listener and print the updated state.
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
final counterNotifier = Super.init(CounterNotifier());

class CounterNotifier extends RxNotifier<int> {
  @override
  int initial() {
    return 0; // Initial state
  }

  void increment() {
    state++; // Update the state
  }
}

// Adding a listener to the notifier
counterNotifier.addListener(() {
  print('Counter changed: ${counterNotifier.state}');
});

// Updating the state
counterNotifier.increment(); // This will trigger the listener and print the updated state.
```

#### Asynchronous State

An `RxNotifier` can also be used for asynchronous state. 

By default the loading state is set to false so that none asynchronous 
state can be utilized.

Example usage:

```dart
final booksNotifier = Super.init(BooksNotifier());

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

### of

Retrieves the instance of a dependency from the manager and enables the controller if the dependency extends `SuperController`.
```dart
Super.of<T>();
```

<br>

### init

Initializes and retrieves the instance of a dependency, or creates a new instance if it doesn't exist.
```dart
Super.init<T>(T instance);
```

<br>

### create

Creates a singleton instance of a dependency and registers it with the manager.
```dart
Super.create<T>(T instance, {bool lazy = false});
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

### Error Handling

An extension method for handling the result of a [Future] with success and error callbacks.

The `result` method allows you to provide two callbacks: one for handling the success case when the [Future] completes successfully, and one for handling the error case when an exception occurs.

Example usage:

```dart
Future<int> fetchNumber() async {
  // Simulating an asynchronous operation
  await Future.delayed(Duration(seconds: 2));

  // Simulating an error
  throw Failure('Failed to fetch number');
}

void handleSuccess(int number) {
  print('Fetched number: $number');
}

void handleError(Failure error) {
  print('Error occurred: ${error.message}');
}

void main() {
  fetchNumber().result(handleError, handleSuccess);

  // or

  final request = fetchNumber();

  request.result<Failure, int>(
  (e) => print('Error occurred: ${e.message}');  // could replace `e` with error
  (s) => print('Fetched number: $s');            // could replace `s` with number
  );
}
```

<br>

## Additional Information

### API Reference

For more information on all the APIs and more, check out the [API reference](https://pub.dev/documentation/dart_super/latest).

<br>

## Requirements

- Dart 3: >= 3.0.0

<br>

## Maintainers

- [Seyon Anko](https://github.com/DrDejaVuNG)

<br>

## Dev Note

With Super, you can build robust and scalable dart applications while maintaining clean and organized code.
The framework strives to adhere to the high standards in terms of readability, documentation, and usability.

Give Super a try and experience a streamlined approach to state management in Dart!

I hope you find the Super framework as pleasing and easy to work with
as I intended it to be. If you have any feedback or suggestions for
improvement, please don't hesitate to reach out. Happy coding!

Best regards,
DrDejaVu

<br>

## Credits

All credits to God Almighty who guided me through the project.
