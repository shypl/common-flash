package org.shypl.common.collection {
	import flash.utils.flash_proxy;
	
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.lang.IndexOutOfBoundsException;
	
	use namespace flash_proxy;

	[Abstract]
	public class AbstractList extends AbstractCollection implements List {

		internal var _modCount:int = 0;

		public function AbstractList() {
		}

		override public function clear():void {
			removeRange(0, size());
		}

		override public function add(element:Object):Boolean {
			addAt(size(), element);
			return true;
		}

		override public function iterator():Iterator {
			return listIterator();
		}

		[Abstract]
		public function addAt(index:int, element:Object):void {
			throw new AbstractMethodException();
		}

		public function addAllAt(index:int, collection:Object):Boolean {
			checkIndexForAdd(index);
			var modified:Boolean;
			for each (var element:Object in collection) {
				addAt(index++, element);
				modified = true;
			}
			return modified;
		}

		[Abstract]
		public function get(index:int):* {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function set(index:int, element:Object):* {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function removeAt(index:int):* {
			throw new AbstractMethodException();
		}

		public function indexOf(element:Object):int {
			var i:int = 0;
			for each (var e:Object in this) {
				if (e === element) {
					return i;
				}
				++i;
			}
			return -1;
		}

		public function lastIndexOf(element:Object):int {
			var it:ListIterator = listIteratorReversed();
			while (it.next()) {
				if (element === it.element) {
					return it.index;
				}
			}
			return -1;
		}

		public function listIterator(index:int = 0):ListIterator {
			checkIndex(index);
			return new AbstractList_ListIterator(this, index, false);
		}

		public function listIteratorReversed(index:int = -1):ListIterator {
			if (index < 0) {
				index = size() + index;
			}
			checkIndex(index);
			return new AbstractList_ListIterator(this, index, true);
		}

		protected function checkIndexForAdd(index:int):void {
			if (index < 0 || index > size()) {
				throw new IndexOutOfBoundsException(getOutOfBoundsMessage(index));
			}
		}

		protected function checkIndex(index:int):void {
			if (index < 0 && index >= size()) {
				throw new IndexOutOfBoundsException(getOutOfBoundsMessage(index));
			}
		}

		internal function removeRange(fromIndex:int, toIndex:int):void {
			var it:ListIterator = listIterator(fromIndex);
			for (var i:int = 0, n:int = toIndex - fromIndex; i < n; i++) {
				it.next();
				it.remove();
			}
		}

		private function getOutOfBoundsMessage(index:int):String {
			return "Index: " + index + ", Size: " + size();
		}

		///

		override flash_proxy function getProperty(name:*):* {
			if (name is int) {
				return get(name);
			}
			if (name is String) {
				return get(parseInt(name));
			}
			throw new IllegalArgumentException();
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			if (name is int) {
				set(name, value);
			}
			else if (name is String) {
				set(parseInt(name), value);
			}
			else {
				throw new IllegalArgumentException();
			}
		}
	}
}




