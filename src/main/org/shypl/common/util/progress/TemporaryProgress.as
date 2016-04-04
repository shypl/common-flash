package org.shypl.common.util.progress {
	import org.shypl.common.util.*;
	import flash.utils.getTimer;

	import org.shypl.common.timeline.GlobalTimeline;

	public class TemporaryProgress implements Progress {
		private var _time:int;
		private var _autoComplete:Boolean;
		private var _autoCompleteTask:Cancelable;
		private var _startTime:int;

		public function TemporaryProgress(seconds:int, autoComplete:Boolean) {
			_time = seconds * 1000;
			_autoComplete = autoComplete;
			_startTime = getTimer();

			if (_autoComplete) {
				_autoCompleteTask = GlobalTimeline.schedule(seconds, complete);
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
			if (passedTime >= _time) {
				return _autoComplete ? 1 : 0.99;
			}

			return passedTime / _time * (_autoComplete ? 1 : 0.99);
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
