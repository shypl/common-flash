package org.shypl.common.timeline {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.shypl.common.collection.LiteLinkedList;
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.logging.LogManager;
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.Executor;
	
	public class Timeline {
		private static const SHAPE:Shape = new Shape();
		
		private var _stopped:Boolean;
		private var _running:Boolean = true;
		private var _changer:Executor = new Executor();
		
		private var _frameTasks:LiteLinkedList = new LiteLinkedList();
		private var _frameRunning:Boolean;
		private var _frameLastTime:int;
		
		private var _scheduledTasks:LiteLinkedList = new LiteLinkedList();
		private var _scheduledTimer:Timer = new Timer(0);
		private var _scheduledLastTime:int;
		
		private var _lazyTasks:Vector.<LazyTask> = new Vector.<LazyTask>();
		private var _lazyRunning:Boolean;
		private var _lazyProcessing:Boolean;
		
		public function Timeline() {
			_scheduledTimer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function get running():Boolean {
			return _running;
		}
		
		public final function schedule(delay:int, closure:Function, obtainPassedTime:Boolean = false):Cancelable {
			return addScheduledTask(new ClosureScheduledTask(delay, false, closure, obtainPassedTime));
		}
		
		public final function scheduleRepeatable(delay:int, closure:Function, obtainPassedTime:Boolean = false):Cancelable {
			return addScheduledTask(new ClosureScheduledTask(delay, true, closure, obtainPassedTime));
		}
		
		public final function forNextFrame(closure:Function, obtainTime:Boolean = false):Cancelable {
			return addFrameTask(new ClosureFrameTask(false, closure, obtainTime));
		}
		
		public final function forEachFrame(closure:Function, obtainTime:Boolean = false):Cancelable {
			return addFrameTask(new ClosureFrameTask(true, closure, obtainTime));
		}
		
		public final function lazy(closure:Function):Cancelable {
			var task:LazyTask = new LazyTask(closure);
			_changer.executeFunction(function ():void {
				doLazy(task);
			});
			return task;
		}
		
		public final function addFrameTask(task:FrameTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddFrameTask(task);
			});
			return task;
		}
		
		public final function addScheduledTask(task:ScheduledTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddScheduledTask(task);
			});
			return task;
		}
		
		public final function clear():void {
			_changer.executeFunction(doClear);
		}
		
		public function stop():void {
			_changer.executeFunction(doStop);
		}
		
		public function pause():void {
			_changer.executeFunction(doPause);
		}
		
		public function resume():void {
			_changer.executeFunction(doResume);
		}
		
		protected function checkStopped():void {
			if (_stopped) {
				throw new IllegalStateException("Timeline is stopped");
			}
		}
		
		private function doLazy(task:LazyTask):void {
			checkStopped();
			if (_lazyProcessing) {
				task.execute();
			}
			else {
				_lazyTasks.push(task);
				startLazyHandlerIfNeeded();
			}
		}
		
		private function doClear():void {
			checkStopped();
			
			cancelTasks(_frameTasks);
			cancelTasks(_scheduledTasks);
			
			for each (var task:LazyTask in _lazyTasks) {
				task.cancel();
			}
			
			_frameTasks.clear();
			_scheduledTasks.clear();
			_lazyTasks.length = 0;
			
			stopFrameHandlerIfNeeded();
			stopScheduledHandlerIfNeeded();
			stopLazyHandlerIfNeeded();
		}
		
		private function doStop():void {
			doClear();
			
			_stopped = true;
			
			_scheduledTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			_frameTasks = null;
			_scheduledTasks = null;
			_lazyTasks = null;
		}
		
		private function doPause():void {
			checkStopped();
			_running = false;
			stopFrameHandlerIfNeeded();
			stopScheduledHandlerIfNeeded();
		}
		
		private function doResume():void {
			checkStopped();
			_running = true;
			startFrameHandlerIfNeeded();
			startScheduledHandlerIfNeeded();
		}
		
		private function cancelTasks(tasks:LiteLinkedList):void {
			while (tasks.next()) {
				cancelTask(tasks.current);
			}
		}
		
		private function cancelTask(current:Task):void {
			try {
				current.cancel();
			}
			catch (error:Error) {
				LogManager.getLogger(Timeline).warn("Error on cancel task", error);
			}
		}
		
		private function doAddFrameTask(task:FrameTask):void {
			checkStopped();
			if (!task.canceled) {
				_frameTasks.add(task);
				startFrameHandlerIfNeeded();
			}
		}
		
		private function doAddScheduledTask(task:ScheduledTask):void {
			checkStopped();
			if (!task.canceled) {
				_scheduledTasks.add(task);
				startScheduledHandlerIfNeeded();
			}
		}
		
		private function startFrameHandlerIfNeeded():void {
			if (!_frameRunning && _running && !_frameTasks.isEmpty()) {
				_frameRunning = true;
				_frameLastTime = getTimer();
				SHAPE.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function stopFrameHandlerIfNeeded():void {
			if (_frameRunning && (!_running || _frameTasks.isEmpty())) {
				_frameRunning = false;
				SHAPE.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function startScheduledHandlerIfNeeded():void {
			if (!_scheduledTimer.running && _running && !_scheduledTasks.isEmpty()) {
				_scheduledLastTime = getTimer();
				processScheduledTasks();
			}
		}
		
		private function stopScheduledHandlerIfNeeded():void {
			if (_scheduledTimer.running && (!_running || _scheduledTasks.isEmpty())) {
				processScheduledTasks();
				_scheduledTimer.stop();
			}
		}
		
		private function startLazyHandlerIfNeeded():void {
			if (!_lazyRunning && _running && _lazyTasks.length != 0) {
				_lazyRunning = true;
				SHAPE.addEventListener(Event.EXIT_FRAME, onExitFrame);
			}
		}
		
		private function stopLazyHandlerIfNeeded():void {
			if (_lazyRunning && (!_running || _lazyTasks.length == 0)) {
				_lazyRunning = false;
				SHAPE.removeEventListener(Event.ENTER_FRAME, onExitFrame);
			}
		}
		
		private function processFrameTasks():void {
			_changer.lock();
			
			var currentTime:int = getTimer();
			var passedTime:int = currentTime - _frameLastTime;
			
			_frameLastTime = currentTime;
			
			while (_frameTasks.next()) {
				var task:Task = Task(_frameTasks.current);
				var remove:Boolean = true;
				
				try {
					remove = task.tryExecuteAndGetCanceled(passedTime);
				}
				catch (error:Error) {
					cancelTask(task);
					_frameTasks.stopIteration();
					doStop();
					throw error;
				}
				
				if (remove) {
					_frameTasks.removeCurrent();
				}
			}
			
			stopFrameHandlerIfNeeded();
			
			_changer.unlock();
		}
		
		private function processScheduledTasks():void {
			_changer.lock();
			
			var nextDelay:int = -1;
			var currentTime:int = getTimer();
			var passedTime:int = currentTime - _scheduledLastTime;
			
			_scheduledLastTime = currentTime;
			_scheduledTimer.stop();
			
			while (_scheduledTasks.next()) {
				var task:ScheduledTask = ScheduledTask(_scheduledTasks.current);
				var remove:Boolean = true;
				
				try {
					remove = task.tryExecuteAndGetCanceled(passedTime);
				}
				catch (error:Error) {
					cancelTask(task);
					_scheduledTasks.stopIteration();
					doStop();
					throw error;
				}
				
				if (remove) {
					_scheduledTasks.removeCurrent();
				}
				else {
					if (nextDelay === -1 || task.remainedTime < nextDelay) {
						nextDelay = task.remainedTime;
					}
				}
			}
			
			if (nextDelay !== -1) {
				_scheduledTimer.delay = nextDelay;
				_scheduledTimer.start();
			}
			
			_changer.unlock();
		}
		
		private function processLazyTasks():void {
			_lazyProcessing = true;
			_changer.lock();
			
			for each (var task:LazyTask in _lazyTasks) {
				try {
					task.execute();
				}
				catch (error:Error) {
					doStop();
					throw error;
				}
			}
			_lazyTasks.length = 0;
			
			stopLazyHandlerIfNeeded();
			
			_changer.unlock();
			
			_lazyProcessing = false;
		}
		
		private function onEnterFrame(event:Event):void {
			processFrameTasks();
		}
		
		private function onTimer(event:TimerEvent):void {
			processScheduledTasks();
		}
		
		private function onExitFrame(event:Event):void {
			processLazyTasks();
		}
	}
}
