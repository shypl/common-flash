package org.shypl.common.collection {
	import flash.utils.Dictionary;

	public class HashSet extends AbstractSet {
		internal var _map:Dictionary = new Dictionary();
		internal var _size:int;
		internal var _modCount:int;

		public function HashSet() {
		}

		override public function size():int {
			return _size;
		}

		override public function contains(element:Object):Boolean {
			return element in _map;
		}

		override public function add(element:Object):Boolean {
			if (contains(element)) {
				return false;
			}
			++_size;
			++_modCount;
			_map[element] = true;
			return true;
		}

		override public function remove(element:Object):Boolean {
			if (contains(element)) {
				delete _map[element];
				--_size;
				++_modCount;
				return true;
			}
			return false;
		}

		override public function clear():void {
			_map = new Dictionary();
			_size = 0;
			++_modCount;
		}

		override public function iterator():Iterator {
			return new HashSet_Iterator(this);
		}

		override public function toVector():Vector.<Object> {
			if (isEmpty()) {
				return new Vector.<Object>(0, true);
			}

			var result:Vector.<Object> = new Vector.<Object>(_size, true);
			var i:int = 0;
			for (var e:Object in _map) {
				result[i++] = e;
			}

			return result;
		}

		//TODO other methods
	}
}
