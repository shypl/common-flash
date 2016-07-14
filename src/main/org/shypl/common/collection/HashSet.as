package org.shypl.common.collection {
	import flash.utils.Dictionary;

	import org.shypl.common.util.CollectionUtils;
	
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

		override public function toArray():Array {
			var array:Array = [];
			for (var e:Object in _map) {
				array.push(e);
			}
			return array;
		}

		override public function toVector(elementClass:Class):* {
			var vector:Object = CollectionUtils.createVector(elementClass, size(), true);
			var i:int = 0;
			for (var e:Object in _map) {
				vector[i++] = e;
			}
			return vector;
		}

		//TODO other methods
	}
}
