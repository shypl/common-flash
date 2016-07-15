package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;
	
	public class ChangeExecutor implements Lock {
		private var _pendingTasks:Vector.<Executable> = new Vector.<Executable>();
		private var _locked:Boolean;
		
		public function ChangeExecutor() {
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
			_locked = false;
			executePendingTasks();
		}
		
		public function execute(task:Executable):void {
			if (_locked) {
				_pendingTasks.push(task);
			}
			else {
				task.execute();
			}
		}
		
		public function executeFunction(closure:Function):void {
			if (_locked) {
				_pendingTasks.push(new ExecutableClosure(closure));
			}
			else {
				closure();
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
