package org.shypl.common.collection {
	import flash.utils.Dictionary;

	public class LinkedHashSet extends HashSet {
		internal var _first:LinkedNode;
		internal var _last:LinkedNode;

		public function LinkedHashSet() {
		}

		override public function add(element:Object):Boolean {
			if (contains(element)) {
				return false;
			}

			var node:LinkedNode = new LinkedNode(_last, element, null);
			if (_last === null) {
				_first = node;
			}
			else {
				_last.next = node;
			}
			_last = node;
			++_size;
			++_modCount;

			_map[element] = node;

			return true;
		}

		override public function remove(element:Object):Boolean {
			var node:LinkedNode = _map[element];
			if (node === null) {
				return false;
			}

			var next:LinkedNode = node.next;
			var prev:LinkedNode = node.prev;

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

			node.destroy();
			delete _map[element];

			--_size;
			++_modCount;

			return true;
		}

		override public function clear():void {
			for each (var node:LinkedNode in _map) {
				node.destroy();
			}
			_map = new Dictionary();
			_size = 0;
			++_modCount;
		}

		override public function iterator():Iterator {
			return new LinkedHashSet_Iterator(this, _first);
		}

		override public function toVector():Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>(_size, true);
			var i:int = 0;
			for (var x:LinkedNode = _first; x != null; x = x.next) {
				result[i++] = x.value;
			}
			return result;
		}
	}
}
