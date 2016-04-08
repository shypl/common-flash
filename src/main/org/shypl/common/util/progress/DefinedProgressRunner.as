package org.shypl.common.util.progress {
	public class DefinedProgressRunner implements ProgressRunner {
		private var _progress:Progress;

		public function DefinedProgressRunner(progress:Progress) {
			_progress = progress;
		}

		public function run():Progress {
			return _progress;
		}
	}
}
