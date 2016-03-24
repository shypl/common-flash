package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;

	public final class GlobalTimeline {
		public static const INSTANCE:Timeline = new GlobalTimelineImpl();

		public static function get lastFrameTime():int {
			return INSTANCE.lastFrameTime;
		}

		public static function schedule(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.schedule(delay, task, obtainTime);
		}

		public static function scheduleRepeatable(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.scheduleRepeatable(delay, task, obtainTime);
		}

		public static function forNextFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.forNextFrame(task, obtainTime);
		}

		public static function forEachFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return INSTANCE.forEachFrame(task, obtainTime);
		}

		public static function clear():void {
			return INSTANCE.clear();
		}
	}
}
