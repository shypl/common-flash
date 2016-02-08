package org.shypl.common.timeline {
	public final class GlobalTimeline {
		public static const INSTANCE:Timeline = new GlobalTimelineImpl();

		public static function get lastFrameTime():int {
			return INSTANCE.lastFrameTime;
		}

		public static function schedule(delay:int, task:Function, obtainTime:Boolean = false):TimelineTask {
			return INSTANCE.schedule(delay, task, obtainTime);
		}

		public static function scheduleRepeatable(delay:int, task:Function, obtainTime:Boolean = false):TimelineTask {
			return INSTANCE.scheduleRepeatable(delay, task, obtainTime);
		}

		public static function forNextFrame(task:Function, obtainTime:Boolean = false):TimelineTask {
			return INSTANCE.forNextFrame(task, obtainTime);
		}

		public static function forEachFrame(task:Function, obtainTime:Boolean = false):TimelineTask {
			return INSTANCE.forEachFrame(task, obtainTime);
		}

		public static function clear():void {
			return INSTANCE.clear();
		}
	}
}
