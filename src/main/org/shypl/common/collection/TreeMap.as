package org.shypl.common.collection {
	import org.shypl.common.util.Comparator;
	
	public class TreeMap extends AbstractMap implements SortedMap {
		internal static function successor(t:TreeMapEntry):TreeMapEntry {
			if (t === null) {
				return null;
			}

			var p:TreeMapEntry;

			if (t.right !== null) {
				p = t.right;
				while (p.left !== null) {
					p = p.left;
				}
				return p;
			}


			p = t.parent;
			var ch:TreeMapEntry = t;
			while (p !== null && ch === p.right) {
				ch = p;
				p = p.parent;
			}

			return p;
		}

		private static function parentOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p.parent;
		}

		private static function leftOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p.left;
		}

		private static function rightOf(p:TreeMapEntry):TreeMapEntry {
			return p === null ? null : p.right;
		}

		private static function colorOf(p:TreeMapEntry):Boolean {
			return p === null ? TreeMapEntry.BLACK : p.color;
		}

		private static function setColor(p:TreeMapEntry, c:Boolean):void {
			if (p !== null) {
				p.color = c;
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

		override public function keys():Array {
			const list:Array = [];
			const it:MapIterator = iterator();
			var i:int = 0;

			while (it.next()) {
				list[i++] = it.key;
			}

			return list;
		}

		override public function values():Array {
			const list:Array = [];
			const it:MapIterator = iterator();
			var i:int = 0;

			while (it.next()) {
				list[i++] = it.value;
			}

			return list;
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
				cmp = _comparator.compare(key, t.key);
				if (cmp < 0) {
					t = t.left;
				}
				else if (cmp > 0) {
					t = t.right;
				}
				else {
					return t.value = value;
				}
			}
			while (t !== null);

			var e:TreeMapEntry = new TreeMapEntry(key, value, parent);
			if (cmp < 0) {
				parent.left = e;
			}
			else {
				parent.right = e;
			}

			fixAfterInsertion(e);

			_size++;
			_modCount++;

			return null;
		}

		override public function get(key:Object):* {
			var p:TreeMapEntry = getEntry(key);
			return p === null ? null : p.value;
		}

		override public function remove(key:Object):* {
			const p:TreeMapEntry = getEntry(key);
			if (p === null) {
				return null;
			}

			const value:Object = p.value;
			deleteEntry(p);
			return value;
		}

		override public function containsKey(key:Object):Boolean {
			return getEntry(key) !== null;
		}

		override public function containsValue(value:Object):Boolean {
			for (var e:TreeMapEntry = getFirstEntry(); e !== null; e = successor(e)) {
				if (value === e.value) {
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

			if (p.left !== null && p.right !== null) {
				var s:TreeMapEntry = successor(p);
				p.key = s.key;
				p.value = s.value;
				p = s;
			}

			var replacement:TreeMapEntry = p.left !== null ? p.left : p.right;

			if (replacement !== null) {
				replacement.parent = p.parent;
				if (p.parent === null) {
					_root = replacement;
				}
				else if (p === p.parent.left) {
					p.parent.left = replacement;
				}
				else {
					p.parent.right = replacement;
				}

				p.left = p.right = p.parent = null;

				if (p.color === TreeMapEntry.BLACK) {
					fixAfterDeletion(replacement);
				}
			}
			else if (p.parent === null) {
				_root = null;
			}
			else {
				if (p.color === TreeMapEntry.BLACK) {
					fixAfterDeletion(p);
				}

				if (p.parent !== null) {
					if (p === p.parent.left) {
						p.parent.left = null;
					}
					else if (p === p.parent.right) {
						p.parent.right = null;
					}
					p.parent = null;
				}
			}
		}

		private function getFirstEntry():TreeMapEntry {
			var p:TreeMapEntry = _root;
			if (p !== null) {
				while (p.left !== null) {
					p = p.left;
				}
			}
			return p;
		}

		private function getEntry(key:Object):TreeMapEntry {
			var p:TreeMapEntry = _root;
			while (p !== null) {
				var cmp:int = _comparator.compare(key, p.key);
				if (cmp < 0) {
					p = p.left;
				}
				else if (cmp > 0) {
					p = p.right;
				}
				else {
					return p;
				}
			}
			return null;
		}

		private function rotateLeft(p:TreeMapEntry):void {
			if (p !== null) {
				var r:TreeMapEntry = p.right;
				p.right = r.left;
				if (r.left !== null) {
					r.left.parent = p;
				}
				r.parent = p.parent;
				if (p.parent === null) {
					_root = r;
				}
				else if (p.parent.left === p) {
					p.parent.left = r;
				}
				else {
					p.parent.right = r;
				}
				r.left = p;
				p.parent = r;
			}
		}

		private function rotateRight(p:TreeMapEntry):void {
			if (p !== null) {
				var l:TreeMapEntry = p.left;
				p.left = l.right;
				if (l.right !== null) {
					l.right.parent = p;
				}
				l.parent = p.parent;
				if (p.parent === null) {
					_root = l;
				}
				else if (p.parent.right === p) {
					p.parent.right = l;
				}
				else {
					p.parent.left = l;
				}
				l.right = p;
				p.parent = l;
			}
		}

		private function fixAfterInsertion(x:TreeMapEntry):void {
			x.color = TreeMapEntry.RED;
			var y:TreeMapEntry;

			while (x !== null && x !== _root && x.parent.color === TreeMapEntry.RED) {
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

			_root.color = TreeMapEntry.BLACK;
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
