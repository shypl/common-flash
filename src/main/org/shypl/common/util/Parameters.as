package org.shypl.common.util {
	import flash.utils.ByteArray;

	public interface Parameters {

		function setBoolean(name:String, value:Boolean):void;

		function setInt(name:String, value:int):void;

		function setNumber(name:String, value:Number):void;

		function setString(name:String, value:String):void;

		function setByteArray(name:String, value:ByteArray):void;

		function getBoolean(name:String, defaultValue:Boolean = false):Boolean;

		function getInt(name:String, defaultValue:int = 0):int;

		function getNumber(name:String, defaultValue:Number = 0):Number;

		function getString(name:String, defaultValue:String = null):String;

		function getByteArray(name:String, defaultValue:ByteArray = null):ByteArray;

		function contains(name:String):Boolean;

		function remove(name:String):void;
	}
}
