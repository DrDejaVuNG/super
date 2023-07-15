"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const rx_1 = require("./rx");
/**
 * Creates a new `RxT` object with the initial state value.
 * @param state The initial state value.
 * @returns A new `RxT` object.
 */
function rxState(state) {
    return new RxT(state);
}
exports.default = rxState;
/**
 * Represents a reactive object that holds a state value of type `T` and notifies listeners of changes.
 * @template T The type of the state value.
 */
class RxT extends rx_1.Rx {
    /**
     * Creates a new `RxT` object with the initial state value.
     * @param state The initial state value.
     */
    constructor(state) {
        super();
        this._listeners = [];
        this._mounted = true;
        this._state = state;
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
