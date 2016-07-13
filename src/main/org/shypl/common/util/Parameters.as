package org.shypl.common.util {
	import flash.utils.ByteArray;

	public interface Parameters {
		function contains(name:String):Boolean;
		
		function set(name:String, value:Object):void;

		function setIfAbsent(name:String, value:Object):void;

		function get(name:String, defaultValue:Object = null):Object;

		function remove(name:String):void;

		function setBoolean(name:String, value:Boolean):void;

		function getBoolean(name:String, defaultValue:Boolean = false):Boolean;

		function setInt(name:String, value:int):void;

		function getInt(name:String, defaultValue:int = 0):int;

		function setNumber(name:String, value:Number):void;

		function getNumber(name:String, defaultValue:Number = 0):Number;

		function setString(name:String, value:String):void;

		function getString(name:String, defaultValue:String = null):String;

		function setByteArray(name:String, value:ByteArray):void;

		function getByteArray(name:String, defaultValue:ByteArray = null):ByteArray;

	}
}
