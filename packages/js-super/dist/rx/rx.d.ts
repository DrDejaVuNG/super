export declare type VoidCallback = () => void;
export declare function rxWatch(callback: VoidCallback, { stopWhen }: {
    stopWhen?: () => boolean;
}): void;
/**
 * Abstract class representing a reactive object that holds a state value and notifies listeners of changes.
 * @template T The type of the state value.
 */
export declare abstract class Rx<T extends Object> {
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
    assertMounted(): void;
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
    toString(): string;
}
/**
 * Merges multiple Rx objects into a single Rx object.
 */
export declare class RxMerge extends Rx<any> {
    /**
     * Creates an RxMerge instance with the specified list of Rx objects.
     * @param children - The Rx objects to be merged together.
     */
    constructor(children: (Rx<any> | undefined)[]);
    private children;
    /**
     * Add a listener to all the merged Rx objects.
     * @param listener - The callback function to be added as a listener.
     */
    addListener(listener: VoidCallback): void;
    /**
     * Remove a listener from all the merged Rx objects.
     * @param listener - The callback function to be removed from the listeners list.
     */
    removeListener(listener: VoidCallback): void;
    get mounted(): boolean;
    get hasListeners(): boolean;
    get state(): any;
    set state(value: any);
    dispose(): void;
    /**
     * Get a string representation of the RxMerge object.
     * @returns A string representation of the RxMerge object.
     */
    toString(): string;
}
/**
 * Helper class for listening to changes in Rx objects.
 */
export declare class RxListener {
    private static rxList;
    private static isListening;
    /**
     * Start listening for changes in Rx objects.
     */
    static listen(): void;
    /**
     * Get the list of captured Rx objects.
     * @returns The list of captured Rx objects.
     * @throws An error if no Rx objects have been captured.
     */
    private static getRxList;
    /**
     * Create an RxMerge instance with the captured Rx objects.
     * @returns An RxMerge instance that merges all the captured Rx objects.
     */
    static listenedRx(): RxMerge;
    /**
     * Capture an Rx object for listening.
     * @param rx - The Rx object to capture.
     */
    static read(rx: Rx<any>): void;
}
