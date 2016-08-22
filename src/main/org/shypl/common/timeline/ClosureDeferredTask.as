package org.shypl.common.timeline {
	public class ClosureDeferredTask extends DeferredTask {
		private var _closure:Function;
		private var _arguments:Array;
		
		public function ClosureDeferredTask(closure:Function, arguments:Array = null) {
			super();
			_closure = closure;
			_arguments = arguments;
		}
		
		override protected function free():void {
			super.free();
			_closure = null;
			_arguments = null;
		}
		
		override protected function execute():void {
			_closure.apply(null, _arguments);
		}
	}
}
