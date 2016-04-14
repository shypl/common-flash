package org.shypl.common.util.progress {
	public class CompletedProgress implements Progress {
		public static const INSTANCE:Progress = new CompletedProgress();
		
		public function get completed():Boolean {
			return true;
		}

		public function get percent():Number {
			return 1;
		}

		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
		}

		public function removeNoticeHandler(type:Object, handler:Function):void {
		}
	}
}
