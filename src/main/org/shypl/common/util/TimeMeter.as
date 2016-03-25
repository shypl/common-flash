package org.shypl.common.util {
	import flash.utils.getTimer;

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

		public function start():Boolean {
			if (_running) {
				return false;
			}
			_running = true;
			_startTime = getTimer();
			return true;
		}

		public function restart():Boolean {
			if (_running) {
				_running = true;
				_startTime = getTimer();
				return true;
			}
			return false;
		}

		public function stop():Boolean {
			if (_running) {
				_running = false;
				_passedTime = getTimer() - _startTime;
				return true;
			}
			return false;
		}
	}
}
