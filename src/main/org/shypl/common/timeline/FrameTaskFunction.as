package org.shypl.common.timeline {
	public class FrameTaskFunction extends FrameTask {
		private var _task:Function;
		private var _obtainTime:Boolean;
		
		public function FrameTaskFunction(repeatable:Boolean, task:Function, obtainTime:Boolean) {
			super(repeatable);
			_task = task;
			_obtainTime = obtainTime;
		}
		
		override protected function execute(passedTime:int):void {
			if (_obtainTime) {
				_task(passedTime);
			}
			else {
				_task();
			}
		}
		
		override protected function free():void {
			_task = null;
		}
	}
}
