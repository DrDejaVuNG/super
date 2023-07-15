"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
const react_1 = __importStar(require("react"));
/**
 * A component that activates and deactivates the Super framework.
 *
 * The SuperApp component should be placed at the root of your application
 * to enable the Super framework and configure its behavior.
 *
 * @param props The props for the SuperApp component.
 * @returns The rendered SuperApp component.
 */
function SuperApp({ mocks, testMode = false, autoDispose = true, children }) {
    // Activate the Super framework
    index_1.Super.activate({
        mocks,
        testMode,
        autoDispose,
    });
    react_1.useEffect(() => {
        index_1.Super.activate({
            mocks,
            testMode,
            autoDispose,
        });
        return () => {
            // Deactivate the Super framework
            index_1.Super.deactivate();
        };
    }, []);
    return react_1.default.createElement("div", null, children);
}
exports.default = SuperApp;
