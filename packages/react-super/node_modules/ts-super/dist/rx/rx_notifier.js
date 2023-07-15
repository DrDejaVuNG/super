"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const rx_1 = require("./rx");
/**
 * Represents a reactive object that holds a state value of type `T`,
 * provides a watch function to track changes, and notifies listeners of state changes.
 * @template T The type of the state value.
 */
class RxNotifier extends rx_1.Rx {
    /**
     * Creates a new `RxNotifier` object.
     * The state value is initialized with the result of the `watch` function.
     */
    constructor() {
        super();
        this._listeners = [];
        this._mounted = true;
        this._state = this.watch();
    }
    get state() {
        rx_1.RxListener.read(this);
        return this._state;
    }
    set state(value) {
        if (`${this._state}` === `${value}`)
            return;
        this._state = value;
        this._notifyListeners();
    }
    get mounted() {
        return this._mounted;
    }
    get hasListeners() {
        return this._listeners.length > 0;
    }
    addListener(listener) {
        this._listeners.push(listener);
    }
    removeListener(listener) {
        this.assertMounted();
        const index = this._listeners.indexOf(listener);
        if (index !== -1) {
            this._listeners.splice(index, 1);
        }
    }
    dispose() {
        if (!this._mounted)
            return;
        this._mounted = false;
        this._listeners = [];
    }
    /**
     * Notifies registered listeners about changes in the object's state.
     * This method should be called whenever the object's state changes.
     * It should not be called after the object has been disposed.
     */
    _notifyListeners() {
        this.assertMounted();
        for (const listener of this._listeners) {
            listener();
        }
    }
}
exports.default = RxNotifier;
