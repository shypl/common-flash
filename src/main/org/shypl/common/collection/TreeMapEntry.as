package org.shypl.common.collection {
	internal class TreeMapEntry {
		public static const RED:Boolean = false;
		public static const BLACK:Boolean = true;

		public var key:Object;
		public var value:Object;
		public var left:TreeMapEntry;
		public var right:TreeMapEntry;
		public var parent:TreeMapEntry;
		public var color:Boolean = BLACK;

		public function TreeMapEntry(key:Object, value:Object, parent:TreeMapEntry = null) {
			this.key = key;
			this.value = value;
			this.parent = parent;
		}
	}
}
