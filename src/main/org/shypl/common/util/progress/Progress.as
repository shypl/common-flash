package org.shypl.common.util.progress {
	import org.shypl.common.util.notice.NoticeObservable;

	public interface Progress extends NoticeObservable {
		function get completed():Boolean;

		function get percent():Number;
	}
}
