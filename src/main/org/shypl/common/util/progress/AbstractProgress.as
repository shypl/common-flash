package org.shypl.common.util.progress {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.callDelayed;
	import org.shypl.common.util.notice.NoticeDispatcher;

	[Abstract]
	public class AbstractProgress extends NoticeDispatcher implements Progress {
		private var _completed:Boolean;

		public function AbstractProgress() {
		}

		public final function get completed():Boolean {
			return _completed;
		}

		public final function get percent():Number {
			return _completed ? 1 : calculatePercent();
		}

		override final public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
			if (type === ProgressCompleteNotice && _completed) {
				return;
			}
			super.addNoticeHandler(type, handler, obtainNotice);
		}

		public final function handleComplete(handler:Function, delayed:Boolean = false):void {
			if (_completed) {
				if (delayed) {
					callDelayed(handler);
				}
				else {
					handler();
				}
			}
			else {
				super.addNoticeHandler(ProgressCompleteNotice, handler, false);
			}
		}

		[Abstract]
		protected function calculatePercent():Number {
			throw new AbstractMethodException();
		}

		protected function complete():void {
			_completed = true;
			dispatchNotice(new ProgressCompleteNotice(this));
			removeNoticeHandlers(ProgressCompleteNotice);
		}
	}
}
