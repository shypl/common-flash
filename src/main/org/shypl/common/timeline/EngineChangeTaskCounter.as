package org.shypl.common.timeline {
	import org.shypl.common.util.Change;

	internal class EngineChangeTaskCounter implements Change {
		private var _value:int;

		public function EngineChangeTaskCounter(value:int) {
			_value = value;
		}

		public function apply():void {
			if (_value > 0) {
				Engine.increaseTaskCounter();
			}
			else {
				Engine.decreaseTaskCounter(-_value);
			}
		}
	}
}
