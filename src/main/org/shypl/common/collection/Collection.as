package org.shypl.common.collection {
	public interface Collection extends Iterable {
		function get length():int;
		
		function size():int;
		
		function isEmpty():Boolean;
		
		function clear():void;
		
		function add(element:Object):Boolean;
		
		function addAll(collection:Object):Boolean;
		
		function contains(element:Object):Boolean;
		
		function containsAll(collection:Object):Boolean;
		
		function remove(element:Object):Boolean;
		
		function removeAll(collection:Object):Boolean;
		
		function toArray():Array;
		
		function toVector(elementClass:Class):*;
		
		function toString():String;
	}
}