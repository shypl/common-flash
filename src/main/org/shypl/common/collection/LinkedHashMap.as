package org.shypl.common.collection {
	public class LinkedHashMap extends HashMap {
		
		internal var _first:LinkedMapEntry;
		internal var _last:LinkedMapEntry;
		
		public function LinkedHashMap() {
		}
		
		override public function put(key:Object, value:Object):* {
			var entry:LinkedMapEntry = _dic[key];
			
			if (entry === null) {
				entry = new LinkedMapEntry(key, value, _last, null);
				if (_first === null) {
					_first = entry;
				}
				else {
					_last.next = entry;
				}
				_last = entry;
				addEntry(entry);
				return null;
			}
			
			var v:Object = entry._value;
			entry._value = value;
			return v;
		}
		
		override public function remove(key:Object):* {
			var entry:LinkedMapEntry = _dic[key];
			if (entry === null) {
				return null;
			}
			
			var next:LinkedMapEntry = entry.next;
			var prev:LinkedMapEntry = entry.prev;
			
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
			
			return removeEntry(entry);
		}
		
		override public function iterator():MapIterator {
			return new LinkedHashMap_Iterator(this, _first);
		}
		
		override public function getEntries():Vector.<MapEntry> {
			const list:Vector.<MapEntry> = new Vector.<MapEntry>(size(), true);
			const it:MapIterator = iterator();
			var i:int = 0;
			
			while (it.next()) {
				list[i++] = it.entry;
			}
			
			return list;
		}
		
		override public function getKeys():Array {
			const list:Array = [];
			const it:MapIterator = iterator();
			var i:int = 0;
			
			while (it.next()) {
				list[i++] = it.key;
			}
			
			return list;
		}
		
		override public function getValues():Array {
			const list:Array = [];
			const it:MapIterator = iterator();
			var i:int = 0;
			
			while (it.next()) {
				list[i++] = it.value;
			}
			
			return list;
		}
	}
}
