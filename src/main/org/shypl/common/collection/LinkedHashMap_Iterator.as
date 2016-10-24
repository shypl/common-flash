package org.shypl.common.collection {
	internal class LinkedHashMap_Iterator implements MapIterator {
		private var _map:LinkedHashMap;
		private var _current:LinkedMapEntry;
		private var _next:LinkedMapEntry;
		private var _expectedModCount:int;
		
		public function LinkedHashMap_Iterator(map:LinkedHashMap, next:LinkedMapEntry) {
			_map = map;
			_next = next;
			_expectedModCount = _map._modCount;
		}
		
		public function get key():* {
			checkCurrent();
			return _current.key;
		}
		
		public function get value():* {
			checkCurrent();
			return _current.value;
		}
		
		public function set value(value:*):void {
			checkCurrent();
			_current.value = value;
		}
		
		public function get entry():MapEntry {
			checkCurrent();
			return _current;
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
			_map.remove(_current.key);
			_expectedModCount = _map._modCount;
			_current = null;
		}
		
		protected final function checkForModification():void {
			if (_map._modCount != _expectedModCount) {
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
