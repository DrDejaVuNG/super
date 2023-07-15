import { Rx, VoidCallback } from "./rx";
/**
 * Represents a reactive object that holds a state value of type `T`,
 * provides a watch function to track changes, and notifies listeners of state changes.
 * @template T The type of the state value.
 */
declare abstract class RxNotifier<T extends Object> extends Rx<T> {
    /**
     * Creates a new `RxNotifier` object.
     * The state value is initialized with the result of the `watch` function.
     */
    constructor();
    private _listeners;
    private _mounted;
    private _state;
    /**
     * Abstract method to be implemented by subclasses.
     * The `watch` function should return the current state value.
     * @returns The current state value.
     */
    abstract watch(): T;
    get state(): T;
    set state(value: T);
    get mounted(): boolean;
    get hasListeners(): boolean;
    addListener(listener: VoidCallback): void;
    removeListener(listener: VoidCallback): void;
    dispose(): void;
    /**
     * Notifies registered listeners about changes in the object's state.
     * This method should be called whenever the object's state changes.
     * It should not be called after the object has been disposed.
     */
    private _notifyListeners;
}
export default RxNotifier;
