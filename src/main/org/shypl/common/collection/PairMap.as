package org.shypl.common.collection {
	import flash.utils.Dictionary;
	
	public class PairMap {
		private var _leftToRight:Dictionary = new Dictionary();
		private var _rightToLeft:Dictionary = new Dictionary();
		
		public function PairMap() {
		}
		
		public function put(left:Object, right:Object):void {
			var oldLeft:Object = _rightToLeft[right];
			var oldRight:Object = _leftToRight[left];
			
			if (oldLeft !== null) {
				delete _leftToRight[oldLeft];
			}
			if (oldRight !== null) {
				delete _rightToLeft[oldRight];
			}
			
			_leftToRight[left] = right;
			_rightToLeft[right] = left;
		}
		
		public function getRight(left:Object):* {
			return _leftToRight[left];
		}
		
		public function getLeft(right:Object):* {
			return _rightToLeft[right];
		}
		
		public function containsRight(left:Object):Boolean {
			return left in _leftToRight;
		}
		
		public function containsLeft(right:Object):Boolean {
			return right in _rightToLeft;
		}
		
		public function removeLeft(left:Object):void {
			var right:Object = _leftToRight[left];
			delete _leftToRight[left];
			delete _rightToLeft[right];
		}
		
		public function removeRight(right:Object):void {
			var left:Object = _rightToLeft[right];
			delete _rightToLeft[right];
			delete _leftToRight[left];
		}
		
		public function clear():void {
			_leftToRight = new Dictionary();
			_rightToLeft = new Dictionary();
		}
	}
}
