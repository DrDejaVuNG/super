import { SuperController } from './index';
/**
 * Custom hook for initializing and managing a SuperController instance.
 * @template T The type of the SuperController instance.
 * @param {T} controller The SuperController instance.
 * @returns {T} The initialized and managed SuperController instance.
 */
export default function useController<T extends SuperController>(controller: T): T;
