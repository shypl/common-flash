package org.shypl.common.collection {
	internal class MapEntryImpl implements MapEntry {
		internal var _key:Object;
		internal var _value:Object;

		public function MapEntryImpl(key:Object, value:Object) {
			_key = key;
			_value = value;
		}

		public function get key():Object {
			return _key;
		}

		public function get value():Object {
			return _value;
		}

		public function set value(value:Object):void {
			_value = value;
		}

		internal function destroy():void {
			_key = null;
			_value = null;
		}
	}
}
