'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

/**
 * The Ease class provides a collection of easing functions for use with tween.js.
 */
var Easing = {
    Linear: {
        None: function (amount) {
            return amount;
        },
    },
    Quadratic: {
        In: function (amount) {
            return amount * amount;
        },
        Out: function (amount) {
            return amount * (2 - amount);
        },
        InOut: function (amount) {
            if ((amount *= 2) < 1) {
                return 0.5 * amount * amount;
            }
            return -0.5 * (--amount * (amount - 2) - 1);
        },
    },
    Cubic: {
        In: function (amount) {
            return amount * amount * amount;
        },
        Out: function (amount) {
            return --amount * amount * amount + 1;
        },
        InOut: function (amount) {
            if ((amount *= 2) < 1) {
                return 0.5 * amount * amount * amount;
            }
            return 0.5 * ((amount -= 2) * amount * amount + 2);
        },
    },
    Quartic: {
        In: function (amount) {
            return amount * amount * amount * amount;
        },
        Out: function (amount) {
            return 1 - --amount * amount * amount * amount;
        },
        InOut: function (amount) {
            if ((amount *= 2) < 1) {
                return 0.5 * amount * amount * amount * amount;
            }
            return -0.5 * ((amount -= 2) * amount * amount * amount - 2);
        },
    },
    Quintic: {
        In: function (amount) {
            return amount * amount * amount * amount * amount;
        },
        Out: function (amount) {
            return --amount * amount * amount * amount * amount + 1;
        },
        InOut: function (amount) {
            if ((amount *= 2) < 1) {
                return 0.5 * amount * amount * amount * amount * amount;
            }
            return 0.5 * ((amount -= 2) * amount * amount * amount * amount + 2);
        },
    },
    Sinusoidal: {
        In: function (amount) {
            return 1 - Math.cos((amount * Math.PI) / 2);
        },
        Out: function (amount) {
            return Math.sin((amount * Math.PI) / 2);
        },
        InOut: function (amount) {
            return 0.5 * (1 - Math.cos(Math.PI * amount));
        },
    },
    Exponential: {
        In: function (amount) {
            return amount === 0 ? 0 : Math.pow(1024, amount - 1);
        },
        Out: function (amount) {
            return amount === 1 ? 1 : 1 - Math.pow(2, -10 * amount);
        },
        InOut: function (amount) {
            if (amount === 0) {
                return 0;
            }
            if (amount === 1) {
                return 1;
            }
            if ((amount *= 2) < 1) {
                return 0.5 * Math.pow(1024, amount - 1);
            }
            return 0.5 * (-Math.pow(2, -10 * (amount - 1)) + 2);
        },
    },
    Circular: {
        In: function (amount) {
            return 1 - Math.sqrt(1 - amount * amount);
        },
        Out: function (amount) {
            return Math.sqrt(1 - --amount * amount);
        },
        InOut: function (amount) {
            if ((amount *= 2) < 1) {
                return -0.5 * (Math.sqrt(1 - amount * amount) - 1);
            }
            return 0.5 * (Math.sqrt(1 - (amount -= 2) * amount) + 1);
        },
    },
    Elastic: {
        In: function (amount) {
            if (amount === 0) {
                return 0;
            }
            if (amount === 1) {
                return 1;
            }
            return -Math.pow(2, 10 * (amount - 1)) * Math.sin((amount - 1.1) * 5 * Math.PI);
        },
        Out: function (amount) {
            if (amount === 0) {
                return 0;
            }
            if (amount === 1) {
                return 1;
            }
            return Math.pow(2, -10 * amount) * Math.sin((amount - 0.1) * 5 * Math.PI) + 1;
        },
        InOut: function (amount) {
            if (amount === 0) {
                return 0;
            }
            if (amount === 1) {
                return 1;
            }
            amount *= 2;
            if (amount < 1) {
                return -0.5 * Math.pow(2, 10 * (amount - 1)) * Math.sin((amount - 1.1) * 5 * Math.PI);
            }
            return 0.5 * Math.pow(2, -10 * (amount - 1)) * Math.sin((amount - 1.1) * 5 * Math.PI) + 1;
        },
    },
    Back: {
        In: function (amount) {
            var s = 1.70158;
            return amount * amount * ((s + 1) * amount - s);
        },
        Out: function (amount) {
            var s = 1.70158;
            return --amount * amount * ((s + 1) * amount + s) + 1;
        },
        InOut: function (amount) {
            var s = 1.70158 * 1.525;
            if ((amount *= 2) < 1) {
                return 0.5 * (amount * amount * ((s + 1) * amount - s));
            }
            return 0.5 * ((amount -= 2) * amount * ((s + 1) * amount + s) + 2);
        },
    },
    Bounce: {
        In: function (amount) {
            return 1 - Easing.Bounce.Out(1 - amount);
        },
        Out: function (amount) {
            if (amount < 1 / 2.75) {
                return 7.5625 * amount * amount;
            }
            else if (amount < 2 / 2.75) {
                return 7.5625 * (amount -= 1.5 / 2.75) * amount + 0.75;
            }
            else if (amount < 2.5 / 2.75) {
                return 7.5625 * (amount -= 2.25 / 2.75) * amount + 0.9375;
            }
            else {
                return 7.5625 * (amount -= 2.625 / 2.75) * amount + 0.984375;
            }
        },
        InOut: function (amount) {
            if (amount < 0.5) {
                return Easing.Bounce.In(amount * 2) * 0.5;
            }
            return Easing.Bounce.Out(amount * 2 - 1) * 0.5 + 0.5;
        },
    },
};

var now;
// Include a performance.now polyfill.
// In node.js, use process.hrtime.
// eslint-disable-next-line
// @ts-ignore
if (typeof self === 'undefined' && typeof process !== 'undefined' && process.hrtime) {
    now = function () {
        // eslint-disable-next-line
        // @ts-ignore
        var time = process.hrtime();
        // Convert [seconds, nanoseconds] to milliseconds.
        return time[0] * 1000 + time[1] / 1000000;
    };
}
// In a browser, use self.performance.now if it is available.
else if (typeof self !== 'undefined' && self.performance !== undefined && self.performance.now !== undefined) {
    // This must be bound, because directly assigning this function
    // leads to an invocation exception in Chrome.
    now = self.performance.now.bind(self.performance);
}
// Use Date.now if it is available.
else if (Date.now !== undefined) {
    now = Date.now;
}
// Otherwise, use 'new Date().getTime()'.
else {
    now = function () {
        return new Date().getTime();
    };
}
var now$1 = now;

/**
 * Controlling groups of tweens
 *
 * Using the TWEEN singleton to manage your tweens can cause issues in large apps with many components.
 * In these cases, you may want to create your own smaller groups of tween
 */
var Group = /** @class */ (function () {
    function Group() {
        this._tweens = {};
        this._tweensAddedDuringUpdate = {};
    }
    Group.prototype.getAll = function () {
        var _this = this;
        return Object.keys(this._tweens).map(function (tweenId) {
            return _this._tweens[tweenId];
        });
    };
    Group.prototype.removeAll = function () {
        this._tweens = {};
    };
    Group.prototype.add = function (tween) {
        this._tweens[tween.getId()] = tween;
        this._tweensAddedDuringUpdate[tween.getId()] = tween;
    };
    Group.prototype.remove = function (tween) {
        delete this._tweens[tween.getId()];
        delete this._tweensAddedDuringUpdate[tween.getId()];
    };
    Group.prototype.update = function (time, preserve) {
        if (time === void 0) { time = now$1(); }
        if (preserve === void 0) { preserve = false; }
        var tweenIds = Object.keys(this._tweens);
        if (tweenIds.length === 0) {
            return false;
        }
        // Tweens are updated in "batches". If you add a new tween during an
        // update, then the new tween will be updated in the next batch.
        // If you remove a tween during an update, it may or may not be updated.
        // However, if the removed tween was added during the current batch,
        // then it will not be updated.
        while (tweenIds.length > 0) {
            this._tweensAddedDuringUpdate = {};
            for (var i = 0; i < tweenIds.length; i++) {
                var tween = this._tweens[tweenIds[i]];
                var autoStart = !preserve;
                if (tween && tween.update(time, autoStart) === false && !preserve) {
                    delete this._tweens[tweenIds[i]];
                }
            }
            tweenIds = Object.keys(this._tweensAddedDuringUpdate);
        }
        return true;
    };
    return Group;
}());

/**
 *
 */
var Interpolation = {
    Linear: function (v, k) {
        var m = v.length - 1;
        var f = m * k;
        var i = Math.floor(f);
        var fn = Interpolation.Utils.Linear;
        if (k < 0) {
            return fn(v[0], v[1], f);
        }
        if (k > 1) {
            return fn(v[m], v[m - 1], m - f);
        }
        return fn(v[i], v[i + 1 > m ? m : i + 1], f - i);
    },
    Bezier: function (v, k) {
        var b = 0;
        var n = v.length - 1;
        var pw = Math.pow;
        var bn = Interpolation.Utils.Bernstein;
        for (var i = 0; i <= n; i++) {
            b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i);
        }
        return b;
    },
    CatmullRom: function (v, k) {
        var m = v.length - 1;
        var f = m * k;
        var i = Math.floor(f);
        var fn = Interpolation.Utils.CatmullRom;
        if (v[0] === v[m]) {
            if (k < 0) {
                i = Math.floor((f = m * (1 + k)));
            }
            return fn(v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i);
        }
        else {
            if (k < 0) {
                return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0]);
            }
            if (k > 1) {
                return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m]);
            }
            return fn(v[i ? i - 1 : 0], v[i], v[m < i + 1 ? m : i + 1], v[m < i + 2 ? m : i + 2], f - i);
        }
    },
    Utils: {
        Linear: function (p0, p1, t) {
            return (p1 - p0) * t + p0;
        },
        Bernstein: function (n, i) {
            var fc = Interpolation.Utils.Factorial;
            return fc(n) / fc(i) / fc(n - i);
        },
        Factorial: (function () {
            var a = [1];
            return function (n) {
                var s = 1;
                if (a[n]) {
                    return a[n];
                }
                for (var i = n; i > 1; i--) {
                    s *= i;
                }
                a[n] = s;
                return s;
            };
        })(),
        CatmullRom: function (p0, p1, p2, p3, t) {
            var v0 = (p2 - p0) * 0.5;
            var v1 = (p3 - p1) * 0.5;
            var t2 = t * t;
            var t3 = t * t2;
            return (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
        },
    },
};

/**
 * Utils
 */
var Sequence = /** @class */ (function () {
    function Sequence() {
    }
    Sequence.nextId = function () {
        return Sequence._nextId++;
    };
    Sequence._nextId = 0;
    return Sequence;
}());

var mainGroup = new Group();

/**
 * Tween.js - Licensed under the MIT license
 * https://github.com/tweenjs/tween.js
 * ----------------------------------------------
 *
 * See https://github.com/tweenjs/tween.js/graphs/contributors for the full list of contributors.
 * Thank you all, you're awesome!
 */
var Tween = /** @class */ (function () {
    function Tween(_object, _group) {
        if (_group === void 0) { _group = mainGroup; }
        this._object = _object;
        this._group = _group;
        this._isPaused = false;
        this._pauseStart = 0;
        this._valuesStart = {};
        this._valuesEnd = {};
        this._valuesStartRepeat = {};
        this._duration = 1000;
        this._initialRepeat = 0;
        this._repeat = 0;
        this._yoyo = false;
        this._isPlaying = false;
        this._reversed = false;
        this._delayTime = 0;
        this._startTime = 0;
        this._easingFunction = Easing.Linear.None;
        this._interpolationFunction = Interpolation.Linear;
        // eslint-disable-next-line
        this._chainedTweens = [];
        this._onStartCallbackFired = false;
        this._id = Sequence.nextId();
        this._isChainStopped = false;
        this._goToEnd = false;
    }
    Tween.prototype.getId = function () {
        return this._id;
    };
    Tween.prototype.isPlaying = function () {
        return this._isPlaying;
    };
    Tween.prototype.isPaused = function () {
        return this._isPaused;
    };
    Tween.prototype.to = function (properties, duration) {
        // TODO? restore this, then update the 07_dynamic_to example to set fox
        // tween's to on each update. That way the behavior is opt-in (there's
        // currently no opt-out).
        // for (const prop in properties) this._valuesEnd[prop] = properties[prop]
        this._valuesEnd = Object.create(properties);
        if (duration !== undefined) {
            this._duration = duration;
        }
        return this;
    };
    Tween.prototype.duration = function (d) {
        if (d === void 0) { d = 1000; }
        this._duration = d;
        return this;
    };
    Tween.prototype.start = function (time) {
        if (this._isPlaying) {
            return this;
        }
        // eslint-disable-next-line
        this._group && this._group.add(this);
        this._repeat = this._initialRepeat;
        if (this._reversed) {
            // If we were reversed (f.e. using the yoyo feature) then we need to
            // flip the tween direction back to forward.
            this._reversed = false;
            for (var property in this._valuesStartRepeat) {
                this._swapEndStartRepeatValues(property);
                this._valuesStart[property] = this._valuesStartRepeat[property];
            }
        }
        this._isPlaying = true;
        this._isPaused = false;
        this._onStartCallbackFired = false;
        this._isChainStopped = false;
        this._startTime = time !== undefined ? (typeof time === 'string' ? now$1() + parseFloat(time) : time) : now$1();
        this._startTime += this._delayTime;
        this._setupProperties(this._object, this._valuesStart, this._valuesEnd, this._valuesStartRepeat);
        return this;
    };
    Tween.prototype._setupProperties = function (_object, _valuesStart, _valuesEnd, _valuesStartRepeat) {
        for (var property in _valuesEnd) {
            var startValue = _object[property];
            var startValueIsArray = Array.isArray(startValue);
            var propType = startValueIsArray ? 'array' : typeof startValue;
            var isInterpolationList = !startValueIsArray && Array.isArray(_valuesEnd[property]);
            // If `to()` specifies a property that doesn't exist in the source object,
            // we should not set that property in the object
            if (propType === 'undefined' || propType === 'function') {
                continue;
            }
            // Check if an Array was provided as property value
            if (isInterpolationList) {
                var endValues = _valuesEnd[property];
                if (endValues.length === 0) {
                    continue;
                }
                // handle an array of relative values
                endValues = endValues.map(this._handleRelativeValue.bind(this, startValue));
                // Create a local copy of the Array with the start value at the front
                _valuesEnd[property] = [startValue].concat(endValues);
            }
            // handle the deepness of the values
            if ((propType === 'object' || startValueIsArray) && startValue && !isInterpolationList) {
                _valuesStart[property] = startValueIsArray ? [] : {};
                // eslint-disable-next-line
                for (var prop in startValue) {
                    // eslint-disable-next-line
                    // @ts-ignore FIXME?
                    _valuesStart[property][prop] = startValue[prop];
                }
                _valuesStartRepeat[property] = startValueIsArray ? [] : {}; // TODO? repeat nested values? And yoyo? And array values?
                // eslint-disable-next-line
                // @ts-ignore FIXME?
                this._setupProperties(startValue, _valuesStart[property], _valuesEnd[property], _valuesStartRepeat[property]);
            }
            else {
                // Save the starting value, but only once.
                if (typeof _valuesStart[property] === 'undefined') {
                    _valuesStart[property] = startValue;
                }
                if (!startValueIsArray) {
                    // eslint-disable-next-line
                    // @ts-ignore FIXME?
                    _valuesStart[property] *= 1.0; // Ensures we're using numbers, not strings
                }
                if (isInterpolationList) {
                    // eslint-disable-next-line
                    // @ts-ignore FIXME?
                    _valuesStartRepeat[property] = _valuesEnd[property].slice().reverse();
                }
                else {
                    _valuesStartRepeat[property] = _valuesStart[property] || 0;
                }
            }
        }
    };
    Tween.prototype.stop = function () {
        if (!this._isChainStopped) {
            this._isChainStopped = true;
            this.stopChainedTweens();
        }
        if (!this._isPlaying) {
            return this;
        }
        // eslint-disable-next-line
        this._group && this._group.remove(this);
        this._isPlaying = false;
        this._isPaused = false;
        if (this._onStopCallback) {
            this._onStopCallback(this._object);
        }
        return this;
    };
    Tween.prototype.end = function () {
        this._goToEnd = true;
        this.update(Infinity);
        return this;
    };
    Tween.prototype.pause = function (time) {
        if (time === void 0) { time = now$1(); }
        if (this._isPaused || !this._isPlaying) {
            return this;
        }
        this._isPaused = true;
        this._pauseStart = time;
        // eslint-disable-next-line
        this._group && this._group.remove(this);
        return this;
    };
    Tween.prototype.resume = function (time) {
        if (time === void 0) { time = now$1(); }
        if (!this._isPaused || !this._isPlaying) {
            return this;
        }
        this._isPaused = false;
        this._startTime += time - this._pauseStart;
        this._pauseStart = 0;
        // eslint-disable-next-line
        this._group && this._group.add(this);
        return this;
    };
    Tween.prototype.stopChainedTweens = function () {
        for (var i = 0, numChainedTweens = this._chainedTweens.length; i < numChainedTweens; i++) {
            this._chainedTweens[i].stop();
        }
        return this;
    };
    Tween.prototype.group = function (group) {
        if (group === void 0) { group = mainGroup; }
        this._group = group;
        return this;
    };
    Tween.prototype.delay = function (amount) {
        if (amount === void 0) { amount = 0; }
        this._delayTime = amount;
        return this;
    };
    Tween.prototype.repeat = function (times) {
        if (times === void 0) { times = 0; }
        this._initialRepeat = times;
        this._repeat = times;
        return this;
    };
    Tween.prototype.repeatDelay = function (amount) {
        this._repeatDelayTime = amount;
        return this;
    };
    Tween.prototype.yoyo = function (yoyo) {
        if (yoyo === void 0) { yoyo = false; }
        this._yoyo = yoyo;
        return this;
    };
    Tween.prototype.easing = function (easingFunction) {
        if (easingFunction === void 0) { easingFunction = Easing.Linear.None; }
        this._easingFunction = easingFunction;
        return this;
    };
    Tween.prototype.interpolation = function (interpolationFunction) {
        if (interpolationFunction === void 0) { interpolationFunction = Interpolation.Linear; }
        this._interpolationFunction = interpolationFunction;
        return this;
    };
    // eslint-disable-next-line
    Tween.prototype.chain = function () {
        var tweens = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            tweens[_i] = arguments[_i];
        }
        this._chainedTweens = tweens;
        return this;
    };
    Tween.prototype.onStart = function (callback) {
        this._onStartCallback = callback;
        return this;
    };
    Tween.prototype.onUpdate = function (callback) {
        this._onUpdateCallback = callback;
        return this;
    };
    Tween.prototype.onRepeat = function (callback) {
        this._onRepeatCallback = callback;
        return this;
    };
    Tween.prototype.onComplete = function (callback) {
        this._onCompleteCallback = callback;
        return this;
    };
    Tween.prototype.onStop = function (callback) {
        this._onStopCallback = callback;
        return this;
    };
    /**
     * @returns true if the tween is still playing after the update, false
     * otherwise (calling update on a paused tween still returns true because
     * it is still playing, just paused).
     */
    Tween.prototype.update = function (time, autoStart) {
        if (time === void 0) { time = now$1(); }
        if (autoStart === void 0) { autoStart = true; }
        if (this._isPaused)
            return true;
        var property;
        var elapsed;
        var endTime = this._startTime + this._duration;
        if (!this._goToEnd && !this._isPlaying) {
            if (time > endTime)
                return false;
            if (autoStart)
                this.start(time);
        }
        this._goToEnd = false;
        if (time < this._startTime) {
            return true;
        }
        if (this._onStartCallbackFired === false) {
            if (this._onStartCallback) {
                this._onStartCallback(this._object);
            }
            this._onStartCallbackFired = true;
        }
        elapsed = (time - this._startTime) / this._duration;
        elapsed = this._duration === 0 || elapsed > 1 ? 1 : elapsed;
        var value = this._easingFunction(elapsed);
        // properties transformations
        this._updateProperties(this._object, this._valuesStart, this._valuesEnd, value);
        if (this._onUpdateCallback) {
            this._onUpdateCallback(this._object, elapsed);
        }
        if (elapsed === 1) {
            if (this._repeat > 0) {
                if (isFinite(this._repeat)) {
                    this._repeat--;
                }
                // Reassign starting values, restart by making startTime = now
                for (property in this._valuesStartRepeat) {
                    if (!this._yoyo && typeof this._valuesEnd[property] === 'string') {
                        this._valuesStartRepeat[property] =
                            // eslint-disable-next-line
                            // @ts-ignore FIXME?
                            this._valuesStartRepeat[property] + parseFloat(this._valuesEnd[property]);
                    }
                    if (this._yoyo) {
                        this._swapEndStartRepeatValues(property);
                    }
                    this._valuesStart[property] = this._valuesStartRepeat[property];
                }
                if (this._yoyo) {
                    this._reversed = !this._reversed;
                }
                if (this._repeatDelayTime !== undefined) {
                    this._startTime = time + this._repeatDelayTime;
                }
                else {
                    this._startTime = time + this._delayTime;
                }
                if (this._onRepeatCallback) {
                    this._onRepeatCallback(this._object);
                }
                return true;
            }
            else {
                if (this._onCompleteCallback) {
                    this._onCompleteCallback(this._object);
                }
                for (var i = 0, numChainedTweens = this._chainedTweens.length; i < numChainedTweens; i++) {
                    // Make the chained tweens start exactly at the time they should,
                    // even if the `update()` method was called way past the duration of the tween
                    this._chainedTweens[i].start(this._startTime + this._duration);
                }
                this._isPlaying = false;
                return false;
            }
        }
        return true;
    };
    Tween.prototype._updateProperties = function (_object, _valuesStart, _valuesEnd, value) {
        for (var property in _valuesEnd) {
            // Don't update properties that do not exist in the source object
            if (_valuesStart[property] === undefined) {
                continue;
            }
            var start = _valuesStart[property] || 0;
            var end = _valuesEnd[property];
            var startIsArray = Array.isArray(_object[property]);
            var endIsArray = Array.isArray(end);
            var isInterpolationList = !startIsArray && endIsArray;
            if (isInterpolationList) {
                _object[property] = this._interpolationFunction(end, value);
            }
            else if (typeof end === 'object' && end) {
                // eslint-disable-next-line
                // @ts-ignore FIXME?
                this._updateProperties(_object[property], start, end, value);
            }
            else {
                // Parses relative end values with start as base (e.g.: +10, -3)
                end = this._handleRelativeValue(start, end);
                // Protect against non numeric properties.
                if (typeof end === 'number') {
                    // eslint-disable-next-line
                    // @ts-ignore FIXME?
                    _object[property] = start + (end - start) * value;
                }
            }
        }
    };
    Tween.prototype._handleRelativeValue = function (start, end) {
        if (typeof end !== 'string') {
            return end;
        }
        if (end.charAt(0) === '+' || end.charAt(0) === '-') {
            return start + parseFloat(end);
        }
        else {
            return parseFloat(end);
        }
    };
    Tween.prototype._swapEndStartRepeatValues = function (property) {
        var tmp = this._valuesStartRepeat[property];
        var endValue = this._valuesEnd[property];
        if (typeof endValue === 'string') {
            this._valuesStartRepeat[property] = this._valuesStartRepeat[property] + parseFloat(endValue);
        }
        else {
            this._valuesStartRepeat[property] = this._valuesEnd[property];
        }
        this._valuesEnd[property] = tmp;
    };
    return Tween;
}());

var VERSION = '18.6.4';

/**
 * Tween.js - Licensed under the MIT license
 * https://github.com/tweenjs/tween.js
 * ----------------------------------------------
 *
 * See https://github.com/tweenjs/tween.js/graphs/contributors for the full list of contributors.
 * Thank you all, you're awesome!
 */
var nextId = Sequence.nextId;
/**
 * Controlling groups of tweens
 *
 * Using the TWEEN singleton to manage your tweens can cause issues in large apps with many components.
 * In these cases, you may want to create your own smaller groups of tweens.
 */
var TWEEN = mainGroup;
// This is the best way to export things in a way that's compatible with both ES
// Modules and CommonJS, without build hacks, and so as not to break the
// existing API.
// https://github.com/rollup/rollup/issues/1961#issuecomment-423037881
var getAll = TWEEN.getAll.bind(TWEEN);
var removeAll = TWEEN.removeAll.bind(TWEEN);
var add = TWEEN.add.bind(TWEEN);
var remove = TWEEN.remove.bind(TWEEN);
var update = TWEEN.update.bind(TWEEN);
var exports$1 = {
    Easing: Easing,
    Group: Group,
    Interpolation: Interpolation,
    now: now$1,
    Sequence: Sequence,
    nextId: nextId,
    Tween: Tween,
    VERSION: VERSION,
    getAll: getAll,
    removeAll: removeAll,
    add: add,
    remove: remove,
    update: update,
};

var TWEEN$1 = /*#__PURE__*/Object.freeze({
    __proto__: null,
    Easing: Easing,
    Group: Group,
    Interpolation: Interpolation,
    now: now$1,
    Sequence: Sequence,
    nextId: nextId,
    Tween: Tween,
    VERSION: VERSION,
    getAll: getAll,
    removeAll: removeAll,
    add: add,
    remove: remove,
    update: update,
    'default': exports$1
});

var tests = {
    hello: function (test) {
        test.ok(TWEEN$1 !== null);
        test.done();
    },
    // TWEEN tests
    'TWEEN.getAll': function (test) {
        test.ok(getAll() instanceof Array);
        test.done();
    },
    'TWEEN object stores tweens automatically on start': function (test) {
        var numTweensBefore = getAll().length, t = new Tween({});
        t.start();
        var numTweensAfter = getAll().length;
        test.equal(numTweensBefore + 1, numTweensAfter);
        test.done();
    },
    'TWEEN.removeAll()': function (test) {
        var t = new Tween({});
        removeAll();
        test.equal(getAll().length, 0, 'No tweens left');
        t.start();
        test.equal(getAll().length, 1, 'A tween has been added');
        removeAll();
        test.equal(getAll().length, 0, 'No tweens left');
        test.done();
    },
    'TWEEN.add()': function (test) {
        var all = getAll(), numTweens = all.length, t = new Tween({});
        add(t);
        test.equal(numTweens + 1, getAll().length);
        test.done();
    },
    'TWEEN.remove()': function (test) {
        var all = getAll(), numTweens = all.length, t = new Tween({});
        add(t);
        test.ok(getAll().indexOf(t) != -1);
        remove(t);
        test.equal(numTweens, getAll().length);
        test.equal(getAll().indexOf(t), -1);
        test.done();
    },
    'TWEEN.update() returns false when done (no tweens to animate)': function (test) {
        removeAll();
        test.deepEqual(update(), false);
        test.done();
    },
    'TWEEN.update() returns true when there are active tweens': function (test) {
        removeAll();
        var t = new Tween({});
        t.start();
        test.deepEqual(update(), true);
        test.done();
    },
    'TWEEN.update() removes tweens when they are finished': function (test) {
        removeAll();
        var t1 = new Tween({}).to({}, 1000), t2 = new Tween({}).to({}, 2000);
        test.equal(getAll().length, 0);
        t1.start(0);
        t2.start(0);
        test.equal(getAll().length, 2);
        update(0);
        test.equal(getAll().length, 2);
        update(999);
        test.equal(getAll().length, 2);
        update(1000);
        test.equal(getAll().length, 1);
        test.equal(getAll().indexOf(t1), -1);
        test.ok(getAll().indexOf(t2) != -1);
        test.done();
    },
    'TWEEN.update() does not remove tweens when they are finished with preserve flag': function (test) {
        removeAll();
        var t1 = new Tween({}).to({}, 1000), t2 = new Tween({}).to({}, 2000);
        test.equal(getAll().length, 0);
        t1.start(0);
        t2.start(0);
        test.equal(getAll().length, 2);
        update(0, true);
        test.equal(getAll().length, 2);
        update(999, true);
        test.equal(getAll().length, 2);
        update(1000, true);
        test.equal(getAll().length, 2);
        update(1001, true);
        test.equal(getAll().length, 2);
        test.ok(getAll().indexOf(t1) != -1);
        test.ok(getAll().indexOf(t2) != -1);
        test.done();
    },
    'Unremoved tweens which have been updated past their finish time may go backward in time': function (test) {
        removeAll();
        var target1 = { a: 0 };
        var target2 = { b: 0 };
        var t1 = new Tween(target1).to({ a: 1 }, 1000), t2 = new Tween(target2).to({ b: 1 }, 2000);
        t1.start(0);
        t2.start(0);
        // To be able to make a tween go backward in time, it must be
        // updated with preserve set to true. Otherwise, the
        // backward-in-time feature does not apply.
        update(200, true);
        update(2500, true);
        update(500, true);
        test.equal(getAll().length, 2);
        test.equal(target1.a, 0.5);
        test.equal(target2.b, 0.25);
        test.done();
    },
    // TWEEN.Tween tests
    constructor: function (test) {
        var t = new Tween({});
        test.ok(t instanceof Tween, 'Pass');
        test.done();
    },
    'Return the same tween instance for method chaining': function (test) {
        var t = new Tween({});
        test.ok(t.to({}, 0) instanceof Tween);
        test.equal(t.to({}, 0), t);
        test.ok(t.start() instanceof Tween);
        test.equal(t.start(), t);
        test.ok(t.stop() instanceof Tween);
        test.equal(t.stop(), t);
        test.ok(t.delay() instanceof Tween);
        test.equal(t.delay(), t);
        test.ok(t.easing() instanceof Tween);
        test.equal(t.easing(), t);
        test.ok(t.interpolation() instanceof Tween);
        test.equal(t.interpolation(), t);
        test.ok(t.chain() instanceof Tween);
        test.equal(t.chain(), t);
        test.ok(t.onStart() instanceof Tween);
        test.equal(t.onStart(), t);
        test.ok(t.onStop() instanceof Tween);
        test.equal(t.onStop(), t);
        test.ok(t.onUpdate() instanceof Tween);
        test.equal(t.onUpdate(), t);
        test.ok(t.onComplete() instanceof Tween);
        test.equal(t.onComplete(), t);
        test.ok(t.duration() instanceof Tween);
        test.equal(t.duration(), t);
        test.ok(t.group() instanceof Tween);
        test.equal(t.group(), t);
        test.done();
    },
    'Tween existing property': function (test) {
        var obj = { x: 1 }, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        t.start(0);
        t.update(1000);
        test.deepEqual(obj.x, 2);
        test.done();
    },
    'Tween non-existing property': function (test) {
        var obj = { x: 1 }, t = new Tween(obj);
        t.to({ y: 0 }, 1000);
        t.start(0);
        t.update(1000);
        test.deepEqual(obj.x, 1);
        // eslint-disable-next-line
        // @ts-ignore
        test.equal(obj.y, undefined);
        test.done();
    },
    'Tween non-null property': function (test) {
        var obj = { x: 1 }, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        t.start(0);
        t.update(1000);
        test.deepEqual(obj.x, 2);
        test.ok(obj.x !== null);
        test.done();
    },
    'Tween function property': function (test) {
        var my_function = new Function();
        var obj = { x: my_function }, t = new Tween(obj);
        t.to({ x: my_function });
        t.start(0);
        t.update(1000);
        test.ok(obj.x === my_function);
        test.done();
    },
    'Tween boolean property': function (test) {
        var obj = { x: true }, t = new Tween(obj);
        t.to({ x: new Function() });
        t.start(0);
        t.update(1000);
        test.ok(typeof obj.x === 'boolean');
        test.ok(obj.x === true);
        test.done();
    },
    'Tween null property': function (test) {
        var obj = { x: null }, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        t.start(0);
        t.update(1000);
        test.deepEqual(obj.x, 2);
        test.done();
    },
    'Tween undefined property': function (test) {
        var obj = {}, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        t.start(0);
        t.update(1000);
        // eslint-disable-next-line
        // @ts-ignore
        test.equal(obj.x, undefined);
        test.done();
    },
    'Tween relative positive value': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: '+100' }, 1000);
        t.start(0);
        t.update(1000);
        test.equal(obj.x, 100);
        test.done();
    },
    'Tween relative negative value': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: '-100' }, 1000);
        t.start(0);
        t.update(1000);
        test.equal(obj.x, -100);
        test.done();
    },
    'String values without a + or - sign should not be interpreted as relative': function (test) {
        var obj = { x: 100 }, t = new Tween(obj);
        t.to({ x: '100' }, 1000);
        t.start(0);
        t.update(1000);
        test.equal(obj.x, 100);
        test.done();
    },
    'Tween relative positive value, with yoyo': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: '+100' }, 1000);
        t.repeat(1);
        t.yoyo(true);
        t.start(0);
        t.update(500);
        test.equal(obj.x, 50);
        t.update(1000);
        test.equal(obj.x, 100);
        t.update(1500);
        test.equal(obj.x, 50);
        t.update(2000);
        test.equal(obj.x, 0);
        test.done();
    },
    'Tween relative negative value, with yoyo': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: '-100' }, 1000);
        t.repeat(1);
        t.yoyo(true);
        t.start(0);
        t.update(500);
        test.equal(obj.x, -50);
        t.update(1000);
        test.equal(obj.x, -100);
        t.update(1500);
        test.equal(obj.x, -50);
        t.update(2000);
        test.equal(obj.x, -0);
        test.done();
    },
    'Tween relative positive array interpolation values': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: ['+100', '+0', '-100', '+0'] }, 2000);
        t.start(0);
        t.update(250);
        test.equal(obj.x, 50);
        t.update(500);
        test.equal(obj.x, 100);
        t.update(750);
        test.equal(obj.x, 50);
        t.update(1000);
        test.equal(obj.x, 0);
        t.update(1250);
        test.equal(obj.x, -50);
        t.update(1500);
        test.equal(obj.x, -100);
        t.update(1750);
        test.equal(obj.x, -50);
        t.update(2000);
        test.equal(obj.x, 0);
        test.done();
    },
    'String values without a + or - sign should not be interpreted as relative with array interpolation values': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: ['100', '0', '100', '0'] }, 2000);
        t.start(0);
        t.update(250);
        test.equal(obj.x, 50);
        t.update(500);
        test.equal(obj.x, 100);
        t.update(750);
        test.equal(obj.x, 50);
        t.update(1000);
        test.equal(obj.x, 0);
        t.update(1250);
        test.equal(obj.x, 50);
        t.update(1500);
        test.equal(obj.x, 100);
        t.update(1750);
        test.equal(obj.x, 50);
        t.update(2000);
        test.equal(obj.x, 0);
        test.done();
    },
    'animate values in an array': function (test) {
        var obj = [0, 0, 0], t = new Tween(obj);
        t.to([1000, '-2000', '+2000'], 1000);
        t.start(0);
        t.update(250);
        test.equal(obj[0], 250);
        test.equal(obj[1], -500);
        test.equal(obj[2], 500);
        t.update(500);
        test.equal(obj[0], 500);
        test.equal(obj[1], -1000);
        test.equal(obj[2], 1000);
        t.update(750);
        test.equal(obj[0], 750);
        test.equal(obj[1], -1500);
        test.equal(obj[2], 1500);
        t.update(1000);
        test.equal(obj[0], 1000);
        test.equal(obj[1], -2000);
        test.equal(obj[2], 2000);
        test.done();
    },
    'animate values in a nested array': function (test) {
        var obj = { a: [0, 0, 0] }, t = new Tween(obj);
        t.to({ a: [1000, '-2000', '+2000'] }, 1000);
        t.start(0);
        t.update(250);
        test.equal(obj.a[0], 250);
        test.equal(obj.a[1], -500);
        test.equal(obj.a[2], 500);
        t.update(500);
        test.equal(obj.a[0], 500);
        test.equal(obj.a[1], -1000);
        test.equal(obj.a[2], 1000);
        t.update(750);
        test.equal(obj.a[0], 750);
        test.equal(obj.a[1], -1500);
        test.equal(obj.a[2], 1500);
        t.update(1000);
        test.equal(obj.a[0], 1000);
        test.equal(obj.a[1], -2000);
        test.equal(obj.a[2], 2000);
        test.done();
    },
    'Test TWEEN.Tween.start()': function (test) {
        var obj = {}, t = new Tween(obj);
        t.to({}, 1000);
        removeAll();
        test.equal(getAll().length, 0); // TODO move to TWEEN test
        t.start(0);
        test.equal(getAll().length, 1); // TODO ditto
        test.equal(getAll()[0], t);
        test.done();
    },
    'Ensure tweens start without calling start() method.': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: 1000 }, 1000);
        var started = false;
        t.onStart(function () { return (started = true); });
        t.onComplete(function () { return (started = false); });
        t.update(0);
        test.deepEqual(started, true);
        test.deepEqual(obj.x, 0);
        t.update(500);
        test.deepEqual(started, true);
        test.deepEqual(obj.x, 500);
        t.update(1000);
        test.deepEqual(obj.x, 1000);
        test.deepEqual(started, false);
        test.done();
    },
    'Test Tween.to() tweening towards a dynamic object': function (test) {
        var rabbit = { x: 1000, y: 0 };
        var tr = new Tween(rabbit);
        tr.to({ y: 1000 }, 1000);
        tr.start(0);
        var fox = { x: 0, y: 0 };
        var tf = new Tween(fox);
        tf.to(rabbit, 1000); // fox chase rabbit!
        tf.start(0);
        tr.update(200);
        tf.update(200);
        test.equal(rabbit.x, 1000);
        test.equal(rabbit.y, 200);
        test.equal(fox.x, 200);
        test.equal(fox.y, 40);
        tr.update(500);
        tf.update(500);
        test.equal(rabbit.x, 1000);
        test.equal(rabbit.y, 500);
        test.equal(fox.x, 500);
        test.equal(fox.y, 250);
        tr.update(800);
        tf.update(800);
        test.equal(rabbit.x, 1000);
        test.equal(rabbit.y, 800);
        test.equal(fox.x, 800);
        test.equal(fox.y, 640);
        tr.update(1000);
        tf.update(1000);
        test.equal(rabbit.x, 1000);
        test.equal(rabbit.y, 1000);
        test.equal(fox.x, 1000);
        test.equal(fox.y, 1000);
        test.done();
    },
    'Test TWEEN.Tween.stop()': function (test) {
        var obj = {}, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        removeAll();
        t.start();
        t.stop();
        test.equal(getAll().length, 0);
        test.done();
    },
    'Test TWEEN.Tween.delay()': function (test) {
        var obj = { x: 1 }, t = new Tween(obj);
        t.to({ x: 2 }, 1000);
        t.delay(500);
        t.start(0);
        t.update(100);
        test.deepEqual(obj.x, 1, "Tween hasn't started yet");
        t.update(1000);
        test.ok(obj.x !== 1 && obj.x !== 2, "Tween has started but hasn't finished yet");
        t.update(1500);
        test.equal(obj.x, 2, 'Tween finishes when expected');
        test.done();
    },
    // TODO: not really sure how to test this. Advice appreciated!
    'Test TWEEN.Tween.easing()': function (test) {
        var obj = { x: 0 }, t = new Tween(obj);
        t.to({ x: 1 }, 1000);
        t.easing(Easing.Quadratic.In);
        t.start(0);
        t.update(500);
        test.equal(obj.x, Easing.Quadratic.In(0.5));
        test.done();
    },
    // TODO test interpolation()
    'Test TWEEN.Tween.chain --with one tween': function (test) {
        var t = new Tween({}), t2 = new Tween({});
        var tStarted = false, tCompleted = false, t2Started = false;
        removeAll();
        t.to({}, 1000);
        t2.to({}, 1000);
        t.chain(t2);
        t.onStart(function () {
            tStarted = true;
        });
        t.onComplete(function () {
            tCompleted = true;
        });
        t2.onStart(function () {
            test.equal(tStarted, true);
            test.equal(tCompleted, true);
            test.equal(t2Started, false);
            t2Started = true;
        });
        test.equal(tStarted, false);
        test.equal(t2Started, false);
        t.start(0);
        update(0);
        test.equal(tStarted, true);
        test.equal(t2Started, false);
        update(1000);
        test.equal(tCompleted, true);
        update(1001);
        test.equal(t2Started, true, 't2 is automatically started by t');
        test.done();
    },
    'Test TWEEN.Tween.chain --with several tweens in an array': function (test) {
        var t = new Tween({}), chainedTweens = [], numChained = 3;
        var numChainedStarted = 0;
        removeAll();
        t.to({}, 1000);
        function onChainedStart() {
            numChainedStarted++;
        }
        for (var i = 0; i < numChained; i++) {
            var chained = new Tween({});
            chained.to({}, 1000);
            chainedTweens.push(chained);
            chained.onStart(onChainedStart);
        }
        t.chain.apply(t, chainedTweens);
        test.equal(numChainedStarted, 0);
        t.start(0);
        update(0);
        update(1000);
        update(1001);
        test.equal(numChainedStarted, numChained, 'All chained tweens have been started');
        test.done();
    },
    'Test TWEEN.Tween.chain allows endless loops': function (test) {
        var obj = { x: 0 }, t1 = new Tween(obj).to({ x: 100 }, 1000), t2 = new Tween(obj).to({ x: 0 }, 1000);
        removeAll();
        t1.chain(t2);
        t2.chain(t1);
        test.equal(obj.x, 0);
        // x == 0
        t1.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(500);
        test.equal(obj.x, 50);
        // there... (x == 100)
        update(1000);
        test.equal(obj.x, 100);
        update(1500);
        test.equal(obj.x, 50);
        // ... and back again (x == 0)
        update(2000);
        test.equal(obj.x, 0);
        update(2500);
        test.equal(obj.x, 50);
        update(3000);
        test.equal(obj.x, 100); // and x == 100 again
        // Repeat the same test but with the tweens added in the
        // opposite order.
        var obj2 = { x: 0 };
        var t3 = new Tween(obj2).to({ x: 200 }, 1000);
        var t4 = new Tween(obj2).to({ x: 100 }, 1000);
        t4.chain(t3);
        t3.chain(t4);
        test.equal(obj2.x, 0);
        t4.start(0);
        update(0);
        test.equal(obj2.x, 0);
        update(500);
        test.equal(obj2.x, 50);
        update(1000);
        test.equal(obj2.x, 100);
        update(1500);
        test.equal(obj2.x, 150);
        update(2000);
        test.equal(obj2.x, 0);
        update(2500);
        test.equal(obj2.x, 50);
        update(3000);
        test.equal(obj2.x, 100);
        update(3500);
        test.equal(obj2.x, 150);
        update(4000);
        test.equal(obj2.x, 0);
        update(4500);
        test.equal(obj2.x, 50);
        test.done();
    },
    'Test TWEEN.Tween.onStart': function (test) {
        var obj = {}, t = new Tween(obj);
        var counter = 0;
        t.to({ x: 2 }, 1000);
        t.onStart(function () {
            test.ok(true, 'onStart callback is called');
            counter++;
        });
        test.deepEqual(counter, 0);
        t.start(0);
        update(0);
        test.deepEqual(counter, 1);
        update(500);
        test.deepEqual(counter, 1, 'onStart callback is not called again');
        test.done();
    },
    'Test TWEEN.Tween.onStop': function (test) {
        var obj = {}, t = new Tween(obj);
        var counter = 0;
        t.to({ x: 2 }, 1000);
        t.onStop(function () {
            test.ok(true, 'onStop callback is called');
            counter++;
        });
        test.deepEqual(counter, 0);
        t.stop();
        update(0);
        test.deepEqual(counter, 0, "onStop callback not called when the tween hasn't started yet");
        t.start(0);
        update(0);
        t.stop();
        test.deepEqual(counter, 1, 'onStop callback is called if the tween has been started already and stop is invoked');
        update(500);
        t.stop();
        test.deepEqual(counter, 1, 'onStop callback is not called again once the tween is stopped');
        test.done();
    },
    'Test TWEEN.Tween.onUpdate': function (test) {
        var obj = {}, t = new Tween(obj);
        var counter = 0;
        t.to({ x: 2 }, 1000);
        t.onUpdate(function () {
            counter++;
        });
        test.deepEqual(counter, 0);
        t.start(0);
        update(0);
        test.deepEqual(counter, 1);
        update(500);
        test.deepEqual(counter, 2);
        update(600);
        test.deepEqual(counter, 3);
        update(1000);
        test.deepEqual(counter, 4);
        update(1500);
        test.deepEqual(counter, 4, 'onUpdate callback should not be called after the tween has finished');
        test.done();
    },
    'Test TWEEN.Tween.onComplete': function (test) {
        var obj = {}, t = new Tween(obj);
        var counter = 0;
        t.to({ x: 2 }, 1000);
        t.onComplete(function () {
            counter++;
        });
        test.deepEqual(counter, 0);
        t.start(0);
        update(0);
        test.deepEqual(counter, 0);
        update(500);
        test.deepEqual(counter, 0);
        update(600);
        test.deepEqual(counter, 0);
        update(1000);
        test.deepEqual(counter, 1);
        update(1500);
        test.deepEqual(counter, 1, 'onComplete callback must be called only once');
        test.done();
    },
    'TWEEN.Tween does not repeat by default': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(50);
        test.equal(obj.x, 50);
        update(100);
        test.equal(obj.x, 100);
        update(150);
        test.equal(obj.x, 100);
        test.done();
    },
    'Test single repeat happens only once': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(1);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(50);
        test.equal(obj.x, 50);
        update(100);
        test.equal(obj.x, 100);
        update(150);
        test.equal(obj.x, 50);
        update(200);
        test.equal(obj.x, 100);
        test.done();
    },
    'Test Infinity repeat happens forever': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(Infinity);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(50);
        test.equal(obj.x, 50);
        update(100);
        test.equal(obj.x, 100);
        update(150);
        test.equal(obj.x, 50);
        update(200);
        test.equal(obj.x, 100);
        update(250);
        test.equal(obj.x, 50);
        test.done();
    },
    'Test tweening relatively with repeat': function (test) {
        removeAll();
        var obj = { x: 0, y: 0 }, t = new Tween(obj).to({ x: '+100', y: '-100' }, 100).repeat(1);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        test.equal(obj.y, 0);
        update(50);
        test.equal(obj.x, 50);
        test.equal(obj.y, -50);
        update(100);
        test.equal(obj.x, 100);
        test.equal(obj.y, -100);
        update(150);
        test.equal(obj.x, 150);
        test.equal(obj.y, -150);
        update(200);
        test.equal(obj.x, 200);
        test.equal(obj.y, -200);
        test.done();
    },
    'Test yoyo with repeat Infinity happens forever': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(Infinity).yoyo(true);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(25);
        test.equal(obj.x, 25);
        update(100);
        test.equal(obj.x, 100);
        update(125);
        test.equal(obj.x, 75);
        update(200);
        test.equal(obj.x, 0);
        update(225);
        test.equal(obj.x, 25);
        test.done();
    },
    'Test yoyo with repeat 1 happens once': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(1).yoyo(true);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(25);
        test.equal(obj.x, 25);
        update(100);
        test.equal(obj.x, 100);
        update(125);
        test.equal(obj.x, 75);
        update(200);
        test.equal(obj.x, 0);
        update(225);
        test.equal(obj.x, 0);
        test.done();
    },
    'Test yoyo works with arrays': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj)
            .to({ x: [100, 200] }, 100)
            .repeat(1)
            .yoyo(true);
        t.start(0);
        update(50);
        test.equal(obj.x, 100);
        update(100);
        test.equal(obj.x, 200);
        update(150);
        test.equal(obj.x, 100);
        update(200);
        test.equal(obj.x, 0);
        test.done();
    },
    'Test yoyo can be stopped and restarted properly': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(1).yoyo(true);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(25);
        test.equal(obj.x, 25);
        update(100);
        test.equal(obj.x, 100);
        update(125);
        test.equal(obj.x, 75);
        t.stop();
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(25);
        test.equal(obj.x, 25);
        update(100);
        test.equal(obj.x, 100);
        update(125);
        test.equal(obj.x, 75);
        update(200);
        test.equal(obj.x, 0);
        update(225);
        test.equal(obj.x, 0);
        test.done();
    },
    'Test TWEEN.Tween.stopChainedTweens()': function (test) {
        var t = new Tween({}), t2 = new Tween({});
        var tStarted = false, tCompleted = false, t2Started = false;
        removeAll();
        t.to({}, 1000);
        t2.delay(500).to({}, 1000);
        t.chain(t2);
        t2.chain(t);
        t.onStart(function () {
            tStarted = true;
        });
        t.onComplete(function () {
            tCompleted = true;
        });
        t2.onStart(function () {
            test.equal(tStarted, true);
            test.equal(tCompleted, true);
            test.equal(t2Started, false);
            t2Started = true;
        });
        test.equal(tStarted, false);
        test.equal(t2Started, false);
        t.start(0);
        update(1001);
        t.stop();
        test.equal(tStarted, true);
        test.equal(t2Started, false);
        test.equal(getAll().length, 0);
        test.done();
    },
    'Test TWEEN.Tween.chain progressess into chained tweens': function (test) {
        var obj = { t: 1000 };
        // 1000 of nothing
        var blank = new Tween({}).to({}, 1000);
        // tween obj.t from 1000 -> 2000 (in time with update time)
        var next = new Tween(obj).to({ t: 2000 }, 1000);
        blank.chain(next).start(0);
        update(1500);
        test.equal(obj.t, 1500);
        update(2000);
        test.equal(obj.t, 2000);
        test.done();
    },
    'Test that TWEEN.Tween.end sets the final values.': function (test) {
        var object1 = { x: 0, y: -50, z: 1000 };
        var target1 = { x: 50, y: 123, z: '+234' };
        var tween1 = new Tween(object1).to(target1, 1000);
        tween1.start();
        tween1.end();
        test.equal(object1.x, 50);
        test.equal(object1.y, 123);
        test.equal(object1.z, 1234);
        var object2 = { x: 0, y: -50, z: 1000 };
        var target2 = { x: 50, y: 123, z: '+234' };
        var tween2 = new Tween(object2).to(target2, 1000);
        tween2.start(300);
        tween2.update(500);
        tween2.end();
        test.equal(object2.x, 50);
        test.equal(object2.y, 123);
        test.equal(object2.z, 1234);
        test.done();
    },
    'Test that TWEEN.Tween.end calls the onComplete callback of the tween.': function (test) {
        test.expect(1);
        var tween1 = new Tween({}).to({}, 1000).onComplete(function () {
            test.ok(true);
        });
        tween1.start();
        tween1.end();
        test.done();
    },
    'Ensure Tween.end() works after stopping a tween.': function (test) {
        var object = { x: 0, y: -50, z: 1000 };
        var target = { x: 50, y: 123, z: '+234' };
        var tween = new Tween(object).to(target, 1000);
        tween.start(300);
        tween.update(500);
        tween.stop();
        tween.end();
        test.equal(object.x, 50);
        test.equal(object.y, 123);
        test.equal(object.z, 1234);
        test.done();
    },
    'Test delay adds delay before each repeat': function (test) {
        // If repeatDelay isn't specified then delay is used since
        // that's the way it worked before repeatDelay was added.
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(1).delay(100);
        t.start(0);
        update(100);
        test.equal(obj.x, 0);
        update(150);
        test.equal(obj.x, 50);
        update(200);
        test.equal(obj.x, 100);
        update(250);
        test.equal(obj.x, 100);
        update(300);
        test.equal(obj.x, 0);
        update(350);
        test.equal(obj.x, 50);
        update(400);
        test.equal(obj.x, 100);
        test.done();
    },
    'Test repeatDelay adds delay before each repeat': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).repeat(1).repeatDelay(200);
        t.start(0);
        update(0);
        test.equal(obj.x, 0);
        update(50);
        test.equal(obj.x, 50);
        update(100);
        test.equal(obj.x, 100);
        update(200);
        test.equal(obj.x, 100);
        update(300);
        test.equal(obj.x, 0);
        update(350);
        test.equal(obj.x, 50);
        update(400);
        test.equal(obj.x, 100);
        test.done();
    },
    'Test repeatDelay and delay can be used together': function (test) {
        removeAll();
        var obj = { x: 0 }, t = new Tween(obj).to({ x: 100 }, 100).delay(100).repeat(1).repeatDelay(200);
        t.start(0);
        update(100);
        test.equal(obj.x, 0);
        update(150);
        test.equal(obj.x, 50);
        update(200);
        test.equal(obj.x, 100);
        update(300);
        test.equal(obj.x, 100);
        update(400);
        test.equal(obj.x, 0);
        update(450);
        test.equal(obj.x, 50);
        update(500);
        test.equal(obj.x, 100);
        test.done();
    },
    'Tween.js compatible with Object.defineProperty getter / setters': function (test) {
        var obj = { _x: 0, x: 0 };
        Object.defineProperty(obj, 'x', {
            get: function () {
                return this._x;
            },
            set: function (x) {
                this._x = x;
            },
        });
        test.equal(obj.x, 0);
        var t = new Tween(obj).to({ x: 100 }, 100);
        t.start(0);
        test.equal(obj.x, 0);
        update(37);
        test.equal(obj.x, 37);
        update(100);
        test.equal(obj.x, 100);
        update(115);
        test.equal(obj.x, 100);
        test.done();
    },
    'tween.isPlaying() is false before the tween starts': function (test) {
        removeAll();
        var t = new Tween({ x: 0 }).to({ x: 1 }, 100);
        test.equal(t.isPlaying(), false);
        test.done();
    },
    'tween.isPlaying() is true when a tween is started and before it ends': function (test) {
        removeAll();
        var t = new Tween({ x: 0 }).to({ x: 1 }, 100);
        t.start(0);
        test.equal(t.isPlaying(), true);
        test.done();
    },
    'tween.isPlaying() is false after a tween ends': function (test) {
        removeAll();
        var t = new Tween({ x: 0 }).to({ x: 1 }, 100);
        t.start(0);
        update(150);
        test.equal(t.isPlaying(), false);
        test.done();
    },
    'A zero-duration tween finishes at its starting time without an error.': function (test) {
        removeAll();
        var object = { x: 0 };
        var t = new Tween(object).to({ x: 1 }, 0);
        t.start(0);
        update(0);
        test.equal(t.isPlaying(), false);
        test.equal(object.x, 1);
        test.done();
    },
    // Custom TWEEN.Group tests
    'Custom group.getAll()': function (test) {
        var group = new Group();
        test.ok(group.getAll() instanceof Array);
        test.done();
    },
    'Custom group stores tweens instead of global TWEEN group': function (test) {
        var group = new Group();
        var numGlobalTweensBefore = getAll().length;
        var numGroupTweensBefore = group.getAll().length;
        var globalTween = new Tween({});
        var groupTweenA = new Tween({}, group);
        var groupTweenB = new Tween({}, group);
        globalTween.start();
        groupTweenA.start();
        groupTweenB.start();
        test.equal(getAll().length, numGlobalTweensBefore + 1);
        test.equal(group.getAll().length, numGroupTweensBefore + 2);
        test.done();
    },
    "Custom group.removeAll() doesn't conflict with global TWEEN group": function (test) {
        var group = new Group();
        removeAll();
        group.removeAll();
        test.equal(getAll().length, 0, 'No global tweens left');
        test.equal(group.getAll().length, 0, 'No group tweens left');
        var globalTween = new Tween({});
        var groupTweenA = new Tween({}, group);
        var groupTweenB = new Tween({}, group);
        globalTween.start();
        groupTweenA.start();
        groupTweenB.start();
        test.equal(getAll().length, 1, 'One global tween has been added');
        test.equal(group.getAll().length, 2, 'Two group tweens have been added');
        group.removeAll();
        test.equal(getAll().length, 1, 'One global tween left');
        test.equal(group.getAll().length, 0, 'No group tweens left');
        removeAll();
        test.equal(getAll().length, 0, 'No global tweens left');
        test.done();
    },
    "Global TWEEN.removeAll() doesn't conflict with custom group": function (test) {
        var group = new Group();
        removeAll();
        group.removeAll();
        test.equal(getAll().length, 0, 'No global tweens left');
        test.equal(group.getAll().length, 0, 'No group tweens left');
        var globalTween = new Tween({});
        var groupTweenA = new Tween({}, group);
        var groupTweenB = new Tween({}, group);
        globalTween.start();
        groupTweenA.start();
        groupTweenB.start();
        test.equal(getAll().length, 1, 'One global tween has been added');
        test.equal(group.getAll().length, 2, 'Two group tweens have been added');
        removeAll();
        test.equal(getAll().length, 0, 'No global tweens left');
        test.equal(group.getAll().length, 2, 'Two group tweens left');
        group.removeAll();
        test.equal(group.getAll().length, 0, 'No group tweens left');
        test.done();
    },
    "Custom group.add() doesn't conflict with global TWEEN group, or vice versa": function (test) {
        var group = new Group();
        var globalTween = new Tween({});
        var groupTweenA = new Tween({}, group);
        var groupTweenB = new Tween({}, group);
        var numGlobalTweens = getAll().length;
        var numGroupTweens = group.getAll().length;
        add(globalTween);
        group.add(groupTweenA);
        group.add(groupTweenB);
        test.equal(numGlobalTweens + 1, getAll().length);
        test.equal(numGroupTweens + 2, group.getAll().length);
        test.done();
    },
    "Custom group.update() doesn't conflict with global TWEEN group": function (test) {
        var group = new Group();
        var startObj = { x: 1 };
        var endObj = { x: 2 };
        var duration = 1000;
        var globalObj = { x: 1 };
        new Tween(globalObj).to(endObj, duration).start(0);
        var groupObj = { x: 1 };
        new Tween(groupObj, group).to(endObj, duration).start(0);
        group.update(duration);
        test.deepEqual(globalObj, startObj);
        test.deepEqual(groupObj, endObj);
        test.done();
    },
    "Global TWEEN.update() doesn't conflict with custom group": function (test) {
        var group = new Group();
        var startObj = { x: 1 };
        var endObj = { x: 2 };
        var duration = 1000;
        var globalObj = { x: 1 };
        new Tween(globalObj).to(endObj, duration).start(0);
        var groupObj = { x: 1 };
        new Tween(groupObj, group).to(endObj, duration).start(0);
        update(duration);
        test.deepEqual(globalObj, endObj);
        test.deepEqual(groupObj, startObj);
        test.done();
    },
    'Ensure tweens work without any group': function (test) {
        var obj = { x: 0 }, t = new Tween(obj, false);
        t.to({ x: 1000 }, 1000);
        t.start(0);
        test.equal(obj.x, 0);
        t.update(500);
        test.equal(obj.x, 500);
        t.pause(600);
        test.equal(obj.x, 500);
        t.update(750);
        test.equal(obj.x, 500);
        t.resume(800);
        test.equal(obj.x, 500);
        t.update(1000);
        test.equal(obj.x, 800);
        t.update(1001);
        test.equal(obj.x, 801);
        t.stop().end();
        test.equal(obj.x, 1000);
        test.done();
    },
    'Stopping a tween within an update callback will not cause an error.': function (test) {
        removeAll();
        var tweenA = new Tween({ x: 1, y: 2 })
            .to({ x: 3, y: 4 }, 1000)
            .onUpdate(function () {
            tweenB.stop();
        })
            .start(0);
        var tweenB = new Tween({ x: 5, y: 6 })
            .to({ x: 7, y: 8 })
            .onUpdate(function () {
            tweenA.stop();
        })
            .start(0);
        var success = true;
        try {
            update(500);
        }
        catch (exception) {
            success = false;
        }
        finally {
            test.ok(success);
            test.done();
        }
    },
    'Set the duration with .duration': function (test) {
        var obj = { x: 1 };
        var t = new Tween(obj).to({ x: 2 }).duration(1000).start(0);
        t.update(1000);
        test.deepEqual(obj.x, 2);
        test.done();
    },
    "Tween.group sets the tween's group.": function (test) {
        var group = new Group();
        var groupTweenA = new Tween({}).group(group);
        groupTweenA.start();
        test.equal(group.getAll().length, 1);
        test.done();
    },
    'Test TWEEN.Tween.pause() and TWEEN.Tween.resume()': function (test) {
        var obj = { x: 0.0 }, t = new Tween(obj);
        t.to({ x: 1.0 }, 1000);
        removeAll();
        test.equal(getAll().length, 0);
        t.start(0);
        test.equal(getAll().length, 1);
        test.equal(t.isPaused(), false);
        update(400);
        test.equal(obj.x, 0.4);
        t.pause(450);
        test.equal(t.isPaused(), true);
        test.equal(getAll().length, 0);
        test.equal(obj.x, 0.4);
        update(900);
        test.equal(obj.x, 0.4);
        update(3000);
        test.equal(obj.x, 0.4);
        t.resume(3200);
        // values do not change until an update
        test.equal(obj.x, 0.4);
        test.equal(getAll().length, 1);
        test.equal(t.isPaused(), false);
        update(3500);
        test.equal(obj.x, 0.75);
        update(5000);
        test.equal(obj.x, 1.0);
        test.done();
    },
    'Test TWEEN.Tween.pause() and TWEEN.Tween.resume(), without groups': function (test) {
        var obj = { x: 0.0 }, t = new Tween(obj, false);
        t.to({ x: 1.0 }, 1000);
        t.start(0);
        test.equal(t.isPaused(), false);
        t.update(400);
        test.equal(obj.x, 0.4);
        t.pause(450);
        test.equal(t.isPaused(), true);
        test.equal(obj.x, 0.4);
        t.update(900);
        test.equal(obj.x, 0.4);
        t.update(3000);
        test.equal(obj.x, 0.4);
        t.resume(3200);
        // values do not change until an update
        test.equal(obj.x, 0.4);
        test.equal(t.isPaused(), false);
        t.update(3500);
        test.equal(obj.x, 0.75);
        t.update(5000);
        test.equal(obj.x, 1.0);
        test.done();
    },
    'Arrays in the object passed to to() are not modified by start().': function (test) {
        var start = { x: 10, y: 20 };
        var end = { x: 100, y: 200, values: ['a', 'b'] };
        var valuesArray = end.values;
        new Tween(start).to(end).start();
        test.equal(valuesArray, end.values);
        test.equal(end.values.length, 2);
        test.equal(end.values[0], 'a');
        test.equal(end.values[1], 'b');
        test.done();
    },
    'Tween.js animate nested object': function (test) {
        var obj = { scale: { x: 0 }, alpha: 0 };
        var t = new Tween(obj).to({ scale: { x: 100 }, alpha: 100 }, 100);
        t.start(0);
        test.equal(obj.scale.x, 0);
        update(37);
        test.equal(obj.scale.x, 37);
        test.equal(obj.alpha, 37);
        update(100);
        test.equal(obj.scale.x, 100);
        test.equal(obj.alpha, 100);
        update(115);
        test.equal(obj.scale.x, 100);
        test.equal(obj.alpha, 100);
        test.done();
    },
    'Tween.js animate nested object including relative value': function (test) {
        var obj = { world: { hero: { scale: { x: 0 }, x: 100 } }, time: 0 };
        var t = new Tween(obj).to({ world: { hero: { scale: { x: 100 }, x: '+100' } }, time: 100 }, 100);
        t.start(0);
        test.equal(obj.world.hero.scale.x, 0);
        update(37);
        test.equal(obj.world.hero.scale.x, 37);
        test.equal(obj.world.hero.x, 137);
        test.equal(obj.time, 37);
        update(100);
        test.equal(obj.world.hero.scale.x, 100);
        test.equal(obj.world.hero.x, 200);
        test.equal(obj.time, 100);
        update(115);
        test.equal(obj.world.hero.scale.x, 100);
        test.equal(obj.world.hero.x, 200);
        test.equal(obj.time, 100);
        test.done();
    },
    'Test TWEEN.Tween with nested objects': function (test) {
        var obj = { x: 0.0, y: 100, some: { value: 0.0, style: { opacity: 1.0 } } }, t = new Tween(obj);
        t.to({ x: 1.0, y: 200, some: { value: 1.0, style: { opacity: 0.5 } } }, 1000);
        removeAll();
        test.equal(getAll().length, 0);
        t.start(0);
        test.equal(getAll().length, 1);
        test.equal(t.isPaused(), false);
        update(400);
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.style.opacity, 0.8);
        test.equal(obj.some.value, 0.4);
        update(750);
        test.equal(obj.x, 0.75);
        test.equal(obj.y, 175);
        test.equal(obj.some.style.opacity, 0.625);
        test.equal(obj.some.value, 0.75);
        update(1000);
        test.equal(obj.x, 1.0);
        test.equal(obj.y, 200);
        test.equal(obj.some.style.opacity, 0.5);
        test.equal(obj.some.value, 1.0);
        test.done();
    },
    'Test TWEEN.Tween.pause() and .resume() with nested objects': function (test) {
        var obj = { x: 0.0, y: 100, some: { value: 0.0 } }, t = new Tween(obj);
        t.to({ x: 1.0, y: 200, some: { value: 1.0 } }, 1000);
        removeAll();
        test.equal(getAll().length, 0);
        t.start(0);
        test.equal(getAll().length, 1);
        test.equal(t.isPaused(), false);
        update(400);
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.value, 0.4);
        t.pause(450);
        test.equal(t.isPaused(), true);
        test.equal(getAll().length, 0);
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.value, 0.4);
        update(900);
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.value, 0.4);
        update(3000);
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.value, 0.4);
        t.resume(3200);
        // values do not change until an update
        test.equal(obj.x, 0.4);
        test.equal(obj.y, 140);
        test.equal(obj.some.value, 0.4);
        test.equal(getAll().length, 1);
        test.equal(t.isPaused(), false);
        update(3500);
        test.equal(obj.x, 0.75);
        test.equal(obj.y, 175);
        test.equal(obj.some.value, 0.75);
        update(5000);
        test.equal(obj.x, 1.0);
        test.equal(obj.y, 200);
        test.equal(obj.some.value, 1.0);
        test.done();
    },
};

exports.tests = tests;
