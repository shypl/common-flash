package org.shypl.common.timeline {
	public class ClosureScheduledTask extends ScheduledTask {
		private var _closure:Function;
		private var _obtainPassedTime:Boolean;
		
		public function ClosureScheduledTask(time:int, repeatable:Boolean, closure:Function, obtainPassedTime:Boolean) {
			super(time, repeatable);
			_closure = closure;
			_obtainPassedTime = obtainPassedTime;
		}
		
		override protected function execute(passedTime:int):void {
			if (_obtainPassedTime) {
				_closure.call(null, passedTime);
			}
			else {
				_closure.call();
			}
		}
		
		override protected function free():void {
			_closure = null;
		}
	}
}
