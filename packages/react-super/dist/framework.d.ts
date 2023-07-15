import React from 'react';
/**
 * Props for the SuperApp component.
 */
interface SuperAppProps {
    /**
     * Determines whether the SuperApp is running in test mode.
     */
    testMode?: boolean;
    /**
     * Determines whether the SuperApp automatically disposes resources.
     */
    autoDispose?: boolean;
    /**
     * Optional array of mocks for dependency injection.
     */
    mocks?: any[];
    /**
     * The child components to be rendered within the SuperApp.
     */
    children: React.JSX.Element;
}
/**
 * A component that activates and deactivates the Super framework.
 *
 * The SuperApp component should be placed at the root of your application
 * to enable the Super framework and configure its behavior.
 *
 * @param props The props for the SuperApp component.
 * @returns The rendered SuperApp component.
 */
export default function SuperApp({ mocks, testMode, autoDispose, children }: SuperAppProps): React.JSX.Element;
export {};
