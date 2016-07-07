package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class SequentialUnevenCompositeProgress extends UnevenCompositeProgress {
		public static function createBuilder():SequentialUnevenCompositeProgressBuilder {
			return new SequentialUnevenCompositeProgressBuilder();
		}

		private var _current:int = -1;
		private var _queue:Vector.<ProgressRunner>;

		public function SequentialUnevenCompositeProgress(queue:Vector.<ProgressRunner>, divisions:Vector.<int>) {
			super(CollectionUtils.createVectorAndFill(Progress, queue.length, FakeProgress.NOT_COMPLETED) as Vector.<Progress>, divisions);
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
