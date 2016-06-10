package org.shypl.common.timeline {
	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class FrameTask extends Task {
		public function FrameTask(repeatable:Boolean) {
			super(repeatable);
		}

		override protected function tryExecute(passedTime:int):Boolean {
			execute(passedTime);
			return true;
		}

		[Abstract]
		protected function execute(passedTime:int):void {
			throw new AbstractMethodException();
		}
	}
}
