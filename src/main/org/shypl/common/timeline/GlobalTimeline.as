package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;
	
	public final class GlobalTimeline {
		public static const INSTANCE:Timeline = new GlobalTimelineImpl();
		
		public static function schedule(delay:int, closure:Function):Cancelable {
			return INSTANCE.schedule(delay, closure);
		}
		
		public static function scheduleRepeatable(delay:int, closure:Function):Cancelable {
			return INSTANCE.scheduleRepeatable(delay, closure);
		}
		
		public static function forNextFrame(task:Function):Cancelable {
			return INSTANCE.forNextFrame(task);
		}
		
		public static function forEachFrame(task:Function):Cancelable {
			return INSTANCE.forEachFrame(task);
		}
		
		public static function callDeferred(closure:Function):Cancelable {
			return INSTANCE.callDeferredWithArgumentsArray(closure, null);
		}
		
		public static function callDeferredWithArguments(closure:Function, ...arguments):Cancelable {
			return INSTANCE.callDeferredWithArgumentsArray(closure, arguments);
		}
		
		public static function callDeferredWithArgumentsArray(closure:Function, arguments:Array):Cancelable {
			return INSTANCE.callDeferredWithArgumentsArray(closure, arguments);
		}
		
		public static function runDeferred():void {
			INSTANCE.runDeferred();
		}
		
		public static function addFrameTask(task:FrameTask):Cancelable {
			return INSTANCE.addFrameTask(task);
		}
		
		public static function addScheduledTask(task:ScheduledTask):Cancelable {
			return INSTANCE.addScheduledTask(task);
		}
		
		public static function addDeferredTask(task:DeferredTask):Cancelable {
			return INSTANCE.addDeferredTask(task);
		}
		
		public static function clear():void {
			return INSTANCE.clear();
		}
	}
}
