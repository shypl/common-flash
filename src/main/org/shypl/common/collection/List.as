package org.shypl.common.collection {
	public interface List extends Collection {
		function addAt(index:int, element:Object):void;

		function addAllAt(index:int, collection:Object):Boolean;

		function set(index:int, element:Object):Object;

		function get(index:int):Object;

		function removeAt(index:int):Object;

		function indexOf(element:Object):int;

		function lastIndexOf(element:Object):int;

		function listIterator(index:int = 0):ListIterator

		function listIteratorReversed(index:int = -1):ListIterator
	}
}
