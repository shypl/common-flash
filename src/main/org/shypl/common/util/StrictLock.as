package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;
	
	public class StrictLock implements Lock {
		private var _locked:Boolean;
		
		public final function get locked():Boolean {
			return _locked;
		}
		
		public final function lock():void {
			if (_locked) {
				throw new IllegalStateException("Already locked");
			}
			else {
				_locked = true;
				doLock();
			}
		}
		
		public final function unlock():void {
			if (_locked) {
				_locked = false;
				doUnlock();
			}
			else {
				throw new IllegalStateException("Already unlocked");
			}
		}
		
		protected function doLock():void {
		}
		
		protected function doUnlock():void {
		}
	}
}
