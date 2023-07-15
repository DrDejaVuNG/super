"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Super = void 0;
const injection_1 = __importDefault(require("../injection"));
/**
 * SuperInterface provides a simplified interface for interacting with the Injection class.
 */
class SuperInterface {
    /**
     * Creates a singleton instance of a dependency and registers it with the manager.
     *
     * @param instance The instance of the dependency to be registered.
     */
    create(inst) {
        return injection_1.default.create({ instance: inst, key: inst.constructor.name });
    }
    /**
     * Retrieves the instance of a dependency from the manager.
     *
     * **Note** The key of is the name of the dependency.
     *
     * @param key The key used to identify the dependency.
     * @returns The instance of the dependency.
     */
    of(key) {
        return injection_1.default.of(key);
    }
    /**
     * Initializes and retrieves the instance of a dependency, or creates a new instance if it doesn't exist.
     *
     * @param instance The instance of the dependency to be initialized.
     * @returns The instance of the dependency.
     */
    init(inst) {
        return injection_1.default.init({ instance: inst, key: inst.constructor.name });
    }
    /**
     * Deletes the instance of a dependency from the manager.
     *
     * **Note** The key of is the name of the dependency.
     *
     * @param key The key used to identify the dependency.
     */
    delete(key) {
        return injection_1.default.delete({ key, force: true });
    }
    /**
     * Deletes all instances of dependencies from the manager.
     */
    deleteAll() {
        return injection_1.default.deleteAll();
    }
    /**
     * Activates the Super framework.
     *
     * @param testMode Specifies whether the framework is in test mode.
     * @param autoDispose Specifies whether automatic disposal is enabled.
     * @param mocks Optional mocks to be used during testing.
     */
    activate({ testMode, autoDispose, mocks, }) {
        return injection_1.default.activate({ testMode, autoDispose, mocks });
    }
    /**
     * Deactivates the Super framework.
     */
    deactivate() {
        return injection_1.default.deactivate();
    }
}
exports.Super = new SuperInterface();
