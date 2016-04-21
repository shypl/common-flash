package org.shypl.common.util.progress {
	import flash.utils.getTimer;

	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;

	public class TemporaryProgress extends AbstractProgress {
		private var _time:int;
		private var _autoComplete:Boolean;
		private var _autoCompleteTask:Cancelable;
		private var _startTime:int;

		public function TemporaryProgress(seconds:int, autoComplete:Boolean) {
			_time = seconds * 1000;
			_autoComplete = autoComplete;
			_startTime = getTimer();

			if (_autoComplete) {
				_autoCompleteTask = GlobalTimeline.schedule(_time, complete);
			}
		}

		public final function makeComplete():void {
			complete();
		}

		override protected function calculatePercent():Number {
			var passedTime:int = getTimer() - _startTime;
			if (passedTime >= _time) {
				return _autoComplete ? 1 : 0.99;
			}
			return passedTime / _time * (_autoComplete ? 1 : 0.99);
		}

		override protected function complete():void {
			if (_autoComplete) {
				_autoCompleteTask.cancel();
				_autoCompleteTask = null;
			}
			super.complete();
		}
	}
}
