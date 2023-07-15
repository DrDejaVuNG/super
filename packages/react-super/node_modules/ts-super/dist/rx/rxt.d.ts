import { Rx, VoidCallback } from "./rx";
/**
 * Creates a new `RxT` object with the initial state value.
 * @param state The initial state value.
 * @returns A new `RxT` object.
 */
export default function rxState<T extends Object>(state: T): RxT<T>;
/**
 * Represents a reactive object that holds a state value of type `T` and notifies listeners of changes.
 * @template T The type of the state value.
 */
declare class RxT<T extends Object> extends Rx<T> {
    /**
     * Creates a new `RxT` object with the initial state value.
     * @param state The initial state value.
     */
    constructor(state: T);
    private _listeners;
    private _mounted;
    private _state;
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
export {};
