package org.shypl.common.collection {
	import flash.utils.Dictionary;
	
	import org.shypl.common.util.CollectionUtils;
	
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
			_first = null;
			_last = null;
			_size = 0;
			++_modCount;
		}
		
		override public function iterator():Iterator {
			return new LinkedHashSet_Iterator(this, _first);
		}
		
		override public function toArray():Array {
			var array:Array = [];
			for (var x:LinkedNode = _first; x != null; x = x.next) {
				array.push(x.value);
			}
			return array;
		}
		
		override public function toVector(elementClass:Class):* {
			var vector:Object = CollectionUtils.createVector(elementClass, size(), true);
			var i:int = 0;
			for (var x:LinkedNode = _first; x != null; x = x.next) {
				vector[i++] = x.value;
			}
			return vector;
		}
	}
}
