package org.shypl.common.util.progress {
	import org.shypl.common.util.progress.Progress;

	public class CompletedProgress implements Progress {
		public function get completed():Boolean {
			return true;
		}

		public function get percent():Number {
			return 1;
		}
	}
}
