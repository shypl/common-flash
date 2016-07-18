package org.shypl.common.util {
	public class ExecutableClosure implements Executable {
		private var _closure:Function;
		private var _arguments:Array;
		
		public function ExecutableClosure(closure:Function, arguments:Array = null) {
			_closure = closure;
			_arguments = arguments;
		}
		
		public function execute():void {
			_closure.apply(null, _arguments);
			free();
		}
		
		protected function free():void {
			_closure = null;
		}
	}
}
