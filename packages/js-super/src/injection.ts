import { Rx } from "./rx/rx";
import SuperController from "./controller";

/**
 * A class that manages the instances of dependencies.
 */
export default class Injection {
  private static _instances: { [key: string]: any } = {};
  private static _mocks: any[] = [];
  private static _scoped = false;
  private static _testMode = false;
  private static _autoDispose: boolean | undefined;

  /**
   * Checks the scoped state of the framework.
   */
  public static get scoped(): boolean {
    return Injection._scoped;
  }

  /**
   * Creates a singleton instance of a dependency and registers it
   * with the manager.
   *
   * @param instance The instance of the dependency to be registered.
   * @param key The key used to identify the dependency.
   */
  public static create<T>({ instance, key }: { instance: T; key: string }): void {
    if (!Injection._scoped) {
      throw new Error(
        'SuperApp not found, Wrap the App component with [SuperApp] ' +
        'to enable the Super framework, i.e <SuperApp><App /></SuperApp>.'
      );
    }
    Injection._register<T>({ instance, key });
  }

  /**
   * Retrieves the instance of a dependency from the manager.
   *
   * @param key The key used to identify the dependency.
   * @returns The instance of the dependency.
   * @throws An error if the dependency cannot be found.
   */
  public static of<T>(key: string): T {
    if (key in Injection._instances) {
      let inst: T = Injection._instances[key];

      if (inst instanceof SuperController) inst.enable();

      return inst;
    }
    throw new Error(
      `Failed to retrieve ${key} dependency. ` +
        `Call "Super.init({ instance: Dependency(), key: ${key} })" instead.`
    );
  }

  /**
   * Initializes and retrieves the instance of a dependency,
   * or creates a new instance if it doesn't exist.
   *
   * @param instance The instance of the dependency to be initialized.
   * @param key The key used to identify the dependency.
   * @returns The instance of the dependency.
   */
  public static init<T>({ instance, key }: { instance: T; key: string }): T {
    try {
      return Injection.of<T>(key);
    } catch (e) {
      Injection.create<T>({ instance, key });
      return Injection.of<T>(key);
    }
  }

  private static _register<T>({ instance, key }: { instance: T; key: string }): void {
    if (Injection._testMode && Injection._mocks.length > 0) {
      for (const item of Injection._mocks) {
        const mock = Injection._registerMock<T>(item);
        if (mock !== null) {
          Injection._instances[key] = mock;
          return;
        }
      }
    }
    Injection._instances[key] = instance;
  }

  private static _registerMock<T>(mock: any): T | null {
    try {
      return mock as T;
    } catch (e) {
      return null;
    }
  }

  /**
   * Deletes the instance of a dependency from the manager.
   *
   * @param key The key used to identify the dependency.
   * @param force Specifies whether to force deletion even when autoDispose is disabled.
   */
  public static delete({ key, force = false }: { key: string; force?: boolean }): void {
    if (Injection._autoDispose !== undefined && !Injection._autoDispose && !force) {
      return;
    }
    
    if (!(key in Injection._instances)) {
      return;
    }
    const inst = Injection._instances[key];

    if (inst instanceof SuperController) inst.disable();
    if (inst instanceof Rx) inst.dispose();

    delete Injection._instances[key];
  }

  /**
   * Deletes all instances of dependencies from the manager.
   */
  public static deleteAll(): void {
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
  public static activate({
    testMode,
    autoDispose,
    mocks,
  }: {
    testMode: boolean;
    autoDispose: boolean;
    mocks?: any[];
  }): void {
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
  public static deactivate(): void {
    Injection.deleteAll();
    Injection._scoped = false;
    Injection._testMode = false;
    Injection._autoDispose = undefined;
    Injection._mocks = [];
  }
}