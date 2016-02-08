package org.shypl.common.collection {
	internal class LinkedMapEntry extends MapEntryImpl {
		internal var prev:LinkedMapEntry;
		internal var next:LinkedMapEntry;

		public function LinkedMapEntry(key:Object, value:Object, prev:LinkedMapEntry, next:LinkedMapEntry) {
			super(key, value);
			this.prev = prev;
			this.next = next;
		}

		override internal function destroy():void {
			super.destroy();
			prev = null;
			next = null;
		}
	}
}
