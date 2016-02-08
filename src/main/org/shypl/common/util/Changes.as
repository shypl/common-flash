package org.shypl.common.util {
	public class Changes implements Lock {
		private var _list:Vector.<Change> = new Vector.<Change>();
		private var _locked:Boolean;

		public function Changes() {
		}

		public function get locked():Boolean {
			return _locked;
		}

		public function lock():void {
			_locked = true;
		}

		public function unlock():void {
			_locked = false;

			for each (var change:Change in _list) {
				change.apply();
			}
			_list.length = 0;
		}

		public function add(change:Change):void {
			if (_locked) {
				_list.push(change);
			}
			else {
				change.apply();
			}
		}
	}
}
