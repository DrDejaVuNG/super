"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
const react_1 = require("react");
/**
 * Custom hook for initializing and managing a SuperController instance.
 * @template T The type of the SuperController instance.
 * @param {T} controller The SuperController instance.
 * @returns {T} The initialized and managed SuperController instance.
 */
function useController(controller) {
    const sController = index_1.Super.init(controller);
    react_1.useEffect(() => {
        /**
         * Enables the SuperController when the component mounts.
         * Disables the SuperController when the component unmounts.
         */
        sController.enable();
        return () => {
            sController.disable();
        };
    }, []);
    return sController;
}
exports.default = useController;
