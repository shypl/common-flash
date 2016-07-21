package org.shypl.common.collection {
	public interface MapIterator {
		function get key():*;
		
		function get value():*;
		
		function set value(value:*):void;
		
		function get entity():MapEntry;
		
		function next():Boolean;
		
		function remove():void;
	}
}
