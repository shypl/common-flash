package org.shypl.common.collection {
	import org.shypl.common.util.Comparator;
	
	public class TreeMap extends AbstractMap implements SortedMap {
		internal static function successor(t:TreeMapEntry):TreeMapEntry {
			if (t === null) {
				return null;
			}
			
			var p:TreeMapEntry;
			
			if (t._right !== null) {
				p = t._right;
				while (p._left !== null) {
					p = p._left;
				}
				return p;
			}
			
			
			p = t._parent;
			var ch:TreeMapEntry = t;
			while (p !== null && ch === p._right) {
				ch = p;
				p = p._parent;
			}
			
			return p;
		}
		
		private static function parentOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p._parent;
		}
		
		private static function leftOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p._left;
		}
		
		private static function rightOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p._right;
		}
		
		private static function colorOf(p:TreeMapEntry):Boolean {
			return p === null ? TreeMapEntry.BLACK : p._color;
		}
		
		private static function setColor(p:TreeMapEntry, c:Boolean):void {
			if (p !== null) {
				p._color = c;
			}
		}
		
		internal var _modCount:int;
		private var _comparator:Comparator;
		private var _root:TreeMapEntry;
		private var _size:int;
		
		public function TreeMap(comparator:Comparator) {
			_comparator = comparator;
		}
		
		override public function size():int {
			return _size;
		}
		
		override public function isEmpty():Boolean {
			return _size === 0;
		}
		
		override public function iterator():MapIterator {
			return new TreeMap_MapIterator(this, getFirstEntry());
		}
		
		override public function put(key:Object, value:Object):* {
			var t:TreeMapEntry = _root;
			if (t === null) {
				_root = new TreeMapEntry(key, value);
				_size = 1;
				_modCount++;
				return null;
			}
			
			var cmp:int;
			var parent:TreeMapEntry;
			do {
				parent = t;
				cmp = _comparator.compare(key, t._key);
				if (cmp < 0) {
					t = t._left;
				}
				else if (cmp > 0) {
					t = t._right;
				}
				else {
					return t._value = value;
				}
			}
			while (t !== null);
			
			var e:TreeMapEntry = new TreeMapEntry(key, value, parent);
			if (cmp < 0) {
				parent._left = e;
			}
			else {
				parent._right = e;
			}
			
			fixAfterInsertion(e);
			
			_size++;
			_modCount++;
			
			return null;
		}
		
		override public function get(key:Object):* {
			var p:TreeMapEntry = getEntry(key);
			return p === null ? null : p._value;
		}
		
		override public function remove(key:Object):* {
			const p:TreeMapEntry = getEntry(key);
			if (p === null) {
				return null;
			}
			
			const value:Object = p._value;
			deleteEntry(p);
			return value;
		}
		
		override public function containsKey(key:Object):Boolean {
			return getEntry(key) !== null;
		}
		
		override public function containsValue(value:Object):Boolean {
			for (var e:TreeMapEntry = getFirstEntry(); e !== null; e = successor(e)) {
				if (value === e._value) {
					return true;
				}
			}
			return false;
		}
		
		override public function clear():void {
			_modCount++;
			_size = 0;
			_root = null;
		}
		
		internal function deleteEntry(p:TreeMapEntry):void {
			_modCount++;
			_size--;
			
			if (p._left !== null && p._right !== null) {
				var s:TreeMapEntry = successor(p);
				p._key = s._key;
				p._value = s._value;
				p = s;
			}
			
			var replacement:TreeMapEntry = p._left !== null ? p._left : p._right;
			
			if (replacement !== null) {
				replacement._parent = p._parent;
				if (p._parent === null) {
					_root = replacement;
				}
				else if (p === p._parent._left) {
					p._parent._left = replacement;
				}
				else {
					p._parent._right = replacement;
				}
				
				p._left = p._right = p._parent = null;
				
				if (p._color === TreeMapEntry.BLACK) {
					fixAfterDeletion(replacement);
				}
			}
			else if (p._parent === null) {
				_root = null;
			}
			else {
				if (p._color === TreeMapEntry.BLACK) {
					fixAfterDeletion(p);
				}
				
				if (p._parent !== null) {
					if (p === p._parent._left) {
						p._parent._left = null;
					}
					else if (p === p._parent._right) {
						p._parent._right = null;
					}
					p._parent = null;
				}
			}
		}
		
		private function getFirstEntry():TreeMapEntry {
			var p:TreeMapEntry = _root;
			if (p !== null) {
				while (p._left !== null) {
					p = p._left;
				}
			}
			return p;
		}
		
		private function getEntry(key:Object):TreeMapEntry {
			var p:TreeMapEntry = _root;
			while (p !== null) {
				var cmp:int = _comparator.compare(key, p._key);
				if (cmp < 0) {
					p = p._left;
				}
				else if (cmp > 0) {
					p = p._right;
				}
				else {
					return p;
				}
			}
			return null;
		}
		
		private function rotateLeft(p:TreeMapEntry):void {
			if (p !== null) {
				var r:TreeMapEntry = p._right;
				p._right = r._left;
				if (r._left !== null) {
					r._left._parent = p;
				}
				r._parent = p._parent;
				if (p._parent === null) {
					_root = r;
				}
				else if (p._parent._left === p) {
					p._parent._left = r;
				}
				else {
					p._parent._right = r;
				}
				r._left = p;
				p._parent = r;
			}
		}
		
		private function rotateRight(p:TreeMapEntry):void {
			if (p !== null) {
				var l:TreeMapEntry = p._left;
				p._left = l._right;
				if (l._right !== null) {
					l._right._parent = p;
				}
				l._parent = p._parent;
				if (p._parent === null) {
					_root = l;
				}
				else if (p._parent._right === p) {
					p._parent._right = l;
				}
				else {
					p._parent._left = l;
				}
				l._right = p;
				p._parent = l;
			}
		}
		
		private function fixAfterInsertion(x:TreeMapEntry):void {
			x._color = TreeMapEntry.RED;
			var y:TreeMapEntry;
			
			while (x !== null && x !== _root && x._parent._color === TreeMapEntry.RED) {
				if (parentOf(x) === leftOf(parentOf(parentOf(x)))) {
					y = rightOf(parentOf(parentOf(x)));
					if (colorOf(y) === TreeMapEntry.RED) {
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(y, TreeMapEntry.BLACK);
						setColor(parentOf(parentOf(x)), TreeMapEntry.RED);
						x = parentOf(parentOf(x));
					}
					else {
						if (x === rightOf(parentOf(x))) {
							x = parentOf(x);
							rotateLeft(x);
						}
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(parentOf(parentOf(x)), TreeMapEntry.RED);
						rotateRight(parentOf(parentOf(x)));
					}
				}
				else {
					y = leftOf(parentOf(parentOf(x)));
					if (colorOf(y) === TreeMapEntry.RED) {
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(y, TreeMapEntry.BLACK);
						setColor(parentOf(parentOf(x)), TreeMapEntry.RED);
						x = parentOf(parentOf(x));
					}
					else {
						if (x === leftOf(parentOf(x))) {
							x = parentOf(x);
							rotateRight(x);
						}
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(parentOf(parentOf(x)), TreeMapEntry.RED);
						rotateLeft(parentOf(parentOf(x)));
					}
				}
			}
			
			_root._color = TreeMapEntry.BLACK;
		}
		
		private function fixAfterDeletion(x:TreeMapEntry):void {
			var sib:TreeMapEntry;
			while (x !== _root && colorOf(x) === TreeMapEntry.BLACK) {
				if (x === leftOf(parentOf(x))) {
					sib = rightOf(parentOf(x));
					
					if (colorOf(sib) === TreeMapEntry.RED) {
						setColor(sib, TreeMapEntry.BLACK);
						setColor(parentOf(x), TreeMapEntry.RED);
						rotateLeft(parentOf(x));
						sib = rightOf(parentOf(x));
					}
					
					if (colorOf(leftOf(sib)) === TreeMapEntry.BLACK &&
						colorOf(rightOf(sib)) === TreeMapEntry.BLACK) {
						setColor(sib, TreeMapEntry.RED);
						x = parentOf(x);
					}
					else {
						if (colorOf(rightOf(sib)) === TreeMapEntry.BLACK) {
							setColor(leftOf(sib), TreeMapEntry.BLACK);
							setColor(sib, TreeMapEntry.RED);
							rotateRight(sib);
							sib = rightOf(parentOf(x));
						}
						setColor(sib, colorOf(parentOf(x)));
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(rightOf(sib), TreeMapEntry.BLACK);
						rotateLeft(parentOf(x));
						x = _root;
					}
				}
				else {
					sib = leftOf(parentOf(x));
					
					if (colorOf(sib) === TreeMapEntry.RED) {
						setColor(sib, TreeMapEntry.BLACK);
						setColor(parentOf(x), TreeMapEntry.RED);
						rotateRight(parentOf(x));
						sib = leftOf(parentOf(x));
					}
					
					if (colorOf(rightOf(sib)) === TreeMapEntry.BLACK &&
						colorOf(leftOf(sib)) === TreeMapEntry.BLACK) {
						setColor(sib, TreeMapEntry.RED);
						x = parentOf(x);
					}
					else {
						if (colorOf(leftOf(sib)) === TreeMapEntry.BLACK) {
							setColor(rightOf(sib), TreeMapEntry.BLACK);
							setColor(sib, TreeMapEntry.RED);
							rotateLeft(sib);
							sib = leftOf(parentOf(x));
						}
						setColor(sib, colorOf(parentOf(x)));
						setColor(parentOf(x), TreeMapEntry.BLACK);
						setColor(leftOf(sib), TreeMapEntry.BLACK);
						rotateRight(parentOf(x));
						x = _root;
					}
				}
			}
			
			setColor(x, TreeMapEntry.BLACK);
		}
	}
}
