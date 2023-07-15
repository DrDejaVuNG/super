import { Rx, RxListener, VoidCallback } from "./rx";

/**
 * Represents a reactive object that holds a state value of type `T`,
 * provides a watch function to track changes, and notifies listeners of state changes.
 * @template T The type of the state value.
 */
abstract class RxNotifier<T extends Object> extends Rx<T> {
    /**
     * Creates a new `RxNotifier` object.
     * The state value is initialized with the result of the `watch` function.
     */
    constructor() {
      super();
      this._state = this.watch();
    }
    
    private _listeners: Array<VoidCallback> = [];
    private _mounted = true;
    private _state: T;
    
    /**
     * Abstract method to be implemented by subclasses.
     * The `watch` function should return the current state value.
     * @returns The current state value.
     */
    abstract watch(): T;  
    
    get state(): T {
      RxListener.read(this);
      return this._state;
    }
  
    set state(value: T) {
      if (`${this._state}` === `${value}`) return;
      this._state = value;
      this._notifyListeners();
    }
    
    get mounted(): boolean {
      return this._mounted;
    }
  
    get hasListeners(): boolean {
      return this._listeners.length > 0;
    }
  
    addListener(listener: VoidCallback): void {
      this._listeners.push(listener);
    }
  
    removeListener(listener: VoidCallback): void {
      this.assertMounted();
      const index = this._listeners.indexOf(listener);
      if (index !== -1) {
        this._listeners.splice(index, 1);
      }
    }
  
    dispose(): void {
      if (!this._mounted) return;
      this._mounted = false;
      this._listeners = [];
    }
  
    /**
     * Notifies registered listeners about changes in the object's state.
     * This method should be called whenever the object's state changes.
     * It should not be called after the object has been disposed.
     */
    private _notifyListeners(): void {
      this.assertMounted();
      for (const listener of this._listeners) {
        listener();
      }
    }
}

export default RxNotifier;
