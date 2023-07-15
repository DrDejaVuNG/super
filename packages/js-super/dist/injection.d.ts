/**
 * A class that manages the instances of dependencies.
 */
export default class Injection {
    private static _instances;
    private static _mocks;
    private static _scoped;
    private static _testMode;
    private static _autoDispose;
    /**
     * Checks the scoped state of the framework.
     */
    static get scoped(): boolean;
    /**
     * Creates a singleton instance of a dependency and registers it
     * with the manager.
     *
     * @param instance The instance of the dependency to be registered.
     * @param key The key used to identify the dependency.
     */
    static create<T>({ instance, key }: {
        instance: T;
        key: string;
    }): void;
    /**
     * Retrieves the instance of a dependency from the manager.
     *
     * @param key The key used to identify the dependency.
     * @returns The instance of the dependency.
     * @throws An error if the dependency cannot be found.
     */
    static of<T>(key: string): T;
    /**
     * Initializes and retrieves the instance of a dependency,
     * or creates a new instance if it doesn't exist.
     *
     * @param instance The instance of the dependency to be initialized.
     * @param key The key used to identify the dependency.
     * @returns The instance of the dependency.
     */
    static init<T>({ instance, key }: {
        instance: T;
        key: string;
    }): T;
    private static _register;
    private static _registerMock;
    /**
     * Deletes the instance of a dependency from the manager.
     *
     * @param key The key used to identify the dependency.
     * @param force Specifies whether to force deletion even when autoDispose is disabled.
     */
    static delete({ key, force }: {
        key: string;
        force?: boolean;
    }): void;
    /**
     * Deletes all instances of dependencies from the manager.
     */
    static deleteAll(): void;
    /**
     * Activates the Super framework.
     *
     * @param testMode Specifies whether the framework is in test mode.
     * @param autoDispose Specifies whether automatic disposal is enabled.
     * @param mocks Optional mocks to be used during testing.
     */
    static activate({ testMode, autoDispose, mocks, }: {
        testMode: boolean;
        autoDispose: boolean;
        mocks?: any[];
    }): void;
    /**
     * Deactivates the Super framework.
     */
    static deactivate(): void;
}
