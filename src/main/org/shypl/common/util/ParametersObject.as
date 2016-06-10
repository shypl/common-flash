package org.shypl.common.util {
	import flash.utils.ByteArray;

	public class ParametersObject implements Parameters {
		private var _obj:Object;

		public function ParametersObject(obj:Object) {
			_obj = obj;
		}

		public function contains(name:String):Boolean {
			return name in _obj;
		}

		public function remove(name:String):void {
			delete _obj[name];
		}

		public function setBoolean(name:String, value:Boolean):void {
			set(name, value);
		}

		public function setInt(name:String, value:int):void {
			set(name, value);
		}

		public function setNumber(name:String, value:Number):void {
			set(name, value);
		}

		public function setString(name:String, value:String):void {
			set(name, value);
		}

		public function setByteArray(name:String, value:ByteArray):void {
			set(name, value);
		}

		public function getBoolean(name:String, defaultValue:Boolean = false):Boolean {
			return contains(name) ? _obj[name] : defaultValue;
		}

		public function getInt(name:String, defaultValue:int = 0):int {
			return contains(name) ? _obj[name] : defaultValue;
		}

		public function getNumber(name:String, defaultValue:Number = 0):Number {
			return contains(name) ? _obj[name] : defaultValue;
		}

		public function getString(name:String, defaultValue:String = null):String {
			return contains(name) ? _obj[name] : defaultValue;
		}

		public function getByteArray(name:String, defaultValue:ByteArray = null):ByteArray {
			return contains(name) ? _obj[name] : defaultValue;
		}

		protected function set(name:String, value:Object):void {
			_obj[name] = value;
		}
	}
}
