package org.shypl.common.util {
	public class ExecutableFunction implements Executable {
		private var _fn:Function;

		public function ExecutableFunction(fn:Function) {
			_fn = fn;
		}

		public function execute():void {
			_fn.apply();
			_fn = null;
		}
	}
}
