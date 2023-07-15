
/**
 * A class that provides value equality checking for classes.
 * 
 * Classes that extend this class should implement the `props` getter, which 
 * returns a list of the class properties that should be used for equality 
 * checking.
 * 
 * Example usage:
 *
 * ```ts
 * class UserModel extends SuperModel {
 *   constructor(public id: number, public name: string) {
 *     super();
 *   }
 *
 *   get props(): Object[] {
 *     return [this.id, this.name];
 *   }
 * }
 * ```
 */
abstract class SuperModel {
    /**
     * Contains the class properties used for equality checking.
     *
     * Subclasses must override this getter and provide a list of properties
     * that should be used for equality checking.
     */
    abstract get props(): Array<Object | null>;
  
    /**
     * Checks if the current instance is equal to the given `other` object.
     *
     * @param other The object to compare for equality.
     * @returns `true` if the objects are equal, `false` otherwise.
     */
    equals(other: any): boolean {
      return this.toString() === other.toString();
    }
    
    /**
     * Returns a string representation of the current instance.
     */
    toString(): string {
      return `${this.constructor.name}(${this.props})`;
    }
}
 
export default SuperModel;