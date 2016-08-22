package org.shypl.common.timeline {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.Cancelable;
	
	public class DeferredTask implements Cancelable {
		private var _canceled:Boolean;
		private var _nextTask:DeferredTask;
		
		public function DeferredTask() {
		}
		
		public final function get canceled():Boolean {
			return _canceled;
		}
		
		public final function cancel():void {
			if (!_canceled) {
				_canceled = true;
				free();
			}
		}
		
		protected function free():void {
		}
		
		[Abstract]
		protected function execute():void {
			throw new AbstractMethodException();
		}
		
		internal final function setNextTask(value:DeferredTask):void {
			_nextTask = value;
		}
		
		internal final function tryExecute():void {
			if (!_canceled) {
				execute();
			}
			free();
		}
		
		internal final function nextTask():DeferredTask {
			var next:DeferredTask = _nextTask;
			_nextTask = null;
			return next;
		}
	}
}
