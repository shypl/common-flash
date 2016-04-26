package org.shypl.common.util.progress {
	public class ProgressProxy implements Progress {
		private var _progress:Progress;

		public function ProgressProxy(source:Progress = null) {
			_progress = source;
		}

		public function get completed():Boolean {
			return _progress.completed;
		}

		public function get percent():Number {
			return _progress.percent;
		}

		public function setProgress(value:Progress):void {
			_progress = value;
		}

		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
			_progress.addNoticeHandler(type, handler, obtainNotice);
		}

		public function removeNoticeHandler(type:Object, handler:Function):void {
			_progress.removeNoticeHandler(type, handler);
		}

		public function removeNoticeHandlers(type:Object):void {
			_progress.removeNoticeHandlers(type);
		}
	}
}
