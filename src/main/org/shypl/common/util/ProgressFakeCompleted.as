package org.shypl.common.util {
	public class ProgressFakeCompleted implements Progress {
		public static const INSTANCE:Progress = new ProgressFakeCompleted();

		public function get completed():Boolean {
			return true;
		}

		public function get percent():Number {
			return 1;
		}
	}
}
