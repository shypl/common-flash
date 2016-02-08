package org.shypl.common.util {
	public class ProgressFakeNotCompleted implements Progress {
		public static const INSTANCE:Progress = new ProgressFakeNotCompleted();

		public function get completed():Boolean {
			return false;
		}

		public function get percent():Number {
			return 0;
		}
	}
}
