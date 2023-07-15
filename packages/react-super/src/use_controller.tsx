import { Super } from './index';
import { useEffect } from 'react';
import { SuperController } from './index';

/**
 * Custom hook for initializing and managing a SuperController instance.
 * @template T The type of the SuperController instance.
 * @param {T} controller The SuperController instance.
 * @returns {T} The initialized and managed SuperController instance.
 */
export default function useController<T extends SuperController>(
  controller: T,
): T {
  const sController = Super.init<T>(controller);

  useEffect(() => {
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
