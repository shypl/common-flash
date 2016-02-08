package org.shypl.common.util.notice {
	import org.shypl.common.util.Change;

	internal class NoticeDispatcher_Handlers_Change implements Change {
		public static const ADD:int = 1;
		public static const REMOVE:int = 2;
		public static const CLEAR:int = 3;

		private var _handlers:NoticeDispatcher_Handlers;
		private var _type:int;
		private var _handler:Function;
		private var _obtainNotice:Boolean;

		public function NoticeDispatcher_Handlers_Change(handlers:NoticeDispatcher_Handlers, type:int, handler:Function = null, obtainNotice:Boolean = false) {
			_handlers = handlers;
			_type = type;
			_handler = handler;
			_obtainNotice = obtainNotice;
		}

		public function apply():void {
			switch (_type) {
				case ADD:
					_handlers.add(_handler, _obtainNotice);
					break;
				case REMOVE:
					_handlers.remove(_handler);
					break;
				case CLEAR:
					_handlers.clear();
					break;
			}

			_handlers = null;
			_handler = null;
		}
	}
}
