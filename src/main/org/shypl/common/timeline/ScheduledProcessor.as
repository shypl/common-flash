package org.shypl.common.timeline {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.shypl.common.logging.LogManager;
	
	internal class ScheduledProcessor extends TimedProcessor {
		private var _timer:Timer;
		
		public function ScheduledProcessor() {
			_timer = new Timer(0);
		}
		
		override public function addTask(task:TimedTask):void {
			if (executing || !running) {
				super.addTask(task);
			}
			else {
				execute();
				super.addTask(task);
				doExecute(0);
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
		
		override protected function doExecuteTasks(passedTime:int):void {
			var nextDelay:int = -1;
			_timer.stop();
			
			while (_tasks.next()) {
				var task:ScheduledTask = _tasks.current;
				try {
					if (task.tryExecuteAndGetCanceled(passedTime)) {
						_tasks.removeCurrent();
					}
					else if (nextDelay === -1 || task.remainedTime < nextDelay) {
						nextDelay = task.remainedTime;
					}
				}
				catch (error:Error) {
					task.cancel();
					_tasks.removeCurrent();
					_tasks.stopIteration();
					throw error;
				}
			}
			
			if (nextDelay !== -1) {
				_timer.delay = nextDelay;
				_timer.start();
			}
		}
		
		override protected function addNewTasksAfterExecute():void {
			super.addNewTasksAfterExecute();
			doExecuteTasks(0);
		}
		
		private function onTimer(event:TimerEvent):void {
			execute();
		}
	}
}
