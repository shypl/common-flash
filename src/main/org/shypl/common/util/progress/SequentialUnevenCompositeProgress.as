package org.shypl.common.util.progress {
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.CollectionUtils;

	public class SequentialUnevenCompositeProgress extends UnevenCompositeProgress {
		private var _current:int = -1;
		private var _queue:Vector.<ProgressRunner>;

		private var _checker:Cancelable;

		public function SequentialUnevenCompositeProgress(queue:Vector.<ProgressRunner>, divisions:Vector.<int>) {
			super(CollectionUtils.createVectorAndFill(Progress, queue.length, NotCompletedProgress.INSTANCE) as Vector.<Progress>, divisions);
			_queue = queue;

			runNext();
			if (!completed) {
				_checker = GlobalTimeline.forEachFrame(checkCurrentForCompleteAndRunNext);
			}
		}


		private function checkCurrentForCompleteAndRunNext():void {
			if (_current < _queue.length) {
				if (getProgressAt(_current).completed) {
					runNext();
				}
			}
			else if (_checker !== null) {
				_checker.cancel();
				_checker = null;
			}
		}

		private function runNext():void {
			if (++_current < _queue.length) {
				setProgressAt(_current, _queue[_current].run());
			}
		}
	}
}
