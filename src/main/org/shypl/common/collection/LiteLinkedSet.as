package org.shypl.common.collection {
	import flash.utils.Dictionary;
	
	public class LiteLinkedSet extends LiteLinkedList {
		private var _map:Dictionary = new Dictionary();
		
		public function LiteLinkedSet() {
		}
		
		override public function contains(element:Object):Boolean {
			return element in _map;
		}
		
		override public function add(element:Object):Boolean {
			checkIteration();
			
			if (contains(element)) {
				return false;
			}
			
			linkLast(element);
			return true;
		}
		
		override public function clear():void {
			super.clear();
			_map = new Dictionary();
		}
		
		override protected function getNode(element:Object):LinkedNode {
			try {
				return _map[element];
			}
			catch (e:Error) {
			}
			return null;
		}
		
		override protected function linkLast(element:Object):LinkedNode {
			var node:LinkedNode = super.linkLast(element);
			_map[element] = node;
			return node;
		}
		
		override protected function unlink(node:LinkedNode):void {
			delete _map[node.value];
			super.unlink(node);
		}
	}
}
