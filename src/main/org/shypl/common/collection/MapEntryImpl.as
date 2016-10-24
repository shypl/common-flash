package org.shypl.common.collection {
	import org.shypl.common.util.StringUtils;
	
	internal class MapEntryImpl implements MapEntry {
		internal var _key:Object;
		internal var _value:Object;
		
		public function MapEntryImpl(key:Object, value:Object) {
			_key = key;
			_value = value;
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
		
		internal function destroy():void {
			_key = null;
			_value = null;
		}
		
		public function toString():String {
			return StringUtils.toString(_key) + ":" + StringUtils.toString(_value);
		}
	}
}
