package org.shypl.common.util {
	public class LockableExecutor extends StrictLock {
		private var _pendingTasks:Vector.<Executable> = new Vector.<Executable>();
		
		public function LockableExecutor() {
		}
		
		public function execute(task:Executable):void {
			if (locked) {
				_pendingTasks.push(task);
			}
			else {
				task.execute();
			}
		}
		
		public function executeFunction(closure:Function, ...arguments):void {
			if (locked) {
				_pendingTasks.push(new ExecutableClosure(closure, arguments));
			}
			else {
				closure.apply(null, arguments);
			}
		}
		
		override protected function doUnlock():void {
			super.doUnlock();
			executePendingTasks();
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
