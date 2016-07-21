package org.shypl.common.util.notice {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class NoticeDispatcher implements NoticeDispatchable {

		private const _handlersMap:Dictionary = new Dictionary();

		public function NoticeDispatcher() {
		}

		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
			if (type is Class) {
				type = getQualifiedClassName(type);
			}

			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers === null) {
				handlers = new NoticeDispatcherHandlers();
				_handlersMap[type] = handlers;
			}
			handlers.add(handler);
		}

		public function removeNoticeHandler(type:Object, handler:Function):void {
			if (type is Class) {
				type = getQualifiedClassName(type);
			}

			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.remove(handler);
				if (handlers.isEmpty()) {
					delete _handlersMap[type];
				}
			}
		}

		public function dispatchNotice(notice:Object):void {
			var type:String = (notice is String) ? (notice as String) : getQualifiedClassName(notice);
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.dispatch(notice);
			}
		}

		public function removeNoticeHandlers(type:Object):void {
			if (type is Class) {
				type = getQualifiedClassName(type);
			}
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.clear();
				delete _handlersMap[type];
			}
		}

		public function removeAllNoticeHandlers():void {
			for (var type:Object in _handlersMap) {
				NoticeDispatcherHandlers(_handlersMap[type]).clear();
				delete _handlersMap[type];
			}
		}
	}
}