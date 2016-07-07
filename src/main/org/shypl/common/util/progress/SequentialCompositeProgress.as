package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class SequentialCompositeProgress extends CompositeProgress {
		public static function createBuilder():SequentialCompositeProgressBuilder {
			return new SequentialCompositeProgressBuilder();
		}
		
		private var _current:int = -1;
		private var _queue:Vector.<ProgressRunner>;

		public function SequentialCompositeProgress(queue:Vector.<ProgressRunner>) {
			super(CollectionUtils.createVectorAndFill(Progress, queue.length, FakeProgress.NOT_COMPLETED) as Vector.<Progress>);
			_queue = queue;
			runNext();
		}

		override protected function onChildComplete():void {
			runNext();
			super.onChildComplete();
		}

		private function runNext():void {
			if (++_current < _queue.length) {
				setChild(_current, _queue[_current].run());
			}
		}
	}
}
