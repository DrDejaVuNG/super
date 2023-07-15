"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const react_1 = __importDefault(require("react"));
const use_state_1 = __importDefault(require("./use_state"));
const index_1 = require("./index");
/**
 * A React component that subscribes to the Rx object(s) used inside it
 * and renders its children whenever the state changes.
 * @param children A function that returns the rendered content.
 * @returns The rendered component.
 */
function SuperX({ children }) {
    index_1.RxListener.listen();
    children();
    const rx = index_1.RxListener.listenedRx();
    use_state_1.default(rx);
    return (react_1.default.createElement("div", null, children()));
}
exports.default = SuperX;
