package org.shypl.common.timeline {
	import flash.utils.getTimer;
	
	import org.shypl.common.collection.LiteLinkedList;
	import org.shypl.common.lang.AbstractMethodException;
	
	[Abstract]
	internal class TimedProcessor implements Processor {
		protected var _tasks:LiteLinkedList = new LiteLinkedList();
		
		private var _running:Boolean = true;
		private var _executing:Boolean;
		private var _newTasks:Vector.<TimedTask> = new Vector.<TimedTask>();
		private var _ticker:Boolean;
		private var _lastExecuteTime:int;
		private var _stopPassedTime:int;
		
		public function TimedProcessor() {
		}
		
		public function get executing():Boolean {
			return _executing;
		}
		
		public function get running():Boolean {
			return _running;
		}
		
		public function addTask(task:TimedTask):void {
			if (_executing) {
				_newTasks.push(task);
			}
			else {
				_tasks.add(task);
				if (_running) {
					startTicker();
				}
			}
		}
		
		public function clear():void {
			if (_executing) {
				for each (var task:TimedTask in _newTasks) {
					task.cancel();
				}
				_newTasks.length = 0;
			}
			while (_tasks.next()) {
				TimedTask(_tasks.current).cancel();
			}
			_tasks.clear();
			stopTicker();
		}
		
		public function pause():void {
			_running = false;
			stopTicker();
		}
		
		public function resume():void {
			_running = true;
			if (!_tasks.isEmpty()) {
				startTicker();
			}
		}
		
		[Abstract]
		protected function doStartTicker():void {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function doStopTicker():void {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function doExecuteTasks(passedTime:int):void {
			throw new AbstractMethodException();
		}
		
		protected function execute():void {
			var currentTime:int = getTimer();
			var passedTime:int = currentTime - _lastExecuteTime;
			_lastExecuteTime = currentTime;
			
			doExecute(passedTime);
		}
		
		protected function doExecute(passedTime:int):void {
			_executing = true;
			
			doExecuteTasks(passedTime);
			while (_newTasks.length !== 0) {
				addNewTasksAfterExecute();
			}
			
			if (_tasks.isEmpty()) {
				stopTicker();
			}
			
			_executing = false;
		}
		
		protected function addNewTasksAfterExecute():void {
			for each (var task:TimedTask in _newTasks) {
				_tasks.add(task);
			}
			_newTasks.length = 0;
		}
		
		private function startTicker():void {
			if (!_ticker) {
				_ticker = true;
				_lastExecuteTime = getTimer() - _stopPassedTime;
				doStartTicker();
			}
		}
		
		private function stopTicker():void {
			if (_ticker) {
				_stopPassedTime = getTimer() - _lastExecuteTime;
				_ticker = false;
				doStopTicker();
			}
		}
	}
}
