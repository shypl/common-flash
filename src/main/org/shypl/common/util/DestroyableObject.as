package org.shypl.common.util {
	public class DestroyableObject implements CheckableDestroyable {
		private var _destroyed:Boolean;
		
		public function DestroyableObject() {
		}

		public final function get destroyed():Boolean {
			return _destroyed;
		}
		
		public final function destroy():void {
			if (!_destroyed) {
				_destroyed = true;
				doDestroy();
			}
		}
		
		protected function doDestroy():void {
		}
	}
}
