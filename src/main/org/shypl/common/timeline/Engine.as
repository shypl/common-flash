package org.shypl.common.timeline {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	import org.shypl.common.collection.LiteLinkedSet;
	import org.shypl.common.lang.RuntimeException;
	import org.shypl.common.util.Change;
	import org.shypl.common.util.Changes;

	internal final class Engine {
		private static const _shape:Shape = new Shape();
		private static const _timelines:LiteLinkedSet = new LiteLinkedSet();
		private static const _changes:Changes = new Changes();

		private static var _taskCounter:int;
		private static var _lastTimer:int;

		public static function get dispatching():Boolean {
			return _changes.locked;
		}

		public static function addTimeline(timeline:Timeline):void {
			if (_changes.locked) {
				_changes.add(new EngineChangeTimelines(timeline, true));
			}
			else {
				_timelines.add(timeline);
			}
		}

		public static function removeTimeline(timeline:Timeline):void {
			if (_changes.locked) {
				_changes.add(new EngineChangeTimelines(timeline, false));
			}
			else {
				_timelines.remove(timeline);
			}
		}

		public static function increaseTaskCounter():void {
			if (_changes.locked) {
				_changes.add(new EngineChangeTaskCounter(1));
			}
			else {
				if (++_taskCounter === 1) {
					_lastTimer = getTimer();
					_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}

		public static function decreaseTaskCounter(value:int):void {
			if (value !== 0) {
				if (value < 0) {
					throw new RuntimeException();
				}

				if (_changes.locked) {
					_changes.add(new EngineChangeTaskCounter(-value));
				}
				else {
					_taskCounter -= value;
					if (_taskCounter === 0) {
						_shape.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
					else if (_taskCounter < 0) {
						throw new RuntimeException();
					}
				}
			}
		}

		public static function addChange(change:Change):void {
			_changes.add(change);
		}

		private static function onEnterFrame(event:Event):void {
			_changes.lock();

			var timerTime:int = getTimer();
			var time:int = timerTime - _lastTimer;
			_lastTimer = timerTime;

			while (_timelines.next()) {
				Timeline(_timelines.current).handleEnterFrame(time);
			}

			_changes.unlock();
		}
	}
}
