package org.shypl.common.collection {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.lang.UnsupportedOperationException;

	use namespace flash_proxy;

	public class LiteLinkedList extends Proxy {
		private var _size:int;
		private var _first:LinkedNode;
		private var _last:LinkedNode;

		private var _iteration:Boolean;
		private var _current:LinkedNode;
		private var _next:LinkedNode;

		public function LiteLinkedList() {
		}

		public function get current():* {
			if (!_iteration || _current === null) {
				throw new IllegalArgumentException();
			}
			return _current.value;
		}

		public function size():int {
			return _size;
		}

		public function isEmpty():Boolean {
			return _size === 0;
		}

		public function contains(element:Object):Boolean {
			return getNode(element) !== null;
		}

		public function add(element:Object):Boolean {
			checkIteration();
			linkLast(element);
			return true;
		}

		public function remove(element:Object):Boolean {
			checkIteration();

			var node:LinkedNode = getNode(element);
			if (node === null) {
				return false;
			}

			unlink(node);
			return true;
		}

		public function clear():void {
			checkIteration();

			for (var x:LinkedNode = _first; x !== null;) {
				var next:LinkedNode = x.next;
				x.destroy();
				x = next;
			}
			_first = null;
			_last = null;
			_size = 0;
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

		public function stopIteration():void {
			if (_iteration) {
				_iteration = false;
				_current = null;
				_next = null;
			}
		}

		public function removeCurrent():void {
			if (!_iteration || _current === null) {
				throw new IllegalArgumentException();
			}
			unlink(_current);
			_current = null;
		}

		protected function checkIteration():void {
			if (_iteration) {
				throw new ConcurrentModificationException();
			}
		}

		protected function getNode(element:Object):LinkedNode {
			for (var node:LinkedNode = _first; node !== null; node = node.next) {
				if (node.value === element) {
					return node;
				}
			}
			return null;
		}

		protected function linkLast(element:Object):LinkedNode {
			var last:LinkedNode = _last;
			var node:LinkedNode = new LinkedNode(last, element, null);
			_last = node;
			if (last === null) {
				_first = node;
			}
			else {
				last.next = node;
			}
			++_size;

			return node;
		}

		protected function unlink(node:LinkedNode):void {
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
			--_size;
		}

		//

		override flash_proxy function getProperty(name:*):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function callProperty(name:*, ...rest):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function hasProperty(name:*):Boolean {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function deleteProperty(name:*):Boolean {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function getDescendants(name:*):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function nextNameIndex(index:int):int {
			return next() ? index + 1 : 0;
		}

		override flash_proxy function nextName(index:int):String {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function nextValue(index:int):* {
			return current;
		}

		override flash_proxy function isAttribute(name:*):Boolean {
			throw new UnsupportedOperationException();
		}
	}
}
