package org.shypl.common.timeline {
	import org.shypl.common.lang.IllegalArgumentException;
	
	[Abstract]
	public class ScheduledTask extends TimedTask {
		private var _delay:int;
		private var _remainedTime:int;
		
		public function ScheduledTask(delay:int, repeatable:Boolean) {
			super(repeatable);
			if (_delay < 0) {
				throw new IllegalArgumentException();
			}
			_delay = delay;
			_remainedTime = _delay;
		}
		
		public final function get delay():int {
			return _delay;
		}
		
		public final function get remainedTime():int {
			return _remainedTime;
		}
		
		override protected function tryExecute(passedTime:int):Boolean {
			_remainedTime -= passedTime;
			if (_remainedTime <= 0) {
				execute(_delay - _remainedTime);
				_remainedTime = _delay;
				return true;
			}
			return false;
		}
	}
}
