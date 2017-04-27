package org.shypl.common.util {
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	public class Cookies implements Parameters {
		private var _engine:Parameters;
		
		public function Cookies(prefix:String = "cookies") {
			_engine = ExternalInterface.available ? new CookiesJs(prefix) : new CookiesSo(prefix);
		}
		
		public function contains(name:String):Boolean {
			return _engine.contains(name);
		}
		
		public function setIfAbsent(name:String, value:Object):void {
			_engine.setIfAbsent(name, value);
		}
		
		public function get(name:String, defaultValue:Object = null):Object {
			return _engine.get(name, defaultValue);
		}
		
		public function setBoolean(name:String, value:Boolean):void {
			_engine.setBoolean(name, value);
		}
		
		public function getBoolean(name:String, defaultValue:Boolean = false):Boolean {
			return _engine.getBoolean(name, defaultValue);
		}
		
		public function setInt(name:String, value:int):void {
			_engine.setInt(name, value);
		}
		
		public function getInt(name:String, defaultValue:int = 0):int {
			return _engine.getInt(name, defaultValue);
		}
		
		public function setNumber(name:String, value:Number):void {
			_engine.setNumber(name, value);
		}
		
		public function getNumber(name:String, defaultValue:Number = 0):Number {
			return _engine.getNumber(name, defaultValue);
		}
		
		public function setString(name:String, value:String):void {
			_engine.setString(name, value);
		}
		
		public function getString(name:String, defaultValue:String = null):String {
			return _engine.getString(name, defaultValue);
		}
		
		public function setByteArray(name:String, value:ByteArray):void {
			_engine.setByteArray(name, value);
		}
		
		public function getByteArray(name:String, defaultValue:ByteArray = null):ByteArray {
			return _engine.getByteArray(name, defaultValue);
		}
		
		public function set(name:String, value:Object):void {
			_engine.set(name, value);
		}
		
		public function remove(name:String):void {
			_engine.remove(name);
		}
	}
}
