package org.shypl.common.util.progress {
	public class CompositeProgressBuilder {
		protected var _progresses:Vector.<Progress> = new Vector.<Progress>();

		public function CompositeProgressBuilder() {
		}

		public function add(progress:Progress):CompositeProgressBuilder {
			_progresses.push(progress);
		}

		public function build():CompositeProgress {
			return new CompositeProgress(_progresses);
		}
	}
}
