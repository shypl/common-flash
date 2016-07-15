package org.shypl.common.timeline {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.Cancelable;
	
	[Abstract]
	internal class TimedTask implements Cancelable {
		private var _notRepeatable:Boolean;
		private var _canceled:Boolean;
		
		public function TimedTask(repeatable:Boolean) {
			_notRepeatable = !repeatable;
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
		
		protected function tryExecute(passedTime:int):Boolean {
			execute(passedTime);
			return true;
		}
		
		[Abstract]
		protected function execute(passedTime:int):void {
			throw new AbstractMethodException();
		}
		
		internal function tryExecuteAndGetCanceled(passedTime:int):Boolean {
			if (_canceled) {
				return true;
			}
			
			if (tryExecute(passedTime) && _notRepeatable) {
				cancel();
			}
			
			return _canceled;
		}
	}
}
