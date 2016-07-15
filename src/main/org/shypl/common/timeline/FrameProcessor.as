package org.shypl.common.timeline {
	import flash.events.Event;
	
	import org.shypl.common.collection.LiteLinkedList;
	
	internal class FrameProcessor extends TimedProcessor {
		public function FrameProcessor() {
			super(false);
		}
		
		override protected function doStartTicker():void {
			Timeline.SHAPE.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function doStopTicker():void {
			Timeline.SHAPE.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function executeTasks(tasks:LiteLinkedList, passedTime:int):void {
			while (tasks.next()) {
				var task:TimedTask = tasks.current;
				try {
					if (task.tryExecuteAndGetCanceled(passedTime)) {
						tasks.removeCurrent();
					}
				}
				catch (error:Error) {
					task.cancel();
					tasks.removeCurrent();
					tasks.stopIteration();
					throw error;
				}
			}
		}
		
		private function onEnterFrame(event:Event):void {
			execute();
		}
	}
}
