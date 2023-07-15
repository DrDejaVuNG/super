import React from 'react';
/**
 * A React component that subscribes to the Rx object(s) used inside it
 * and renders its children whenever the state changes.
 * @param children A function that returns the rendered content.
 * @returns The rendered component.
 */
declare function SuperX({ children }: {
    children: () => React.JSX.Element;
}): React.JSX.Element;
export default SuperX;
