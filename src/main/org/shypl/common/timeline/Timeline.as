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
		
		public final function schedule(delay:int, closure:Function):Cancelable {
			return addScheduledTask(new ClosureScheduledTask(delay, false, closure));
		}
		
		public final function scheduleRepeatable(delay:int, closure:Function):Cancelable {
			return addScheduledTask(new ClosureScheduledTask(delay, true, closure));
		}
		
		public final function forNextFrame(closure:Function):Cancelable {
			return addFrameTask(new ClosureFrameTask(false, closure));
		}
		
		public final function forEachFrame(closure:Function):Cancelable {
			return addFrameTask(new ClosureFrameTask(true, closure));
		}
		
		public final function callDeferred(closure:Function):Cancelable {
			return callDeferredWithArgumentsArray(closure, null);
		}
		
		public final function callDeferredWithArguments(closure:Function, ...arguments):Cancelable {
			return callDeferredWithArgumentsArray(closure, arguments);
		}
		
		public final function callDeferredWithArgumentsArray(closure:Function, arguments:Array):Cancelable {
			return addDeferredTask(new ClosureDeferredTask(closure, arguments));
		}
		
		public final function runDeferred():void {
			checkStopped();
			_deferredProcessor.run();
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
		
		public final function addDeferredTask(task:DeferredTask):Cancelable {
			checkStopped();
			_deferredProcessor.addTask(task);
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
				_running = true;
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
