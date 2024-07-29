/**
 * Tween.js - Licensed under the MIT license
 * https://github.com/tweenjs/tween.js
 * ----------------------------------------------
 *
 * See https://github.com/tweenjs/tween.js/graphs/contributors for the full list of contributors.
 * Thank you all, you're awesome!
 */
import Easing from './Easing';
import Group from './Group';
import Interpolation from './Interpolation';
import now from './Now';
import Sequence from './Sequence';
import Tween from './Tween';
import VERSION from './Version';
declare const nextId: typeof Sequence.nextId;
declare const getAll: () => Tween<Record<string, any>>[];
declare const removeAll: () => void;
declare const add: (tween: Tween<Record<string, any>>) => void;
declare const remove: (tween: Tween<Record<string, any>>) => void;
declare const update: (time?: number, preserve?: boolean) => boolean;
export { Easing, Group, Interpolation, now, Sequence, nextId, Tween, VERSION, getAll, removeAll, add, remove, update };
declare const exports: {
    Easing: {
        Linear: {
            None: (amount: number) => number;
        };
        Quadratic: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Cubic: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Quartic: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Quintic: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Sinusoidal: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Exponential: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Circular: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Elastic: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Back: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
        Bounce: {
            In: (amount: number) => number;
            Out: (amount: number) => number;
            InOut: (amount: number) => number;
        };
    };
    Group: typeof Group;
    Interpolation: {
        Linear: (v: number[], k: number) => number;
        Bezier: (v: number[], k: number) => number;
        CatmullRom: (v: number[], k: number) => number;
        Utils: {
            Linear: (p0: number, p1: number, t: number) => number;
            Bernstein: (n: number, i: number) => number;
            Factorial: (n: number) => number;
            CatmullRom: (p0: number, p1: number, p2: number, p3: number, t: number) => number;
        };
    };
    now: () => number;
    Sequence: typeof Sequence;
    nextId: typeof Sequence.nextId;
    Tween: typeof Tween;
    VERSION: string;
    getAll: () => Tween<Record<string, any>>[];
    removeAll: () => void;
    add: (tween: Tween<Record<string, any>>) => void;
    remove: (tween: Tween<Record<string, any>>) => void;
    update: (time?: number, preserve?: boolean) => boolean;
};
export default exports;
