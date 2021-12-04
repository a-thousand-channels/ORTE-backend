import type { Tween, UnknownProps } from './Tween';
/**
 * Controlling groups of tweens
 *
 * Using the TWEEN singleton to manage your tweens can cause issues in large apps with many components.
 * In these cases, you may want to create your own smaller groups of tween
 */
export default class Group {
    private _tweens;
    private _tweensAddedDuringUpdate;
    getAll(): Array<Tween<UnknownProps>>;
    removeAll(): void;
    add(tween: Tween<UnknownProps>): void;
    remove(tween: Tween<UnknownProps>): void;
    update(time?: number, preserve?: boolean): boolean;
}
