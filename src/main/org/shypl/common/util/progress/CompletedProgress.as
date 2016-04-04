package org.shypl.common.util.progress {
	public class CompletedProgress implements Progress {
		public function get completed():Boolean {
			return true;
		}

		public function get percent():Number {
			return 1;
		}
	}
}
