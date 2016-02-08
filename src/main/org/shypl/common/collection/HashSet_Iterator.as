package org.shypl.common.collection {
	import org.shypl.common.lang.UnsupportedOperationException;

	internal class HashSet_Iterator implements Iterator {
		private var _set:HashSet;
		private var _elements:Vector.<Object>;
		private var _elementsLength:uint;
		private var _cursor:int = 0;
		private var _expectedModCount:int;
		private var _current:Object;
		private var _currentExists:Boolean;

		public function HashSet_Iterator(hashSet:HashSet) {
			_set = hashSet;
			_elements = _set.toVector();
			_elementsLength = _elements.length;
		}

		public function get element():Object {
			checkCurrent();
			return _current;
		}

		public function set element(value:Object):void {
			throw new UnsupportedOperationException();
		}

		public function next():Boolean {
			if (_cursor < _elementsLength) {
				_current = _elements[_cursor++];
				_currentExists = true;
				return true;
			}
			_current = null;
			_currentExists = false;
			return false;
		}

		public function remove():void {
			checkForModification();
			checkCurrent();
			_set.remove(_current);
			_expectedModCount = _set._modCount;
			_elements[_cursor++] = null;
			_current = null;
			_currentExists = false;
		}

		protected final function checkForModification():void {
			if (_set._modCount != _expectedModCount) {
				throw new ConcurrentModificationException();
			}
		}

		private function checkCurrent():void {
			if (!_currentExists) {
				throw new NoSuchElementException();
			}
		}
	}
}
