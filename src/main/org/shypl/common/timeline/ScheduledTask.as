package org.shypl.common.timeline {
	import org.shypl.common.lang.IllegalArgumentException;

	internal class ScheduledTask extends Task {
		private var _delay:int;
		private var _remains:int;

		public function ScheduledTask(task:Function, obtainTime:Boolean, repeatable:Boolean, delay:int) {
			super(task, obtainTime, repeatable);
			if (_delay < 0) {
				throw new IllegalArgumentException();
			}
			_delay = delay;
			_remains = _delay;
		}

		override internal function handleEnterFrame(time:int):void {
			_remains -= time;
			if (_remains <= 0) {
				super.handleEnterFrame(_delay - _remains);
				_remains = _delay;
			}
		}
	}
}
