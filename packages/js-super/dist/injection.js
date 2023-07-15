"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const rx_1 = require("./rx/rx");
const controller_1 = __importDefault(require("./controller"));
/**
 * A class that manages the instances of dependencies.
 */
class Injection {
    /**
     * Checks the scoped state of the framework.
     */
    static get scoped() {
        return Injection._scoped;
    }
    /**
     * Creates a singleton instance of a dependency and registers it
     * with the manager.
     *
     * @param instance The instance of the dependency to be registered.
     * @param key The key used to identify the dependency.
     */
    static create({ instance, key }) {
        if (!Injection._scoped) {
            throw new Error('SuperApp not found, Wrap the App component with [SuperApp] ' +
                'to enable the Super framework, i.e <SuperApp><App /></SuperApp>.');
        }
        Injection._register({ instance, key });
    }
    /**
     * Retrieves the instance of a dependency from the manager.
     *
     * @param key The key used to identify the dependency.
     * @returns The instance of the dependency.
     * @throws An error if the dependency cannot be found.
     */
    static of(key) {
        if (key in Injection._instances) {
            let inst = Injection._instances[key];
            if (inst instanceof controller_1.default)
                inst.enable();
            return inst;
        }
        throw new Error(`Failed to retrieve ${key} dependency. ` +
            `Call "Super.init({ instance: Dependency(), key: ${key} })" instead.`);
    }
    /**
     * Initializes and retrieves the instance of a dependency,
     * or creates a new instance if it doesn't exist.
     *
     * @param instance The instance of the dependency to be initialized.
     * @param key The key used to identify the dependency.
     * @returns The instance of the dependency.
     */
    static init({ instance, key }) {
        try {
            return Injection.of(key);
        }
        catch (e) {
            Injection.create({ instance, key });
            return Injection.of(key);
        }
    }
    static _register({ instance, key }) {
        if (Injection._testMode && Injection._mocks.length > 0) {
            for (const item of Injection._mocks) {
                const mock = Injection._registerMock(item);
                if (mock !== null) {
                    Injection._instances[key] = mock;
                    return;
                }
            }
        }
        Injection._instances[key] = instance;
    }
    static _registerMock(mock) {
        try {
            return mock;
        }
        catch (e) {
            return null;
        }
    }
    /**
     * Deletes the instance of a dependency from the manager.
     *
     * @param key The key used to identify the dependency.
     * @param force Specifies whether to force deletion even when autoDispose is disabled.
     */
    static delete({ key, force = false }) {
        if (Injection._autoDispose !== undefined && !Injection._autoDispose && !force) {
            return;
        }
        if (!(key in Injection._instances)) {
            return;
        }
        const inst = Injection._instances[key];
        if (inst instanceof controller_1.default)
            inst.disable();
        if (inst instanceof rx_1.Rx)
            inst.dispose();
        delete Injection._instances[key];
    }
    /**
     * Deletes all instances of dependencies from the manager.
     */
    static deleteAll() {
        const keys = Object.keys(Injection._instances);
        for (const key of keys) {
            Injection.delete({ key: key, force: true });
        }
        Injection._instances = {};
    }
    /**
     * Activates the Super framework.
     *
     * @param testMode Specifies whether the framework is in test mode.
     * @param autoDispose Specifies whether automatic disposal is enabled.
     * @param mocks Optional mocks to be used during testing.
     */
    static activate({ testMode, autoDispose, mocks, }) {
        Injection._scoped = true;
        Injection._testMode = testMode;
        Injection._autoDispose = autoDispose;
        if (mocks && mocks.length > 0) {
            Injection._mocks = [...mocks];
        }
    }
    /**
     * Deactivates the Super framework.
     */
    static deactivate() {
        Injection.deleteAll();
        Injection._scoped = false;
        Injection._testMode = false;
        Injection._autoDispose = undefined;
        Injection._mocks = [];
    }
}
exports.default = Injection;
Injection._instances = {};
Injection._mocks = [];
Injection._scoped = false;
Injection._testMode = false;
