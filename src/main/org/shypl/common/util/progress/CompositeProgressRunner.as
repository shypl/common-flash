package org.shypl.common.util.progress {
	public class CompositeProgressRunner implements ProgressRunner {
		public static function createBuilder():CompositeProgressRunnerBuilder {
			return new CompositeProgressRunnerBuilder();
		}
		
		protected var _runners:Vector.<ProgressRunner>;
		
		public function CompositeProgressRunner(runners:Vector.<ProgressRunner>) {
			_runners = runners.concat();
			_runners.fixed = true;
		}
		
		public function run():Progress {
			var builder:CompositeProgressBuilder = CompositeProgress.createBuilder();
			for each (var runner:ProgressRunner in _runners) {
				builder.add(runner.run());
			}
			return builder.build();
		}
	}
}
