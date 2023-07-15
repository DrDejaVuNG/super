import { Rx } from './index';
import { useState as useValue, useEffect } from 'react';

/**
 * Custom hook for synchronizing the state of an Rx object with a React component's local state.
 * @template T The type of the state.
 * @param {Rx<T>} rx The Rx object to synchronize with.
 * @returns {T} The synchronized state value.
 */
function useState<T extends Object>(rx: Rx<T>): T {
  const [state, setState] = useValue(rx.state);

  useEffect(() => {
    /**
     * Listener function that updates the component state
     * whenever the Rx object's state changes.
     */
    const listener = () => {
      setState(rx.state);
    };

    rx.addListener(listener);

    return () => {
      /**
       * Removes the listener when the component unmounts to prevent memory leaks.
       */
      rx.removeListener(listener);
    };
  }, [rx]);

  return state;
}

export default useState;
