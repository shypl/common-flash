package org.shypl.common.timeline {
	import flash.events.Event;
	
	internal class DeferredProcessor implements Processor {
		private var _running:Boolean = true;
		private var _first:DeferredTask;
		private var _last:DeferredTask;
		
		public function DeferredProcessor() {
		}
		
		public function addTask(task:DeferredTask):void {
			if (_first === null) {
				_first = task;
				_last = task;
				if (_running) {
					startTicker();
				}
			}
			else {
				_last.setNextTask(task);
				_last = task;
			}
		}
		
		public function clear():void {
			if (_first !== null) {
				stopTicker();
				var task:DeferredTask = _first;
				while (task !== null) {
					task.cancel();
					task = task.nextTask();
				}
				_first = null;
				_last = null;
			}
		}
		
		public function pause():void {
			if (_running) {
				_running = false;
				if (_first !== null) {
					stopTicker();
				}
			}
		}
		
		public function resume():void {
			if (!_running) {
				_running = true;
				if (_first !== null) {
					startTicker();
				}
			}
		}
		
		public function run():void {
			execute();
		}
		
		private function startTicker():void {
			Timeline.SHAPE.addEventListener(Event.EXIT_FRAME, onExitFrame);
		}
		
		private function stopTicker():void {
			Timeline.SHAPE.removeEventListener(Event.EXIT_FRAME, onExitFrame);
		}
		
		private function execute():void {
			stopTicker();
			var task:DeferredTask = _first;
			while (task !== null) {
				task.tryExecute();
				task = task.nextTask();
			}
			_first = null;
			_last = null;
		}
		
		private function onExitFrame(event:Event):void {
			execute();
		}
	}
}
