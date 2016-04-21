package org.shypl.common.util.notice {
	public class FakeNoticeDispatchable implements NoticeDispatchable {
		public static const INSTANCE:NoticeDispatchable = new FakeNoticeDispatchable();

		public function FakeNoticeDispatchable() {
		}

		public function dispatchNotice(notice:Object):void {
		}

		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
		}

		public function removeNoticeHandler(type:Object, handler:Function):void {
		}
	}
}
