import { Rx } from './index';
/**
 * Custom hook for synchronizing the state of an Rx object with a React component's local state.
 * @template T The type of the state.
 * @param {Rx<T>} rx The Rx object to synchronize with.
 * @returns {T} The synchronized state value.
 */
declare function useState<T extends Object>(rx: Rx<T>): T;
export default useState;
