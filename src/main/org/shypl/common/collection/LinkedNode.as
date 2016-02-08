package org.shypl.common.collection {
	internal class LinkedNode {
		public var value:Object;
		public var prev:LinkedNode;
		public var next:LinkedNode;

		public function LinkedNode(prev:LinkedNode, value:Object, next:LinkedNode) {
			this.value = value;
			this.prev = prev;
			this.next = next;
		}

		public function destroy():void {
			value = null;
			prev = null;
			next = null;
		}
	}
}
