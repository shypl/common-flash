package org.shypl.common.timeline {
	import org.shypl.common.util.Change;

	internal class EngineChangeTimelines implements Change {
		private var _timeline:Timeline;
		private var _add:Boolean;

		public function EngineChangeTimelines(timeline:Timeline, add:Boolean) {
			_timeline = timeline;
			_add = add;
		}

		public function apply():void {
			if (_add) {
				Engine.addTimeline(_timeline);
			}
			else {
				Engine.removeTimeline(_timeline);
			}
			_timeline = null;
		}
	}
}
