package org.shypl.common.util {
	import flash.net.SharedObject;

	public class Cookies {
		private var _sharedObject:SharedObject;
		private var _data:Object;

		public function Cookies(storageName:String, sharedName:String = null) {
			_sharedObject = SharedObject.getLocal(storageName, sharedName);
			_data = _sharedObject.data;
		}

		public function set(name:String, value:Object):void {
			_data[name] = value;
			save();
		}

		public function get(name:String, defaultValue:Object = null):Object {
			if (contains(name)) {
				return _data[name];
			}
			return defaultValue;
		}

		public function remove(name:String):void {
			delete _data[name];
			save();
		}

		public function contains(name:String):Boolean {
			return name in _data;
		}

		public function getBoolean(name:String, defaultValue:Boolean = null):Boolean {
			return Boolean(get(name, defaultValue));
		}

		public function getInt(name:String, defaultValue:int = 0):int {
			return int(get(name, defaultValue));
		}

		public function getUint(name:String, defaultValue:uint = 0):uint {
			return uint(get(name, defaultValue));
		}

		public function getNumber(name:String, defaultValue:uint = 0):Number {
			return Number(get(name, defaultValue));
		}

		public function getString(name:String, defaultValue:String = null):String {
			return get(name, defaultValue) as String;
		}

		private function save():void {
			_sharedObject.flush();
		}
	}
}
