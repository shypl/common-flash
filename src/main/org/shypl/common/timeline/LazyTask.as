package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.ExecutableClosure;
	
	internal class LazyTask extends ExecutableClosure implements Cancelable {
		private var _canceled:Boolean;
		
		public function LazyTask(closure:Function) {
			super(closure);
		}
		
		override public function execute():void {
			if (!_canceled) {
				super.execute();
			}
		}
		
		public function cancel():void {
			if (!_canceled) {
				_canceled = true;
				free();
			}
		}
	}
}
