"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const react_1 = __importDefault(require("react"));
const use_state_1 = __importDefault(require("./use_state"));
/**
 * A React component that subscribes to an Rx object and renders its children
 * whenever the state changes.
 * @template T The type of the state value.
 * @param {SuperDivProps<T>} props The component props.
 * @returns The rendered component.
 */
function SuperDiv({ rx, children }) {
    const state = use_state_1.default(rx);
    return (react_1.default.createElement("div", null, children(state)));
}
exports.default = SuperDiv;
