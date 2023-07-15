import React from 'react';
import useState from './use_state';
import { RxListener } from './index';

/**
 * A React component that subscribes to the Rx object(s) used inside it 
 * and renders its children whenever the state changes.
 * @param children A function that returns the rendered content.
 * @returns The rendered component.
 */
function SuperX({ children }: {children: () => React.JSX.Element }) {
  RxListener.listen();  
  children();
  const rx = RxListener.listenedRx();
  useState(rx);

  return (
    <div>
      {children()}
    </div>
  );
}

export default SuperX;
