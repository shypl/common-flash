package org.shypl.common.util {
	import flash.net.SharedObject;
	
	import org.shypl.common.lang.notNull;
	
	public class Cookies extends ParametersObject {
		private var _sharedObject:SharedObject;
		
		public function Cookies(storageName:String = "cookies", sharedName:String = null) {
			var data:Object;
			try {
				_sharedObject = SharedObject.getLocal(storageName, sharedName);
				data = _sharedObject.data;
			}
			catch (ignored:Error) {
				data = {};
			}
			super(data);
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
			if (notNull(_sharedObject)) {
				try {
					_sharedObject.flush();
				}
				catch (ignored:Error) {
					
				}
			}
		}
	}
}
