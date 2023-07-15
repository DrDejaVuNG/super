<p align="center" height="100">
<img src="https://github.com/DrDejaVuNG/super/blob/main/screenshots/logo.png?raw=true" height="120" alt="Super" />
</p>

---

Super is a state management framework for JS that aims to simplify
and streamline the development of reactive and scalable applications.

---

## Features

- Reactive state management.
- Simple dependency injection.

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
  - [RxNotifier](#rxnotifier)
- [Dependency Injection](#dependency-injection)
  - [of](#of)
  - [init](#init)
  - [create](#create)
  - [delete](#delete)
  - [deleteAll](#deleteall)
- [Maintainers](#maintainers)
- [Credits](#credits)

---

## Getting Started

Add Super to your project:

```
npm i ts-super
```

Import the Super package into your project:

```ts
import { rxState, rxWatch } from 'ts-super';
import { Rx, Super, RxNotifier, SuperModel, SuperController, } from 'ts-super';
```

<br>

## Usage

### Counter App Example

Set up the framework for the project by calling the `Super.activate()` method, which enables the  `Super` framework.

```ts
Super.activate(); // Activate the Super framework

// Declare a state object
const count = rxState(0);

// The method used in the rxWatch method will be called
// every time the state changes.
rxWatch(
  () => console.log(count.state), 
  {
    stopWhen: () => count.state > 3,
  }
);

// Increment the state
count.state++; // prints '1'
count.state++; // prints '2'
count.state++; // prints '3'
count.state++; // doesn't print
```

By using the rxWatch method on the state object, we will be able to listen to changes in the state. When the state changes the given callback  will be called.

<br>

## Super Framework APIs

### SuperController

A class that provides a lifecycle for controllers used in the application.

The `SuperController` class allows you to define the lifecycle of your controller classes.
It provides methods that are called at specific points in the controller lifecycle, allowing you to initialize resources, handle events, and clean up resources when the controller is no longer needed. 

Example usage:

```ts
class SampleController extends SuperController {
  constructor() {
    super();
  }

  const count = rxState(0);
  const loading = rxState(false);

  increment(): void {
    this.count.state++;
  }

  toggleLoading(): void {
    this.loading.state = !loading.state;
  }

  onDisable(): void {
    this.count.dispose(); // Dispose Rx object.
    this.loading.dispose();
    super.onDisable();
  }
}
```

In the example above, `SampleController` extends `SuperController` and defines a `count` variable that is managed by an `Rx` object. The `increment()` method is used to increment the count state. The `onDisable()` method is overridden to dispose of the `Rx` object when the controller is disabled.

<br>

### SuperModel

A class that provides value equality checking for classes.
Classes that extend this class should implement the `props` getter, which returns a list of the class properties that should be used for equality checking.

Example usage:

```ts
class UserModel extends SuperModel {
  constructor(id: number, name: string) {
    super();
    this.id = id;
    this.name = name
  }

  const id: number;
  const name: string;

  get props(): Object[] {
    return [this.id, this.name]; // Important
  }
}

const user = rxState(UserModel(1, 'Paul'));
const user2 = UserModel(1, 'Paul');

user.state == user2; // true
user.state = user2; // Will not trigger a rebuild
```

<br>

## Rx Types

### RxT

A reactive container for holding a state of type `T`.

The `RxT` class is a specialization of the `Rx` class that represents a reactive state. It allows you to store and update a state of type `T` and automatically notifies its listeners when the state changes.

Example usage:

```ts
const _counter = rxState(0); 

void increment() {
  _counter.state++;
}

// Listen to the state
rxWatch(() {
  console.log(`Counter changed: ${_counter.state}`);
});

// Updating the state
_counter.increment(); // This will trigger the listener and print the updated state.
```

It is best used for local state i.e state used in a single controller.

**Note:** When using the RxT class, it is important to call the `dispose()` method on the object when it is no longer needed to prevent memory leaks. This can be done using the onDisable method of your controller.

<br>

### RxNotifier

An abstract base class for creating reactive notifiers that manage a state of type `T`.

The `RxNotifier` class provides a foundation for creating reactive notifiers that encapsulate a piece of immutable state and notify their listeners when the state changes. Subclasses of `RxNotifier` must override the `watch` method to provide the initial state and implement the logic for updating the state.

Example usage:

```ts

class CounterNotifier extends RxNotifier<number> {
  watch(): number {
    return 0; // Initial state
  }

  increment(): void {
    state++; // Update the state
  }
}

// Listen to the state
rxWatch(() {
  print(`Counter changed: ${counterNotifier.state}`);
});

// Updating the state
counterNotifier.increment(); // This will trigger the listener and print the updated state.
```

It is best used for global state i.e state used in multiple controllers but it could also be used for a single controller to abstract a state and its events e.g if a state has a lot of events, rather than complicating the controller, an RxNotifier could be used for that singular state instead.

**Note:** When using the RxNotifier class, it is important to call the `dispose()` method on the object when it is no longer needed to prevent memory leaks. This can be done using the onDisable method of your controller.

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
Super.create<T>(T instance);
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

## Maintainers

- [Seyon Anko](https://github.com/DrDejaVuNG)

<br>

## Credits

All credits to God Almighty who guided me through the project.