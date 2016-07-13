package org.shypl.common.timeline {
	public class DelayTaskFunction extends DelayTask {
		private var _task:Function;
		private var _obtainTime:Boolean;
		
		public function DelayTaskFunction(time:int, repeatable:Boolean, task:Function, obtainTime:Boolean) {
			super(time, repeatable);
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
