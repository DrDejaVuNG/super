"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
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
class SuperModel {
    /**
     * Checks if the current instance is equal to the given `other` object.
     *
     * @param other The object to compare for equality.
     * @returns `true` if the objects are equal, `false` otherwise.
     */
    equals(other) {
        return this.toString() === other.toString();
    }
    /**
     * Returns a string representation of the current instance.
     */
    toString() {
        return `${this.constructor.name}(${this.props})`;
    }
}
exports.default = SuperModel;
