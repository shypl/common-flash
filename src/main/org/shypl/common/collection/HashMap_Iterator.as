package org.shypl.common.collection {
	internal class HashMap_Iterator implements MapIterator {
		private var _map:HashMap;
		private var _entries:Vector.<MapEntry>;
		private var _current:MapEntry;
		private var _cursor:int;
		private var _expectedModCount:int;
		private var _entriesLength:uint;
		
		public function HashMap_Iterator(hashMap:HashMap) {
			_map = hashMap;
			_expectedModCount = _map._modCount;
			_entries = hashMap.getEntries();
			_entriesLength = _entries.length;
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
		
		public function get entity():MapEntry {
			checkCurrent();
			return _current;
		}
		
		public function next():Boolean {
			if (_cursor < _entriesLength) {
				_current = _entries[_cursor++];
				return true;
			}
			_current = null;
			return false;
		}
		
		public function remove():void {
			checkForModification();
			_map.remove(_current.key);
			_expectedModCount = _map._modCount;
			_entries[_cursor++] = null;
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
