package org.shypl.common.util {
	import flash.net.SharedObject;

	public class Cookies extends Parameters {
		private var _sharedObject:SharedObject;
		private var _data:Object;

		public function Cookies(storageName:String = "cookies", sharedName:String = null) {
			_sharedObject = SharedObject.getLocal(storageName, sharedName);
			_data = _sharedObject.data;
		}

		override public function contains(name:String):Boolean {
			return name in _data;
		}

		public function set(name:String, value:Object):void {
			_data[name] = value;
			save();
		}

		public function remove(name:String):void {
			delete _data[name];
			save();
		}

		override protected function extract(name:String):Object {
			return _data[name];
		}

		private function save():void {
			_sharedObject.flush();
		}
	}
}
