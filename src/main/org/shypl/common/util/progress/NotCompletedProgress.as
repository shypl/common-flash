package org.shypl.common.util.progress {
	public class NotCompletedProgress implements Progress {
		public static const INSTANCE:Progress = new NotCompletedProgress();

		public function get completed():Boolean {
			return false;
		}

		public function get percent():Number {
			return 0;
		}

		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
		}

		public function removeNoticeHandler(type:Object, handler:Function):void {
		}
	}
}
