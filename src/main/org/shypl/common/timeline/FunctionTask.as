package org.shypl.common.timeline {
	public class FunctionTask extends AbstractTask {
		private var _task:Function;
		private var _obtainTime:Boolean;
		private var _notRepeatable:Boolean;

		public function FunctionTask(task:Function, obtainTime:Boolean, repeatable:Boolean) {
			_task = task;
			_obtainTime = obtainTime;
			_notRepeatable = !repeatable;
		}

		override protected function doExecute(time:int):void {
			if (_obtainTime) {
				_task(time);
			}
			else {
				_task();
			}

			if (_notRepeatable) {
				cancel();
			}
		}

		internal function handleEnterFrame(time:int):void {
			if (_obtainTime) {
				_task(time);
			}
			else {
				_task();
			}
			if (_notRepeatable) {
				_canceled = true;
			}
		}

		public function execute(frameTime:int):Boolean {
			if (!_canceled) {


			}

			return !_canceled;
		}
	}
}
