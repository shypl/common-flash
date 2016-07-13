package org.shypl.common.collection {
	import flash.utils.flash_proxy;

	import org.shypl.common.util.CollectionUtils;

	use namespace flash_proxy;

	public class LinkedList extends AbstractList implements List, Deque {
		internal var _size:int;
		internal var _first:LinkedNode;
		internal var _last:LinkedNode;

		public function LinkedList(collection:Object = null) {
			if (collection !== null) {
				addAll(collection);
			}
		}

		override public function size():int {
			return _size;
		}

		override public function contains(element:Object):Boolean {
			return indexOf(element) !== -1;
		}

		override public function add(element:Object):Boolean {
			linkLast(element);
			return true;
		}

		override public function remove(element:Object):Boolean {
			for (var node:LinkedNode = _first; node != null; node = node.next) {
				if (element === node.value) {
					unlink(node);
					return true;
				}
			}
			return false;
		}

		override public function addAll(collection:Object):Boolean {
			return addAllAt(_size, collection);
		}

		override public function addAllAt(index:int, collection:Object):Boolean {
			checkIndexForAdd(index);

			if (collection is Collection) {
				collection = Collection(collection).toArray();
			}

			var len:int = collection.length;
			if (len === 0) {
				return false;
			}

			var prev:LinkedNode;
			var next:LinkedNode;

			if (index === _size) {
				next = null;
				prev = _last;
			}
			else {
				next = getNodeAt(index);
				prev = next.prev;
			}

			for each (var element:Object in collection) {
				var newNode:LinkedNode = new LinkedNode(prev, element, null);
				if (prev == null) {
					_first = newNode;
				}
				else {
					prev.next = newNode;
				}
				prev = newNode;
			}

			if (next == null) {
				_last = prev;
			}
			else {
				prev.next = next;
				next.prev = prev;
			}

			_size += len;
			++_modCount;

			return true;
		}

		override public function clear():void {
			for (var x:LinkedNode = _first; x !== null;) {
				var next:LinkedNode = x.next;
				x.destroy();
				x = next;
			}
			_first = null;
			_last = null;
			_size = 0;
			++_modCount;
		}

		override public function get(index:int):Object {
			checkIndex(index);
			return getNodeAt(index).value;
		}

		override public function set(index:int, element:Object):Object {
			checkIndex(index);
			var x:LinkedNode = getNodeAt(index);
			var v:Object = x.value;
			x.value = element;
			return v;
		}

		override public function addAt(index:int, element:Object):void {
			checkIndexForAdd(index);
			if (index == _size) {
				linkLast(element);
			}
			else {
				linkBefore(element, getNodeAt(index));
			}
		}

		override public function removeAt(index:int):Object {
			checkIndex(index);
			return unlink(getNodeAt(index));
		}

		override public function indexOf(element:Object):int {
			var index:int = 0;
			for (var x:LinkedNode = _first; x !== null; x = x.next) {
				if (x.value === element) {
					return index;
				}
				++index;
			}
			return -1;
		}

		override public function lastIndexOf(element:Object):int {
			var index:int = _size;
			for (var x:LinkedNode = _last; x !== null; x = x.prev) {
				--index;
				if (x.value === element) {
					return index;
				}
			}
			return -1;
		}

		override public function listIterator(index:int = 0):ListIterator {
			checkIndex(index);
			return new LinkedList_ListIterator(this, index, false);
		}

		override public function listIteratorReversed(index:int = -1):ListIterator {
			if (index < 0) {
				index = size() + index;
			}
			checkIndex(index);
			return new LinkedList_ListIterator(this, index, true);
		}

		override public function toArray():Array {
			var array:Array = [];
			for (var x:LinkedNode = _first; x != null; x = x.next) {
				array.push(x.value);
			}
			return array;
		}

		override public function toVector(elementClass:Class):Object {
			var vector:Object = CollectionUtils.createVector(elementClass, size(), true);
			var i:int = 0;
			for (var x:LinkedNode = _first; x != null; x = x.next) {
				vector[i++] = x.value;
			}
			return vector;
		}

		public function getFirst():Object {
			if (_first === null) {
				throw new NoSuchElementException();
			}
			return _first.value;
		}

		public function getLast():Object {
			if (_last === null) {
				throw new NoSuchElementException();
			}
			return _last.value;
		}

		public function removeFirst():Object {
			if (_first === null) {
				throw new NoSuchElementException();
			}
			return unlinkFirst(_first);
		}

		public function removeLast():Object {
			if (_last === null) {
				throw new NoSuchElementException();
			}
			return unlinkLast(_last);
		}

		public function addFirst(element:Object):void {
			linkFirst(element);
		}

		public function addLast(element:Object):void {
			linkLast(element);
		}

		internal function linkLast(element:Object):void {
			var last:LinkedNode = _last;
			var newNode:LinkedNode = new LinkedNode(last, element, null);
			_last = newNode;
			if (last === null) {
				_first = newNode;
			}
			else {
				last.next = newNode;
			}
			++_size;
			++_modCount;
		}

		internal function linkBefore(element:Object, node:LinkedNode):void {
			var prev:LinkedNode = node.prev;
			var newNode:LinkedNode = new LinkedNode(prev, element, node);
			node.prev = newNode;
			if (prev === null) {
				_first = newNode;
			}
			else {
				prev.next = newNode;
			}
			++_size;
			++_modCount;
		}

		internal function unlink(node:LinkedNode):Object {
			var element:Object = node.value;
			var next:LinkedNode = node.next;
			var prev:LinkedNode = node.prev;

			if (prev == null) {
				_first = next;
			}
			else {
				prev.next = next;
				node.prev = null;
			}

			if (next == null) {
				_last = prev;
			}
			else {
				next.prev = prev;
				node.next = null;
			}

			node.value = null;
			--_size;
			++_modCount;
			return element;
		}

		internal function getNodeAt(index:int):LinkedNode {
			var x:LinkedNode;
			var i:int;

			if (index < (_size >> 1)) {
				x = _first;
				for (i = 0; i < index; i++) {
					x = x.next;
				}
				return x;
			}

			x = _last;
			for (i = _size - 1; i > index; i--) {
				x = x.prev;
			}
			return x;
		}

		private function linkFirst(element:Object):void {
			var first:LinkedNode = _first;
			var newNode:LinkedNode = new LinkedNode(null, element, first);
			_first = newNode;
			if (first === null) {
				_last = newNode;
			}
			else {
				first.prev = newNode;
			}
			++_size;
			++_modCount;
		}

		private function unlinkFirst(node:LinkedNode):Object {
			var element:Object = node.value;
			var next:LinkedNode = node.next;
			node.value = null;
			node.next = null;
			_first = next;
			if (next == null) {
				_last = null;
			}
			else {
				next.prev = null;
			}
			--_size;
			++_modCount;
			return element;
		}

		private function unlinkLast(node:LinkedNode):Object {
			var element:Object = node.value;
			var prev:LinkedNode = node.prev;
			node.value = null;
			node.prev = null;
			_last = prev;
			if (prev == null) {
				_first = null;
			}
			else {
				prev.next = null;
			}
			--_size;
			++_modCount;
			return element;
		}
	}
}
