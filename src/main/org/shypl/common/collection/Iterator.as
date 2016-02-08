package org.shypl.common.collection {
	public interface Iterator {
		function get element():Object;

		function set element(value:Object):void;

		function next():Boolean;

		function remove():void;
	}
}
