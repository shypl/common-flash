package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;
	
	public class AccumulatedLock implements Lock {
		private var _accumulator:int;
		
		public final function get locked():Boolean {
			return _accumulator > 0;
		}
		
		public final function lock():void {
			if (++_accumulator == 1) {
				doLock();
			}
		}
		
		public final function unlock():void {
			if (_accumulator === 0) {
				throw new IllegalStateException("Already unlocked");
			}
			if (--_accumulator === 0) {
				doUnlock();
			}
		}
		
		protected function doLock():void {
		}
		
		protected function doUnlock():void {
		}
	}
}
