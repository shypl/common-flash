package org.shypl.common.timeline {
	import org.shypl.common.util.Change;

	internal class TimelineChange implements Change {
		public static const CLEAR:int = 1;
		public static const STOP:int = 2;
		public static const PAUSE:int = 3;
		public static const RESUME:int = 4;

		private var _timeline:Timeline;
		private var _type:int;

		public function TimelineChange(timeline:Timeline, type:int) {
			_timeline = timeline;
			_type = type;
		}

		public function apply():void {
			switch (_type) {
				case CLEAR:
					_timeline.clear();
					break;
				case STOP:
					_timeline.stop();
					break;
				case PAUSE:
					_timeline.pause();
					break;
				case RESUME:
					_timeline.resume();
					break;
			}
			_timeline = null;
		}
	}
}
