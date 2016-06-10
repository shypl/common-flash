package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class Executor implements Lock {
		private var _pendingTasks:Vector.<Executable> = new Vector.<Executable>();
		private var _locked:Boolean;

		public function Executor() {
		}

		public function get locked():Boolean {
			return _locked;
		}

		public function lock():void {
			if (_locked) {
				throw new IllegalStateException("Executor is already locked");
			}
			_locked = true;
		}

		public function unlock():void {
			if (!_locked) {
				throw new IllegalStateException("Executor is not locked");
			}
			executePendingTasks();
			_locked = false;
		}

		public function execute(task:Executable):void {
			if (_locked) {
				_pendingTasks.push(task);
			}
			else {
				task.execute();
			}
		}

		public function executeFunction(task:Function):void {
			if (_locked) {
				_pendingTasks.push(new ExecutableFunction(task));
			}
			else {
				task.apply();
			}
		}

		private function executePendingTasks():void {
			var tasks:Vector.<Executable> = _pendingTasks.concat();
			_pendingTasks.length = 0;

			for each (var task:Executable in tasks) {
				task.execute();
			}

			if (_pendingTasks.length != 0) {
				executePendingTasks();
			}
		}
	}
}
