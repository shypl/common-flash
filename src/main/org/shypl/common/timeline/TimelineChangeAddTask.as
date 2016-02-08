package org.shypl.common.timeline {
	import org.shypl.common.util.Change;

	internal class TimelineChangeAddTask implements Change {
		private var _timeline:Timeline;
		private var _task:Task;

		public function TimelineChangeAddTask(timeline:Timeline, task:Task) {
			_timeline = timeline;
			_task = task;
		}

		public function apply():void {
			_timeline.addTask(_task);
			_timeline = null;
			_task = null;
		}
	}
}
