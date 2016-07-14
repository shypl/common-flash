package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;
	
	public final class GlobalTimeline {
		public static const INSTANCE:Timeline = new GlobalTimelineImpl();
		
		public static function schedule(delay:int, closure:Function, obtainPassedTime:Boolean = false):Cancelable {
			return INSTANCE.schedule(delay, closure, obtainPassedTime);
		}
		
		public static function scheduleRepeatable(delay:int, closure:Function, obtainPassedTime:Boolean = false):Cancelable {
			return INSTANCE.scheduleRepeatable(delay, closure, obtainPassedTime);
		}
		
		public static function forNextFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.forNextFrame(task, obtainTime);
		}
		
		public static function forEachFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.forEachFrame(task, obtainTime);
		}
		
		public static function lazy(closure:Function):Cancelable {
			return INSTANCE.lazy(closure);
		}
		
		public static function addFrameTask(task:FrameTask):Cancelable {
			return INSTANCE.addFrameTask(task);
		}
		
		public static function addScheduledTask(task:ScheduledTask):Cancelable {
			return INSTANCE.addScheduledTask(task);
		}
		
		public static function clear():void {
			return INSTANCE.clear();
		}
	}
}
