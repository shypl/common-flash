package org.shypl.common.util {
	import flash.net.SharedObject;

	public class Cookies extends ParametersObject {
		private var _sharedObject:SharedObject;
		
		public function Cookies(storageName:String = "cookies", sharedName:String = null) {
			_sharedObject = SharedObject.getLocal(storageName, sharedName);
			super(_sharedObject.data);
		}
		
		override public function remove(name:String):void {
			super.remove(name);
			save();
		}
		
		override public function set(name:String, value:Object):void {
			super.set(name, value);
			save();
		}
		
		private function save():void {
			try {
				_sharedObject.flush();
			}
			catch (ignored:Error) {
			}
		}
	}
}
