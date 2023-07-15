import Injection from "../injection";

/**
 * SuperInterface provides a simplified interface for interacting with the Injection class.
 */
class SuperInterface {
  /**
   * Creates a singleton instance of a dependency and registers it with the manager.
   *
   * @param instance The instance of the dependency to be registered.
   */
  create<T extends Object>(inst: T): void {
    return Injection.create<T>({ instance: inst, key: inst.constructor.name });
  }

  /**
   * Retrieves the instance of a dependency from the manager.
   * 
   * **Note** The key of is the name of the dependency.
   *
   * @param key The key used to identify the dependency.
   * @returns The instance of the dependency.
   */
  of<T>(key: string): T {
    return Injection.of<T>(key);
  }

  /**
   * Initializes and retrieves the instance of a dependency, or creates a new instance if it doesn't exist.
   *
   * @param instance The instance of the dependency to be initialized.
   * @returns The instance of the dependency.
   */
  init<T extends Object>(inst: T): T {
    return Injection.init<T>({ instance: inst, key: inst.constructor.name });
  }

  /**
   * Deletes the instance of a dependency from the manager.
   * 
   * **Note** The key of is the name of the dependency.
   *
   * @param key The key used to identify the dependency.
   */
  delete(key: string): void {
    return Injection.delete({ key, force: true });
  }

  /**
   * Deletes all instances of dependencies from the manager.
   */
  deleteAll(): void {
    return Injection.deleteAll();
  }

  /**
   * Activates the Super framework.
   *
   * @param testMode Specifies whether the framework is in test mode.
   * @param autoDispose Specifies whether automatic disposal is enabled.
   * @param mocks Optional mocks to be used during testing.
   */
  activate({
    testMode,
    autoDispose,
    mocks,
  }: {
    testMode: boolean;
    autoDispose: boolean;
    mocks?: any[];
  }): void {
    return Injection.activate({ testMode, autoDispose, mocks });
  }

  /**
   * Deactivates the Super framework.
   */
  deactivate(): void {
    return Injection.deactivate();
  }
}

export const Super = new SuperInterface();
