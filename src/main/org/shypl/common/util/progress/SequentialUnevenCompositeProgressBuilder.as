package org.shypl.common.util.progress {
	public class SequentialUnevenCompositeProgressBuilder {
		protected var _queue:Vector.<ProgressRunner> = new Vector.<ProgressRunner>();
		protected var _divisions:Vector.<int> = new Vector.<int>();

		public function SequentialUnevenCompositeProgressBuilder() {
		}

		public function add(runner:ProgressRunner, division:int):SequentialUnevenCompositeProgressBuilder {
			_queue.push(runner);
			_divisions.push(division);
			return this;
		}

		public function build():SequentialUnevenCompositeProgress {
			return new SequentialUnevenCompositeProgress(_queue, _divisions);
		}
	}
}
