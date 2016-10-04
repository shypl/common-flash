package org.shypl.common.timeline {
	public class ClosureFrameTask extends FrameTask {
		private var _closure:Function;
		private var _obtainPassedTime:Boolean;
		
		public function ClosureFrameTask(repeatable:Boolean, closure:Function) {
			super(repeatable);
			_closure = closure;
			_obtainPassedTime = _closure.length == 1;
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
