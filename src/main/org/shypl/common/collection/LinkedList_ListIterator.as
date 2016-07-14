package org.shypl.common.collection {
	import org.shypl.common.lang.IllegalStateException;
	
	internal class LinkedList_ListIterator implements ListIterator {
		private var _list:LinkedList;
		private var _expectedModCount:int;
		private var _next:LinkedNode;
		private var _index:int;
		private var _current:LinkedNode;
		private var _reversed:Boolean;

		public function LinkedList_ListIterator(linkedList:LinkedList, index:int, reversed:Boolean) {
			_list = linkedList;
			_expectedModCount = _list._modCount;

			_reversed = reversed;
			_next = _list.getNodeAt(index);
			_index = _reversed ? (index + 1) : (index - 1);
		}

		public function get element():* {
			if (_current === null) {
				throw new IllegalStateException();
			}
			return _current.value;
		}

		public function set element(value:*):void {
			if (_current == null) {
				throw new IllegalStateException();
			}
			checkForModification();
			_current.value = value;
		}

		public function get index():int {
			return _index;
		}

		public function next():Boolean {
			checkForModification();
			if (_next === null) {
				return false;
			}
			_current = _next;
			_next = _reversed ? _current.prev : _current.next;
			_index = _reversed ? (_index - 1) : (_index + 1);
			return true;
		}

		public function remove():void {
			checkForModification();
			if (_current == null) {
				throw new IllegalStateException();
			}

			_next = _reversed ? _current.prev : _current.next;
			_list.unlink(_current);

			if (!_reversed) {
				--_index;
			}

			_current = null;
			_expectedModCount++;
		}

		internal final function checkForModification():void {
			if (_list._modCount != _expectedModCount) {
				throw new ConcurrentModificationException();
			}
		}
	}
}
