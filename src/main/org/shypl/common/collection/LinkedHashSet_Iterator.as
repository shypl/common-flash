package org.shypl.common.collection {
	internal class LinkedHashSet_Iterator implements Iterator {
		private var _set:LinkedHashSet;
		private var _current:LinkedNode;
		private var _next:LinkedNode;
		private var _expectedModCount:int;
		
		public function LinkedHashSet_Iterator(set:LinkedHashSet, next:LinkedNode) {
			_set = set;
			_next = next;
			_expectedModCount = _set._modCount;
		}
		
		public function get element():* {
			checkCurrent();
			return _current.value;
		}
		
		public function set element(value:*):void {
			checkCurrent();
			_current.value = value;
		}
		
		public function next():Boolean {
			checkForModification();
			if (_next === null) {
				_current = null;
				return false;
			}
			_current = _next;
			_next = _current.next;
			return true;
		}
		
		public function remove():void {
			checkForModification();
			_set.remove(_current.value);
			_expectedModCount = _set._modCount;
			_current = null;
		}
		
		protected final function checkForModification():void {
			if (_set._modCount != _expectedModCount) {
				throw new ConcurrentModificationException();
			}
		}
		
		private function checkCurrent():void {
			if (_current === null) {
				throw new NoSuchElementException();
			}
		}
	}
}