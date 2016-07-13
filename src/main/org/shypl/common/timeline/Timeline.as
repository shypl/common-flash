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
		
		private var _delayTasks:LiteLinkedList = new LiteLinkedList();
		private var _delayTimer:Timer = new Timer(0);
		private var _delayLastTime:int;
		
		public function Timeline() {
			_delayTimer.addEventListener(TimerEvent.TIMER, onDelay);
		}
		
		public final function schedule(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return addTimeTask(new DelayTaskFunction(delay, false, task, obtainTime));
		}
		
		public final function scheduleRepeatable(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return addTimeTask(new DelayTaskFunction(delay, true, task, obtainTime));
		}
		
		public final function forNextFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return addFrameTask(new FrameTaskFunction(false, task, obtainTime));
		}
		
		public final function forEachFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return addFrameTask(new FrameTaskFunction(true, task, obtainTime));
		}
		
		public final function addFrameTask(task:FrameTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddFrameTask(task);
			});
		}
		
		public final function addTimeTask(task:DelayTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddDelayTask(task);
			});
		}
		
		public final function clear():void {
			_changer.executeFunction(doClear);
		}
		
		public final function stop():void {
			_changer.executeFunction(doStop);
		}
		
		public final function pause():void {
			_changer.executeFunction(doPause);
		}
		
		public final function resume():void {
			_changer.executeFunction(doResume);
		}
		
		private function checkStopped():void {
			if (_stopped) {
				throw new IllegalStateException("Timeline is stopped");
			}
		}
		
		private function doAddFrameTask(task:FrameTask):void {
			checkStopped();
			if (!task.canceled) {
				_frameTasks.add(task);
				startFrameHandler();
			}
		}
		
		private function doAddDelayTask(task:DelayTask):void {
			checkStopped();
			if (!task.canceled) {
				_delayTasks.add(task);
				startDelayHandler();
			}
		}
		
		private function doClear():void {
			checkStopped();
			_frameTasks.clear();
			_delayTasks.clear();
			stopFrameHandler();
			stopDelayHandler();
		}
		
		private function doStop():void {
			doClear();
			
			_stopped = true;
			
			_frameTasks = null;
			_delayTasks = null;
		}
		
		private function doPause():void {
			checkStopped();
			_running = false;
			stopFrameHandler();
			stopDelayHandler();
		}
		
		private function doResume():void {
			checkStopped();
			_running = true;
			startFrameHandler();
			startDelayHandler();
		}
		
		private function startFrameHandler():void {
			if (!_frameRunning && _running && !_frameTasks.isEmpty()) {
				_frameRunning = true;
				_frameLastTime = getTimer();
				SHAPE.addEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
		
		private function stopFrameHandler():void {
			if (_frameRunning && (!_running || _frameTasks.isEmpty())) {
				_frameRunning = false;
				SHAPE.removeEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
		
		private function startDelayHandler():void {
			if (!_delayTimer.running && _running && !_delayTasks.isEmpty()) {
				_delayLastTime = getTimer();
				processDelayTasks();
			}
		}
		
		private function stopDelayHandler():void {
			if (_delayTimer.running && (!_running || _delayTasks.isEmpty())) {
				processDelayTasks();
				_delayTimer.stop();
			}
		}
		
		private function processFrameTasks():void {
			_changer.lock();
			
			var currentFrameTime:int = getTimer();
			var passedTime:int = currentFrameTime - _frameLastTime;
			
			_frameLastTime = currentFrameTime;
			
			while (_frameTasks.next()) {
				var task:Task = Task(_frameTasks.current);
				var remove:Boolean = true;
				
				try {
					remove = task.tryExecuteAndGetCanceled(passedTime);
				}
				catch (error:Error) {
					try {
						task.cancel();
					}
					catch (cancelError:Error) {
						LogManager.getLogger(Timeline).warn("Error on cancel broken frame task", cancelError);
					}
					_frameTasks.stopIteration();
					doPause();
					throw error;
				}
				
				if (remove) {
					_frameTasks.removeCurrent();
				}
			}
			
			stopFrameHandler();
			
			_changer.unlock();
		}
		
		private function processDelayTasks():void {
			_changer.lock();
			
			var nextDelay:int = -1;
			var currentFrameTime:int = getTimer();
			var passedTime:int = currentFrameTime - _delayLastTime;
			
			_delayLastTime = currentFrameTime;
			_delayTimer.stop();
			
			while (_delayTasks.next()) {
				var task:DelayTask = DelayTask(_delayTasks.current);
				var remove:Boolean = true;
				
				try {
					remove = task.tryExecuteAndGetCanceled(passedTime);
				}
				catch (error:Error) {
					try {
						task.cancel();
					}
					catch (cancelError:Error) {
						LogManager.getLogger(Timeline).warn("Error on cancel broken delay task", cancelError);
					}
					_delayTasks.stopIteration();
					doPause();
					throw error;
				}
				
				if (remove) {
					_delayTasks.removeCurrent();
				}
				else {
					if (nextDelay === -1 || task.remainedTime < nextDelay) {
						nextDelay = task.remainedTime;
					}
				}
			}
			
			if (nextDelay !== -1) {
				_delayTimer.delay = nextDelay;
				_delayTimer.start();
			}
			
			_changer.unlock();
		}
		
		private function onFrame(event:Event):void {
			processFrameTasks();
		}
		
		private function onDelay(event:TimerEvent):void {
			processDelayTasks();
		}
	}
}
