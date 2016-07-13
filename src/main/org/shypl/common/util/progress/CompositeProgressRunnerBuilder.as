package org.shypl.common.util.progress {
	public class CompositeProgressRunnerBuilder implements ProgressRunner {
		protected var _runners:Vector.<ProgressRunner> = new Vector.<ProgressRunner>();
		
		public function CompositeProgressRunnerBuilder() {
		}
		
		public function add(runner:ProgressRunner):CompositeProgressRunnerBuilder {
			_runners.push(runner);
			return this;
		}
		
		public function build():CompositeProgressRunner {
			return new CompositeProgressRunner(_runners);
		}
		
		public function run():Progress {
			return build().run();
		}
	}
}
