package org.shypl.common.timeline {
	import flash.events.Event;
	
	internal class FrameProcessor extends TimedProcessor {
		public function FrameProcessor() {
		}
		
		override protected function doStartTicker():void {
			Timeline.SHAPE.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function doStopTicker():void {
			Timeline.SHAPE.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function executeTasks(passedTime:int):void {
			while (_tasks.next()) {
				var task:TimedTask = _tasks.current;
				try {
					if (task.tryExecuteAndGetCanceled(passedTime)) {
						_tasks.removeCurrent();
					}
				}
				catch (error:Error) {
					task.cancel();
					_tasks.removeCurrent();
					_tasks.stopIteration();
					throw error;
				}
			}
		}
		
		private function onEnterFrame(event:Event):void {
			execute();
		}
	}
}
