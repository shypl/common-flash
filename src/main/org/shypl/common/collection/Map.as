package org.shypl.common.collection {
	public interface Map {
		function get length():int;

		function size():int;

		function isEmpty():Boolean;

		function put(key:Object, value:Object):*;

		function get(key:Object):*;

		function remove(key:Object):*;

		function containsKey(key:Object):Boolean;

		function containsValue(value:Object):Boolean;

		function iterator():MapIterator

		function putAll(map:Object):void;

		function clear():void;

		function entries():Vector.<MapEntry>;

		function keys():Array;

		function values():Array;

		function toString():String;
	}
}
