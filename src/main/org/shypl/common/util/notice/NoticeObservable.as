package org.shypl.common.util.notice {
	public interface NoticeObservable {
		function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void;
		
		function removeNoticeHandler(type:Object, handler:Function):void;
		
		function removeNoticeHandlers(type:Object):void;
		
		function removeAllNoticeHandlers():void;
	}
}
