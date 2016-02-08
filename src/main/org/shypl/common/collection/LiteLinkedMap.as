package org.shypl.common.collection {
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.lang.UnsupportedOperationException;

	use namespace flash_proxy;

	public class LiteLinkedMap extends Proxy {
		private var _size:int;
		private var _map:Dictionary = new Dictionary();
		private var _first:LinkedMapEntry;
		private var _last:LinkedMapEntry;

		private var _iteration:Boolean;
		private var _current:LinkedMapEntry;
		private var _next:LinkedMapEntry;

		public function LiteLinkedMap() {
		}

		public function get currentKey():Object {
			if (!_iteration || _current === null) {
				throw new IllegalArgumentException();
			}
			return _current._key;
		}

		public function get currentValue():Object {
			if (!_iteration || _current === null) {
				throw new IllegalArgumentException();
			}
			return _current._value;
		}

		public function size():int {
			return _size;
		}

		public function isEmpty():Boolean {
			return _size === 0;
		}

		public function containsKey(key:Object):Boolean {
			return key in _map;
		}

		public function containsValue(value:Object):Boolean {
			for each (var e:MapEntryImpl in _map) {
				if (e._value === value) {
					return true;
				}
			}
			return false;
		}

		public function put(key:Object, value:Object):Object {
			checkIteration();
			var entry:LinkedMapEntry = _map[key];

			if (entry === null) {
				entry = new LinkedMapEntry(key, value, _last, null);
				if (_first === null) {
					_first = entry;
				}
				else {
					_last.next = entry;
				}
				_last = entry;
				_map[entry._key] = entry;
				++_size;
				return null;
			}

			var v:Object = entry._value;
			entry._value = value;
			return v;
		}

		public function get(key:Object):Object {
			var entry:MapEntryImpl;
			try {
				entry = _map[key];
			}
			catch (e:Error) {
				return null;
			}

			if (entry === null) {
				return null;
			}
			return entry._value;
		}

		public function clear():void {
			checkIteration();
			for each (var entry:LinkedMapEntry in _map) {
				entry.destroy();
			}
			_map = new Dictionary();
			_first = null;
			_last = null;
			_size = 0;
		}

		public function remove(key:Object):Object {
			checkIteration();

			var entry:LinkedMapEntry = _map[key];
			if (entry === null) {
				return null;
			}

			return removeEntry(entry);
		}

		public function next():Boolean {
			if (_iteration) {
				_current = _next;
				if (_current === null) {
					_next = null;
					_iteration = false;
				}
				else {
					_next = _current.next;
				}
			}
			else if (_first !== null) {
				_iteration = true;
				_current = _first;
				_next = _current.next;
			}

			return _iteration;
		}

		public function removeCurrent():void {
			if (!_iteration || _current === null) {
				throw new IllegalArgumentException();
			}
			removeEntry(_current);
			_current = null;
		}

		private function checkIteration():void {
			if (_iteration) {
				throw new ConcurrentModificationException();
			}
		}

		private function removeEntry(entry:LinkedMapEntry):Object {
			var next:LinkedMapEntry = entry.next;
			var prev:LinkedMapEntry = entry.prev;

			if (prev == null) {
				_first = next;
			}
			else {
				prev.next = next;
			}

			if (next == null) {
				_last = prev;
			}
			else {
				next.prev = prev;
			}

			var v:Object = entry._value;
			delete _map[entry._key];
			entry.destroy();
			--_size;
			return v;
		}

		//

		override final flash_proxy function getProperty(name:*):* {
			return get(Utils.extractFlashProxyName(name));
		}

		override final flash_proxy function setProperty(name:*, value:*):void {
			put(Utils.extractFlashProxyName(name), value);
		}

		override final flash_proxy function hasProperty(name:*):Boolean {
			return containsKey(Utils.extractFlashProxyName(name))
		}

		override final flash_proxy function deleteProperty(name:*):Boolean {
			var key:String = Utils.extractFlashProxyName(name);
			if (containsKey(key)) {
				remove(key);
				return true;
			}
			return false;
		}

		override flash_proxy function callProperty(name:*, ...rest):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function getDescendants(name:*):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function nextNameIndex(index:int):int {
			return next() ? index + 1 : 0;
		}

		override flash_proxy function nextName(index:int):String {
			return currentKey.toString();
		}

		override flash_proxy function nextValue(index:int):* {
			return currentValue;
		}

		override flash_proxy function isAttribute(name:*):Boolean {
			throw new UnsupportedOperationException();
		}
	}
}
