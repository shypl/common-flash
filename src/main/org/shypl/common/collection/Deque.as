package org.shypl.common.collection {
	public interface Deque extends Collection {
		function addFirst(element:Object):void;

		function addLast(element:Object):void;

		function removeFirst():Object;

		function removeLast():Object;

		function getFirst():Object;

		function getLast():Object;
	}
}
