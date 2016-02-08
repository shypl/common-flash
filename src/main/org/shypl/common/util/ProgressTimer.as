package org.shypl.common.util {
	import flash.utils.getTimer;

	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.timeline.TimelineTask;

	public class ProgressTimer implements Progress {
		private var _interval:int;
		private var _autoComplete:Boolean;
		private var _autoCompleteTask:TimelineTask;
		private var _startTime:int;

		public function ProgressTimer(intervalSeconds:int, autoComplete:Boolean) {
			_interval = intervalSeconds * 1000;
			_autoComplete = autoComplete;
			_startTime = getTimer();

			if (_autoComplete) {
				_autoCompleteTask = GlobalTimeline.schedule(intervalSeconds, complete);
			}
		}

		public function get completed():Boolean {
			return _startTime === -1;
		}

		public function get percent():Number {
			if (completed) {
				return 1;
			}

			var passedTime:int = getTimer() - _startTime;
			if (passedTime >= _interval) {
				return _autoComplete ? 1 : 0.99;
			}

			return passedTime / _interval * (_autoComplete ? 1 : 0.99);
		}

		public function complete():void {
			_startTime = -1;
			if (_autoCompleteTask !== null) {
				_autoCompleteTask.cancel();
				_autoCompleteTask = null;
			}
		}
	}
}
