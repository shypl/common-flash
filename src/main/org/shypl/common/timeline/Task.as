package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;

	[Abstract]
	public class Task implements Cancelable {
		private var _notRepeatable:Boolean;
		private var _canceled:Boolean;

		public function Task(repeatable:Boolean) {
			_notRepeatable = !repeatable;
		}

		public function cancel():void {
			if (!_canceled) {
				_canceled = true;
				free();
			}
		}

		protected function free():void {
		}

		[Abstract]
		protected function tryExecute(passedTime:int):Boolean {
		}

		internal function tryExecuteAndGetCanceled(passedTime:int):Boolean {
			if (_canceled) {
				return true;
			}

			if (tryExecute(passedTime) && _notRepeatable) {
				cancel();
			}

			return _canceled;
		}
	}
}
