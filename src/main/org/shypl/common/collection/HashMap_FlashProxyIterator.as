package org.shypl.common.collection {
	internal class HashMap_FlashProxyIterator {
		private var _list:Vector.<MapEntry>;
		
		public function HashMap_FlashProxyIterator(hashMap:HashMap) {
			_list = hashMap.getEntries();
		}
		
		public function getKey(index:int):String {
			return String(_list[index].key);
		}
		
		public function getValue(index:int):Object {
			return _list[index].value;
		}
		
		public function destroy():void {
			_list.fixed = false;
			_list.length = 0;
			_list = null;
		}
	}
}