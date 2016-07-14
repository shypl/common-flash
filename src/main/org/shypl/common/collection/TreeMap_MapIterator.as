package org.shypl.common.collection {
	import org.shypl.common.lang.IllegalStateException;
	
	internal class TreeMap_MapIterator implements MapIterator {
		private var _map:TreeMap;
		private var _expectedModCount:int;
		private var _current:TreeMapEntry;
		private var _next:TreeMapEntry;

		public function TreeMap_MapIterator(map:TreeMap, first:TreeMapEntry) {
			_map = map;
			_expectedModCount = map._modCount;
			_current = null;
			_next = first;
		}

		public function get key():* {
			return _current.key;
		}

		public function get value():* {
			return _current.value;
		}

		public function set value(value:*):void {
			_current.value = value;
		}

		public function next():Boolean {
			if (_next === null) {
				return false;
			}

			_current = _next;

			if (_map._modCount !== _expectedModCount) {
				throw new ConcurrentModificationException();
			}
			_next = TreeMap.successor(_next);

			return true;
		}

		public function remove():void {
			if (_current === null) {
				throw new IllegalStateException();
			}

			if (_map._modCount !== _expectedModCount) {
				throw new ConcurrentModificationException();
			}

			if (_current.left !== null && _current.right !== null) {
				_next = _current;
			}

			_map.deleteEntry(_current);
			_expectedModCount = _map._modCount;
			_current = null;
		}
	}
}
