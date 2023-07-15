"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RxListener = exports.RxMerge = exports.Rx = exports.rxWatch = void 0;
function rxWatch(callback, { stopWhen }) {
    RxListener.listen();
    callback();
    const rx = RxListener.listenedRx();
    function call() {
        if (stopWhen && !stopWhen()) {
            callback();
            return;
        }
        rx.removeListener(call);
    }
    return rx.addListener(call);
}
exports.rxWatch = rxWatch;
/**
 * Abstract class representing a reactive object that holds a state value and notifies listeners of changes.
 * @template T The type of the state value.
 */
class Rx {
    /**
     * Throws an error if the `dispose` method has already been called.
     */
    assertMounted() {
        if (!this.mounted) {
            throw new Error(`The ${this.constructor.name} object was accessed or utilized after being disposed. ` +
                `Once the dispose() method is called on a ${this.constructor.name} object, it becomes unusable.`);
        }
    }
    /**
     * Returns a string representation of the runtime type and state of the object.
     */
    toString() {
        return `${this.constructor.name}(${this.state})`;
    }
}
exports.Rx = Rx;
/**
 * Merges multiple Rx objects into a single Rx object.
 */
class RxMerge extends Rx {
    /**
     * Creates an RxMerge instance with the specified list of Rx objects.
     * @param children - The Rx objects to be merged together.
     */
    constructor(children) {
        super();
        this.children = children;
    }
    /**
     * Add a listener to all the merged Rx objects.
     * @param listener - The callback function to be added as a listener.
     */
    addListener(listener) {
        for (const child of this.children) {
            child === null || child === void 0 ? void 0 : child.addListener(listener);
        }
    }
    /**
     * Remove a listener from all the merged Rx objects.
     * @param listener - The callback function to be removed from the listeners list.
     */
    removeListener(listener) {
        for (const child of this.children) {
            child === null || child === void 0 ? void 0 : child.removeListener(listener);
        }
    }
    get mounted() {
        var _a, _b;
        return (_b = (_a = this.children[0]) === null || _a === void 0 ? void 0 : _a.mounted) !== null && _b !== void 0 ? _b : false;
    }
    get hasListeners() {
        var _a, _b;
        return (_b = (_a = this.children[0]) === null || _a === void 0 ? void 0 : _a.hasListeners) !== null && _b !== void 0 ? _b : false;
    }
    get state() {
        const states = [];
        for (const child of this.children) {
            states.push(child);
        }
        return states;
    }
    set state(value) {
        throw new Error("Cannot set RxMerge state");
    }
    dispose() {
        for (const child of this.children) {
            child === null || child === void 0 ? void 0 : child.dispose();
        }
    }
    /**
     * Get a string representation of the RxMerge object.
     * @returns A string representation of the RxMerge object.
     */
    toString() {
        return `RxMerge([${this.children.join(", ")}])`;
    }
}
exports.RxMerge = RxMerge;
/**
 * Helper class for listening to changes in Rx objects.
 */
class RxListener {
    /**
     * Start listening for changes in Rx objects.
     */
    static listen() {
        RxListener.isListening = true;
    }
    /**
     * Get the list of captured Rx objects.
     * @returns The list of captured Rx objects.
     * @throws An error if no Rx objects have been captured.
     */
    static getRxList() {
        RxListener.isListening = false;
        const newRxList = [...RxListener.rxList];
        RxListener.rxList = [];
        if (newRxList.length > 0) {
            return newRxList;
        }
        throw new Error("Couldn't find any Rx object, you need to use the state of an " +
            "Rx object in the rxWatch or SuperX component i.e RxT or RxNotifier.");
    }
    /**
     * Create an RxMerge instance with the captured Rx objects.
     * @returns An RxMerge instance that merges all the captured Rx objects.
     */
    static listenedRx() {
        const rx = new RxMerge(RxListener.getRxList());
        return rx;
    }
    /**
     * Capture an Rx object for listening.
     * @param rx - The Rx object to capture.
     */
    static read(rx) {
        if (!RxListener.isListening)
            return;
        RxListener.rxList.push(rx);
    }
}
exports.RxListener = RxListener;
RxListener.rxList = [];
RxListener.isListening = false;
