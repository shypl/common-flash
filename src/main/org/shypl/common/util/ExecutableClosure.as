package org.shypl.common.util {
	public class ExecutableClosure implements Executable {
		private var _closure:Function;
		
		public function ExecutableClosure(closure:Function) {
			_closure = closure;
		}
		
		public function execute():void {
			_closure.call();
			free();
		}
		
		protected function free():void {
			_closure = null;
		}
	}
}
