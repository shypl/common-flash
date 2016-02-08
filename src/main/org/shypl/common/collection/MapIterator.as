package org.shypl.common.collection {
	public interface MapIterator {
		function get key():Object;

		function get value():Object;

		function set value(value:Object):void;

		function next():Boolean;

		function remove():void;
	}
}
