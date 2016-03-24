package org.shypl.common.util.numerator {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.timeline.Timeline;
	import org.shypl.common.util.Cancelable;

	[Abstract]
	public class Numerator {
		private var _timeline:Timeline;
		private var _handler:Function;

		private var _stepsDefiner:Function;
		private var _currentValue:Object;
		private var _targetValue:Object;
		private var _increment:Boolean;
		private var _stepAmount:int;
		private var _stepValue:Object;

		private var _updateTask:Cancelable;

		public function Numerator(handler:Function, value:Object, stepsDefiner:Function, timeline:Timeline) {
			_timeline = timeline === null ? GlobalTimeline.INSTANCE : timeline;
			_handler = handler;
			_currentValue = value;
			_stepsDefiner = stepsDefiner;
		}

		public final function get currentValue():Object {
			return _currentValue;
		}

		public final function get targetValue():Object {
			return _targetValue;
		}

		public final function set(value:Object, instant:Boolean = false):void {
			if (instant) {
				_targetValue = value;
				if (_updateTask === null) {
					_currentValue = _targetValue;
					_handler(_currentValue);
				}
				else {
					complete();
				}
			}
			else {

				var com:int = compare(value, _currentValue);

				if (com !== 0 || _updateTask !== null) {
					_targetValue = value;
					_increment = com > 0;

					var diff:Object;
					if (_increment) {
						diff = subtract(_targetValue, _currentValue);
					}
					else {
						diff = subtract(_currentValue, _targetValue);
					}

					_stepAmount = _stepsDefiner(diff);
					if (_stepAmount <= 0) {
						_stepAmount = 1;
					}
					else if (_stepAmount > 300) {
						_stepAmount = 300;
					}
					_stepValue = defineStepSize(diff, _stepAmount);

					if (_updateTask === null) {
						_updateTask = _timeline.forEachFrame(update);
					}
				}
			}
		}

		public final function complete():void {
			if (_updateTask !== null) {
				_updateTask.cancel();
				_updateTask = null;
				_currentValue = _targetValue;
				_handler(_currentValue);
			}
		}

		[Abstract]
		protected function compare(a:Object, b:Object):int {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function add(a:Object, b:Object):Object {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function subtract(a:Object, b:Object):Object {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function defineStepSize(diff:Object, steps:int):Object {
			throw new AbstractMethodException();
		}

		private function update():void {
			if (--_stepAmount == 0) {
				complete();
			}
			else {
				if (_increment) {
					_currentValue = add(_currentValue, _stepValue);
				}
				else {
					_currentValue = subtract(_currentValue, _stepValue);
				}
				_handler(_currentValue);
			}
		}
	}
}
