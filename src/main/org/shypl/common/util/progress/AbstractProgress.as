package org.shypl.common.util.progress {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.notice.NoticeDispatcher;

	[Abstract]
	public class AbstractProgress extends NoticeDispatcher implements Progress {
		private var _competed:Boolean;

		public function AbstractProgress() {
		}

		public final function get completed():Boolean {
			return _competed;
		}

		public final function get percent():Number {
			return _competed ? 1 : calculatePercent();
		}

		[Abstract]
		protected function calculatePercent():Number {
			throw new AbstractMethodException();
		}

		protected function complete():void {
			_competed = true;
			dispatchNotice(new ProgressCompleteNotice(this));
			removeNoticeHandlers(ProgressCompleteNotice);
		}

		override public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
			if (type === ProgressCompleteNotice && _competed) {
				return;
			}
			super.addNoticeHandler(type, handler, obtainNotice);
		}
	}
}
