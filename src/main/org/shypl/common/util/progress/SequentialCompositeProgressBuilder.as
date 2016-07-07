package org.shypl.common.util.progress {
	public class SequentialCompositeProgressBuilder {
		protected var _queue:Vector.<ProgressRunner> = new Vector.<ProgressRunner>();

		public function SequentialCompositeProgressBuilder() {
		}

		public function add(runner:ProgressRunner):SequentialCompositeProgressBuilder {
			_queue.push(runner);
			return this;
		}

		public function build():SequentialCompositeProgress {
			return new SequentialCompositeProgress(_queue);
		}
	}
}
