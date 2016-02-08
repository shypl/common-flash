package org.shypl.common.collection {
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.lang.IndexOutOfBoundsException;

	internal class AbstractList_ListIterator implements ListIterator {
		private var _list:AbstractList;
		private var _reversed:Boolean;
		private var _index:int;
		private var _element:Object;
		private var _elementExists:Object;
		private var _expectedModCount:int;

		public function AbstractList_ListIterator(list:AbstractList, index:int, reversed:Boolean) {
			_list = list;
			_expectedModCount = _list._modCount;
			_reversed = reversed;
			_index = _reversed ? (index + 1) : (index - 1);
		}

		public function get element():Object {
			if (_elementExists) {
				return _element;
			}
			throw new IllegalStateException();
		}

		public function set element(value:Object):void {
			if (_elementExists) {
				checkModification();

				try {
					_list.set(_index, element);
				}
				catch (e:IndexOutOfBoundsException) {
					throw new ConcurrentModificationException();
				}

				_expectedModCount = _list._modCount;
			}
			else {
				throw new IllegalStateException();
			}
		}

		public function get index():int {
			return _index;
		}

		public function next():Boolean {
			checkModification();

			var i:int = _reversed ? (_index - 1) : (_index + 1);

			if (i >= 0 && i < _list.size()) {
				try {
					_element = _list.get(i);
				}
				catch (e:IndexOutOfBoundsException) {
					checkModification();
					throw new NoSuchElementException();
				}
				_index = i;
				_elementExists = true;
			}
			return _elementExists;
		}

		public function remove():void {
			if (_elementExists) {
				checkModification();

				try {
					_list.removeAt(_index);
				}
				catch (e:IndexOutOfBoundsException) {
					throw new ConcurrentModificationException();
				}

				if (!_reversed) {
					--_index;
				}
				_elementExists = false;
				_expectedModCount = _list._modCount;
			}
			else {
				throw new IllegalStateException();
			}
		}

		protected final function checkModification():void {
			if (_list._modCount != _expectedModCount) {
				throw new ConcurrentModificationException();
			}
		}
	}
}
