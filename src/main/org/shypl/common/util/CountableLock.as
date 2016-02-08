package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class CountableLock implements Lock {
		private var _counter:int;

		public function CountableLock() {
		}

		public function get locked():Boolean {
			return _counter != 0;
		}

		public function lock():void {
			++_counter;
		}

		public function unlock():void {
			if (_counter == 0) {
				throw new IllegalStateException("Lock is not locked");
			}
			--_counter;
		}
	}
}
