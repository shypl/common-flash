package org.shypl.common.timeline {
	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class AbstractTask implements Task {
		private var _alive:Boolean = true;

		public function AbstractTask() {
		}

		public final function cancel():void {
			_alive = false;
			doCancel();
		}

		public final function execute(time:int):Boolean {
			if (_alive) {
				doExecute(time);
			}
			return _alive;
		}

		[Abstract]
		protected function doExecute(time:int):void {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function doCancel():void {
			throw new AbstractMethodException();
		}
	}
}
