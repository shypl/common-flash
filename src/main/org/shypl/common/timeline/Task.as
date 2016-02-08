package org.shypl.common.timeline {
	internal class Task implements TimelineTask {

		private var _task:Function;
		private var _obtainTime:Boolean;
		private var _canceled:Boolean;
		private var _notRepeatable:Boolean;

		public function Task(task:Function, obtainTime:Boolean, repeatable:Boolean) {
			_task = task;
			_obtainTime = obtainTime;
			_notRepeatable = !repeatable;
		}

		internal final function get canceled():Boolean {
			return _canceled;
		}

		public final function cancel():void {
			_canceled = true;
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
	}
}
