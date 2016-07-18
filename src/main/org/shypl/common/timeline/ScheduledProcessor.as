package org.shypl.common.timeline {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.shypl.common.collection.LiteLinkedList;
	
	internal class ScheduledProcessor extends TimedProcessor {
		private var _timer:Timer;
		
		public function ScheduledProcessor() {
			super(true);
			_timer = new Timer(0);
		}
		
		override public function addTask(task:TimedTask):void {
			super.addTask(task);
			if (!executing) {
				_timer.delay = 0;
			}
		}
		
		override protected function doStartTicker():void {
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.delay = 0;
			_timer.start();
		}
		
		override protected function doStopTicker():void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
		}
		
		override protected function executeTasks(tasks:LiteLinkedList, passedTime:int):void {
			var nextDelay:int = -1;
			_timer.stop();
			
			while (tasks.next()) {
				var task:ScheduledTask = tasks.current;
				try {
					if (task.tryExecuteAndGetCanceled(passedTime)) {
						tasks.removeCurrent();
					}
					else if (nextDelay === -1 || task.remainedTime < nextDelay) {
						nextDelay = task.remainedTime;
					}
				}
				catch (error:Error) {
					task.cancel();
					tasks.removeCurrent();
					tasks.stopIteration();
					throw error;
				}
			}
			
			if (nextDelay !== -1) {
				_timer.delay = nextDelay;
				_timer.start();
			}
		}
		
		private function onTimer(event:TimerEvent):void {
			execute();
		}
	}
}
