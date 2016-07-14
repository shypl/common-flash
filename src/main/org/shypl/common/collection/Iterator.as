package org.shypl.common.collection {
	public interface Iterator {
		function get element():*;

		function set element(value:*):void;

		function next():Boolean;

		function remove():void;
	}
}
