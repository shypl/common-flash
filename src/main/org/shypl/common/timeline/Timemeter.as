package org.shypl.common.timeline {
	import flash.utils.getTimer;

	import org.shypl.common.lang.IllegalStateException;

	public class TimeMeter {
		private var _running:Boolean;
		private var _startTime:int;
		private var _passedTime:int;

		public function TimeMeter() {
		}

		public function get milliseconds():int {
			if (_running) {
				return getTimer() - _startTime;
			}
			return _passedTime;
		}

		public function get seconds():int {
			return milliseconds / 1000;
		}

		public function start():void {
			if (_running) {
				throw new IllegalStateException("Already started");
			}
			_running = true;
			_startTime = getTimer();
		}

		public function stop():void {
			if (_running) {
				_running = false;
				_passedTime = getTimer() - _startTime;
			}
			else {
				throw new IllegalStateException("Already started");
			}
		}
	}
}
