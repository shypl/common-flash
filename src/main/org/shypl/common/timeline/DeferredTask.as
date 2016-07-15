package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.ExecutableClosure;
	
	internal class DeferredTask extends ExecutableClosure implements Cancelable {
		private var _canceled:Boolean;
		private var _nextTask:DeferredTask;
		
		public function DeferredTask(closure:Function) {
			super(closure);
		}
		
		override public function execute():void {
			if (!_canceled) {
				super.execute();
				free();
			}
		}
		
		public function cancel():void {
			if (!_canceled) {
				_canceled = true;
				free();
			}
		}
		
		public function setNextTask(value:DeferredTask):void {
			_nextTask = value;
		}
		
		internal function nextTask():DeferredTask {
			var next:DeferredTask = _nextTask;
			_nextTask = null;
			return next;
		}
	}
}
