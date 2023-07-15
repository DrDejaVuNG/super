export type VoidCallback = () => void;

export function rxWatch(callback:VoidCallback, {stopWhen}: {stopWhen?: () => boolean} ): void {
  RxListener.listen();
  callback();
  const rx = RxListener.listenedRx();
  function call(): void {
    if (stopWhen && !stopWhen()) {
      callback();
      return;
    }
    rx.removeListener(call);
  }

  return rx.addListener(call);
}

/**
 * Abstract class representing a reactive object that holds a state value and notifies listeners of changes.
 * @template T The type of the state value.
 */
export abstract class Rx<T extends Object> {
  /**
   * Verify whether `dispose` was called or not.
   */
  abstract get mounted(): boolean;

  /**
   * Whether any listeners are currently registered.
   */
  abstract get hasListeners(): boolean;
  
  /**
   * Throws an error if the `dispose` method has already been called.
   */
  assertMounted(): void {
    if (!this.mounted) {
      throw new Error(
        `The ${this.constructor.name} object was accessed or utilized after being disposed. ` +
        `Once the dispose() method is called on a ${this.constructor.name} object, it becomes unusable.`
      );
    }
  }

  /**
   * The current state of the object.
   */
  abstract get state(): T;

  /**
   * Sets the state of the object and notifies listeners of the change.
   */
  abstract set state(value: T);

  /**
   * Adds a listener callback to be invoked when the object's state changes.
   * If the provided callback is already registered, an additional instance is added, and it must be removed
   * the same number of times it was added in order to stop its invocation.
   * This method should not be called after the `dispose` method has been invoked.
   * @param listener The callback function to be added as a listener.
   */
  abstract addListener(listener: VoidCallback): void;
  
  /**
   * Removes a previously added listener callback from the list of listeners.
   * @param listener The callback function to be removed from the listeners list.
   */
  abstract removeListener(listener: VoidCallback): void;
  
  /**
   * Releases resources and marks the object as unusable.
   * This method should only be called by the owner of the object.
   * It clears the listener list without notifying listeners.
   */
  abstract dispose(): void;
  
  /**
   * Returns a string representation of the runtime type and state of the object.
   */
  toString(): string {
    return `${this.constructor.name}(${this.state})`;
  }
}

/**
 * Merges multiple Rx objects into a single Rx object.
 */
export class RxMerge extends Rx<any> {
  /**
   * Creates an RxMerge instance with the specified list of Rx objects.
   * @param children - The Rx objects to be merged together.
   */
  constructor(children: (Rx<any> | undefined)[]) {
    super();
    this.children = children;
  }
  
  private children: (Rx<any> | undefined)[];

  /**
   * Add a listener to all the merged Rx objects.
   * @param listener - The callback function to be added as a listener.
   */
  addListener(listener: VoidCallback): void {
    for (const child of this.children) {
      child?.addListener(listener);
    }
  }

  /**
   * Remove a listener from all the merged Rx objects.
   * @param listener - The callback function to be removed from the listeners list.
   */
  removeListener(listener: VoidCallback): void {
    for (const child of this.children) {
      child?.removeListener(listener);
    }
  }

  get mounted(): boolean {
    return this.children[0]?.mounted ?? false;
  }

  get hasListeners(): boolean {
    return this.children[0]?.hasListeners ?? false;
  }

  get state(): any {
    const states: any = [];
    for (const child of this.children) {
      states.push(child);
    }
    return states;
  }

  set state(value: any) {
    throw new Error("Cannot set RxMerge state");
  }

  dispose(): void {
    for (const child of this.children) {
      child?.dispose();
    }
  }

  /**
   * Get a string representation of the RxMerge object.
   * @returns A string representation of the RxMerge object.
   */
  toString(): string {
    return `RxMerge([${this.children.join(", ")}])`;
  }
}

/**
 * Helper class for listening to changes in Rx objects.
 */
export class RxListener {
  private static rxList: Rx<any>[] = [];
  private static isListening = false;

  /**
   * Start listening for changes in Rx objects.
   */
  static listen(): void {
    RxListener.isListening = true;
  }

  /**
   * Get the list of captured Rx objects.
   * @returns The list of captured Rx objects.
   * @throws An error if no Rx objects have been captured.
   */
  private static getRxList(): Rx<any>[] {
    RxListener.isListening = false;
    const newRxList = [...RxListener.rxList];
    RxListener.rxList = [];
    if (newRxList.length > 0) {
      return newRxList;
    }
    throw new Error(
      "Couldn't find any Rx object, you need to use the state of an " +
      "Rx object in the rxWatch or SuperX component i.e RxT or RxNotifier."
    );
  }

  /**
   * Create an RxMerge instance with the captured Rx objects.
   * @returns An RxMerge instance that merges all the captured Rx objects.
   */
  static listenedRx(): RxMerge {
    const rx = new RxMerge(RxListener.getRxList());
    return rx;
  }

  /**
   * Capture an Rx object for listening.
   * @param rx - The Rx object to capture.
   */
  static read(rx: Rx<any>): void {
    if (!RxListener.isListening) return;
    RxListener.rxList.push(rx);
  }
}
