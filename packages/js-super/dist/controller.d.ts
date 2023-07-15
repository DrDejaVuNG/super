/**
 * A base class for controllers in the Super framework.
 *
 * The `SuperController` class provides a lifecycle for controllers used
 * in the application. Controllers are responsible for managing the state
 * and behavior of specific components or features.
 *
 * To create a custom controller, extend this class and override the
 * lifecycle methods as needed.
 */
export default class SuperController {
    private _alive;
    /**
     * Indicates whether the controller is currently active (alive).
     */
    get alive(): boolean;
    /**
     * Activates the controller.
     *
     * This method initializes the controller and sets it to the active state.
     * It should be called when the controller is first used or needed.
     * Once activated, the controller can perform initialization tasks and
     * respond to changes or events.
     */
    enable(): void;
    /**
     * Deactivates the controller.
     *
     * This method marks the controller as inactive (disabled) and performs
     * any necessary cleanup tasks. It should be called when the controller
     * is no longer needed or should be terminated.
     */
    disable(): void;
    /**
     * Lifecycle method called when the controller is enabled.
     *
     * This method is called when the controller is first enabled (activated).
     * It can be used to perform initialization tasks, set up listeners,
     * and perform other setup operations. Override this method in the
     * subclass to define the behavior for the controller when enabled.
     */
    protected onEnable(): void;
    /**
     * Lifecycle method called when the controller is alive.
     *
     * This method is called after the `onEnable` method, in the next frame.
     * It is a safe place to handle route events, show notifications,
     * perform asynchronous operations, or any other actions that should
     * be executed when the controller is active.
     * Override this method in the subclass to define the behavior
     * for the controller while it is active.
     */
    protected onAlive(): void;
    /**
     * Lifecycle method called when the controller is disabled.
     *
     * This method is called when the controller is disabled (deactivated)
     * or no longer needed. It can be used to dispose of resources,
     * perform cleanup tasks, or persist data.
     * Override this method in the subclass to define the behavior
     * for the controller when disabled.
     */
    protected onDisable(): void;
    /**
     * Returns a string representation of the controller.
     *
     * This method returns the name of the controller's constructor.
     * It can be overridden in the subclass to provide a custom string
     * representation if needed.
     *
     * @returns The string representation of the controller.
     */
    toString(): string;
}
