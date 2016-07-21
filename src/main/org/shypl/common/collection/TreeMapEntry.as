package org.shypl.common.collection {
	internal class TreeMapEntry implements MapEntry {
		public static const RED:Boolean = false;
		public static const BLACK:Boolean = true;
		
		internal var _key:Object;
		internal var _value:Object;
		internal var _left:TreeMapEntry;
		internal var _right:TreeMapEntry;
		internal var _parent:TreeMapEntry;
		internal var _color:Boolean = BLACK;
		
		public function TreeMapEntry(key:Object, value:Object, parent:TreeMapEntry = null) {
			this._key = key;
			this._value = value;
			this._parent = parent;
		}
		
		public function get key():* {
			return _key;
		}
		
		public function get value():* {
			return _value;
		}
		
		public function set value(value:*):void {
			_value = value;
		}
	}
}
