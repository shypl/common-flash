package org.shypl.common.timeline {
	import flash.display.Shape;
	
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.util.Cancelable;
	
	public class Timeline {
		internal static const SHAPE:Shape = new Shape();
		
		private var _stopped:Boolean;
		private var _running:Boolean = true;
		
		private var _frameProcessor:FrameProcessor;
		private var _scheduledProcessor:ScheduledProcessor;
		private var _deferredProcessor:DeferredProcessor;
		
		public function Timeline() {
			_frameProcessor = new FrameProcessor();
			_scheduledProcessor = new ScheduledProcessor();
			_deferredProcessor = new DeferredProcessor();
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
		
		public final function callDeferred(closure:Function, ...arguments):Cancelable {
			return applyDeferred(closure, arguments);
		}
		
		public final function applyDeferred(closure:Function, arguments:Array):Cancelable {
			checkStopped();
			var task:DeferredTask = new DeferredTask(closure, arguments);
			_deferredProcessor.addTask(task);
			return task;
		}
		
		public final function addFrameTask(task:FrameTask):Cancelable {
			checkStopped();
			_frameProcessor.addTask(task);
			return task;
		}
		
		public final function addScheduledTask(task:ScheduledTask):Cancelable {
			checkStopped();
			_scheduledProcessor.addTask(task);
			return task;
		}
		
		public final function clear():void {
			checkStopped();
			_frameProcessor.clear();
			_scheduledProcessor.clear();
			_deferredProcessor.clear();
		}
		
		public function stop():void {
			clear();
			
			_stopped = true;
			_running = false;
		}
		
		public function pause():void {
			checkStopped();
			if (_running) {
				_running = false;
				_frameProcessor.pause();
				_scheduledProcessor.pause();
				_deferredProcessor.pause();
			}
		}
		
		public function resume():void {
			checkStopped();
			if (!_running) {
				_frameProcessor.resume();
				_scheduledProcessor.resume();
				_deferredProcessor.resume();
			}
		}
		
		private function checkStopped():void {
			if (_stopped) {
				throw new IllegalStateException("Timeline is stopped");
			}
		}
	}
}
