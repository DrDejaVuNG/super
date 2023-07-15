<p align="center" height="100">
<img src="https://github.com/DrDejaVuNG/super/blob/main/screenshots/logo.png?raw=true" height="120" alt="Super" />
</p>

---

Super is a state management framework for react that aims to simplify
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
    - [Basic Counter](#basic-counter)
    - [Better Counter](#better-counter)
- [Super Framework APIs](#super-framework-apis)
  - [SuperApp](#superapp)
  - [useState](#usestate)
  - [SuperDiv](#superdiv)
  - [SuperX](#superx)
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
npm i react-ts-super
```

Import the Super package into your project:

```ts
import { rxState, rxWatch } from 'react-ts-super';
import { Rx, Super, RxNotifier, SuperModel, SuperController, } from 'react-ts-super';
```

<br>

## Usage

### Counter App Example

The `index.txs` file serves as the entry point for the application. It sets up the necessary framework for the project by wrapping the App component with `SuperApp`, which enables the  `Super` framework.

```tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { SuperApp } from 'react-super';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <SuperApp>
      <App />
    </SuperApp>
  </React.StrictMode>
);

reportWebVitals();
```
The SuperApp component is responsible for activating and deactivating the Super framework. It should be placed at the root of your application to enable the Super framework and configure its behavior.

<br>

#### Basic Counter

The `App` component represents the root component of the counter application. It uses the Super framework to manage the state of the counter.

```tsx
import React from 'react';
import './App.css';
import { useState, rxState } from 'react-ts-super';

const count = rxState(0);

function App() {
  const state = useState(count);

  function handleClick() {
    count.state++;
  }
  
  return (
    <div className="App">
      <header className="App-header">
      <button onClick={handleClick}>
        Clicked {state} times
      </button>
      </header>
    </div>
  );
}

export default App;
```
In the basic counter implementation, we define a count variable using the rxState function from the Super framework. This function creates an Rx object that represents the reactive state of the counter.

The App component uses the useState function from the Super framework to synchronize the state of the count object with the component's local state. This allows the component to reactively update its UI whenever the counter state changes.

The handleClick function increments the count state by modifying the count.state property. The UI updates automatically to reflect the updated state.

<br>

#### Better Counter

The better counter implementation showcases the usage of a controller class and the SuperX component.

```tsx
import React from 'react';
import './App.css';
import { SuperX, rxState, rxWatch, useController, SuperController } from 'react-ts-super';


class AppController extends SuperController {
  public count = rxState(0);
}

const appController = new AppController();

function App() {
  const c = useController(appController); // Super.init(appController);

  function handleClick() {
    c.count.state++;
  }

  rxWatch(() => console.log(c.count.state));
  
  return (
    <div className="App">
      <header className="App-header">
      <SuperX> 
        {() => (
          <button onClick={handleClick}>
            Clicked {c.count.state} times
          </button>
        )}
      </SuperX>
      </header>
    </div>
  );
}

export default App;
```
In the better counter implementation, we define an AppController class that extends SuperController from the Super framework. This controller class manages the state and logic for the counter functionality.

The count variable is defined as an Rx object using the rxState function within the AppController class.

We create an instance of AppController named appController and use the useController hook from the Super framework to manage the lifecycle of the controller.

The handleClick function increments the count state by modifying the c.count.state property. The UI updates automatically to reflect the updated state.

We use the SuperX component to subscribe to the changes in the count state and render the button component. The SuperX component listens to the Rx objects used inside it and re-renders only its children and not the entire component whenever the state changes.

The rxWatch function is used to log the count state to the console whenever it changes.

By separating the logic into a controller class and the UI into the component, we achieve a clear separation of concerns. The controller class manages the state and logic, while the component handles the UI and renders based on the state provided by the controller.

The Super framework enables reactivity and simplifies the management of state in the counter application.

This counter example demonstrates the power and simplicity of the Super framework for managing state in React applications.

<br>

## Super Framework APIs

### SuperApp

To enable the Super framework, import SuperApp and wrap your root component with it:

Example usage:

```tsx
import { SuperApp } from 'react-ts-super';

ReactDOM.render(
  <SuperApp testMode={true} mocks={[new MockAppController]}>
    <App />
  </SuperApp>,
  document.getElementById('root')
);
```
By wrapping your application with SuperApp, you enable the Super framework and configure its behavior. The testMode prop determines whether the SuperApp is running in test mode, the autoDispose prop determines whether resources are automatically disposed of, and the mocks prop allows you to provide mock objects for dependency injection.

When the SuperApp component is mounted, it activates the Super framework with the specified configuration. When it is unmounted, it deactivates the Super framework and cleans up any resources.

Note: It is important to place the SuperApp component at the root of your application to ensure the Super framework is enabled for all components in your application.

<br>

### useState

The useState hook is a custom hook for synchronizing the state of an Rx object with a React component's local state.

Code
```tsx
function useState<T extends Object>(rx: Rx<T>): T;
```

Example usage:

```tsx
const state = useState(rx);
```
The useState hook is used to synchronize the state of an Rx object with a component's local state. Whenever the Rx object's state changes, the component's state is updated accordingly.

By using the useState hook, you can easily integrate reactive state management into your React components, ensuring that the UI stays in sync with the underlying Rx object's state.

<br>

### SuperDiv

The SuperDiv component is a React component that subscribes to an Rx object representing the state and renders its children whenever the state changes.

Example:

```tsx
import React from 'react';
import { rxState, SuperDiv } from 'react-ts-super';

function App() {
  const count = rxState(0);

  return (
    <SuperDiv rx={count}>
      {(state) => <div>Count: {state}</div>}
    </SuperDiv>
  );
}

export default App;
```
In the example above, we create an Rx state named `count` with an initial value of 0. We pass this Rx object to the SuperDiv component as the rx prop.

The `children` function in the SuperDiv component receives the current state value as an argument `(state)` and returns the rendered content. In this case, it renders a <div> element with the text "Count: {state}".

Whenever the state of the count object changes, the SuperDiv component re-renders its children with the updated state value.

<br>

### SuperX

The `SuperX` component is a React component that subscribes to the Rx object(s) used inside it and renders its children whenever the state changes.

Example:

```tsx
import React from 'react';\
import { rxState, SuperX } from './index';

function App() {
  const count = rxState('SuperX')
  return (
    <div>
      <SuperX>
        {() => <div>Hello, {count.state}!</div>}
      </SuperX>
    </div>
  );
}

export default App;
```
In the example above, we use the SuperX component to wrap the content we want to render. The children function `({() => <div>Hello, SuperX!</div>})` returns the desired content to be rendered.

Whenever the state of the Rx object(s) used inside the SuperX component changes, the component re-renders its children with the updated state.

**Note**: if you don't make use of an Rx object in the SuperX component, it will result in an error.

<br>

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
