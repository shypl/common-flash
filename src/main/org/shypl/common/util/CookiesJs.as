package org.shypl.common.util {
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	import org.shypl.common.lang.UnsupportedOperationException;
	
	public class CookiesJs implements Parameters {
		private var _prefix:String;
		
		public function CookiesJs(prefix:String) {
			_prefix = prefix;
			ExternalInterface.call(new CookiesJsAdapter().toString());
		}
		
		public function contains(name:String):Boolean {
			var value:* = callGet(name);
			return value !== undefined || value !== null;
		}
		
		public function set(name:String, value:Object):void {
			callSet(name, value);
		}
		
		public function setIfAbsent(name:String, value:Object):void {
			if (!contains(name)) {
				set(name, value);
			}
		}
		
		public function get(name:String, defaultValue:Object = null):Object {
			return callGet(name);
		}
		
		public function remove(name:String):void {
			callRemove(name);
		}
		
		public function setBoolean(name:String, value:Boolean):void {
			set(name, value);
		}
		
		public function getBoolean(name:String, defaultValue:Boolean = false):Boolean {
			return get(name, defaultValue);
		}
		
		public function setInt(name:String, value:int):void {
			set(name, value);
		}
		
		public function getInt(name:String, defaultValue:int = 0):int {
			return int(get(name, defaultValue));
		}
		
		public function setNumber(name:String, value:Number):void {
			set(name, value);
		}
		
		public function getNumber(name:String, defaultValue:Number = 0):Number {
			return Number(get(name, defaultValue));
		}
		
		public function setString(name:String, value:String):void {
			set(name, value);
		}
		
		public function getString(name:String, defaultValue:String = null):String {
			return String(get(name, defaultValue));
		}
		
		public function setByteArray(name:String, value:ByteArray):void {
			throw new UnsupportedOperationException();
		}
		
		public function getByteArray(name:String, defaultValue:ByteArray = null):ByteArray {
			throw new UnsupportedOperationException();
		}
		
		private function callSet(name:String, value:Object):void {
			ExternalInterface.call("Cookies.set", prepareKey(name), value, {expires: 120 * (60 * 60 * 24)});
		}
		
		private function callGet(name:String):* {
			return ExternalInterface.call("Cookies.get", prepareKey(name));
		}
		
		private function callRemove(name:String):void {
			ExternalInterface.call("Cookies.expire", prepareKey(name));
		}
		
		private function prepareKey(key:String):String {
			return _prefix + "_" + key;
		}
	}
}
