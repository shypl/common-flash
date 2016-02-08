package org.shypl.common.util.notice {
	public interface NoticeDispatchable extends NoticeObservable {
		function dispatchNotice(notice:Object):void;
	}
}
