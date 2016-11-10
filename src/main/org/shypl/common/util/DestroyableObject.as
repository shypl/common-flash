package org.shypl.common.util {
	public class DestroyableObject implements CheckableDestroyable {
		private var _destroyed:Boolean;
		private var _destroying:Boolean;
		
		public function DestroyableObject() {
		}
		
		public final function get destroyed():Boolean {
			return _destroyed;
		}
		
		public final function destroy():void {
			if (!_destroyed && !_destroying) {
				_destroying = true;
				doDestroy();
				_destroyed = true;
			}
		}
		
		protected function doDestroy():void {
		}
	}
}
