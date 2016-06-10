package org.shypl.common.timeline {
	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class TimeTask extends Task {
		private var _time:int;
		private var _passedTime:int;

		public function TimeTask(time:int, repeatable:Boolean) {
			super(repeatable);
			_time = time;
			_passedTime = 0;
		}

		override protected function tryExecute(passedTime:int):Boolean {
			_passedTime += passedTime;
			if (_passedTime >= _time) {
				execute(_passedTime);
				_passedTime = 0;
				return true;
			}
			return false;
		}


		[Abstract]
		protected function execute(passedTime:int):void {
			throw new AbstractMethodException();
		}
	}
}
