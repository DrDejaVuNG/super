import React from 'react';
import { Rx } from './index';
import useState from './use_state';

/**
 * Props for the SuperDiv component.
 * @template T The type of the state value.
 */
interface SuperDivProps<T extends Object> {
  /**
   * The Rx object representing the state.
   */
  rx: Rx<T>; 
  /**
   * A function that receives the state value and returns the rendered content.
   * @param state The current state value.
   * @returns The rendered content.
   */
  children: (state: T) => React.JSX.Element;
}
  
/**
 * A React component that subscribes to an Rx object and renders its children
 * whenever the state changes.
 * @template T The type of the state value.
 * @param {SuperDivProps<T>} props The component props.
 * @returns The rendered component.
 */
function SuperDiv<T extends Object>({ rx, children }: SuperDivProps<T>) {
  const state = useState(rx);

  return (
    <div>
      {children(state)}
    </div>
  );
}

export default SuperDiv;
