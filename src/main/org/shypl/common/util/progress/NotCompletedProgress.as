package org.shypl.common.util.progress {
	public class NotCompletedProgress implements Progress {
		public function get completed():Boolean {
			return false;
		}

		public function get percent():Number {
			return 0;
		}
	}
}
