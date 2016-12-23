package org.shypl.common.util.notice {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.CheckableDestroyable;
	import org.shypl.common.util.DestroyableObject;
	
	public class NoticeDispatcher extends DestroyableObject implements NoticeDispatchable, CheckableDestroyable {
		
		private var _handlersMap:Dictionary = new Dictionary();
		
		public function NoticeDispatcher() {
		}
		
		public function addNoticeHandler(type:Object, handler:Function):void {
			if (destroyed) {
				return;
			}
			
			type = extractTypeNameFromType(type);
			
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers === null) {
				handlers = new NoticeDispatcherHandlers();
				_handlersMap[type] = handlers;
			}
			handlers.add(handler);
		}
		
		public function removeNoticeHandler(type:Object, handler:Function):void {
			if (destroyed) {
				return;
			}
			
			type = extractTypeNameFromType(type);
			
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.remove(handler);
				if (handlers.isEmpty()) {
					delete _handlersMap[type];
				}
			}
		}
		
		public function removeNoticeHandlers(type:Object):void {
			if (destroyed) {
				return;
			}
			
			type = extractTypeNameFromType(type);
			
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.clear();
				delete _handlersMap[type];
			}
		}
		
		public function removeAllNoticeHandlers():void {
			if (destroyed) {
				return;
			}
			
			for (var type:String in _handlersMap) {
				NoticeDispatcherHandlers(_handlersMap[type]).clear();
				delete _handlersMap[type];
			}
		}
		
		public function hasNoticeHandlers(type:Object):Boolean {
			type = extractTypeNameFromType(type);
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			return !(handlers === null || handlers.isEmpty());
		}
		
		public function dispatchNotice(notice:Object):void {
			if (destroyed) {
				return;
			}
			
			var type:String = extractTypeNameFromNotice(notice);
			
			var handlers:NoticeDispatcherHandlers = _handlersMap[type];
			if (handlers !== null) {
				handlers.dispatch(notice);
			}
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			removeAllNoticeHandlers();
			_handlersMap = null;
		}
		
		private function extractTypeNameFromType(type:Object):String {
			if (type is String) {
				return String(type);
			}
			if (type is NoticeType) {
				return NoticeType(type).name;
			}
			if (type is Class) {
				return getQualifiedClassName(type);
			}
			throw new IllegalArgumentException();
		}
		
		private function extractTypeNameFromNotice(notice:Object):String {
			if (notice is String) {
				return String(notice);
			}
			if (notice is TypedNotice) {
				return TypedNotice(notice).type.name;
			}
			if (notice is Notice) {
				return getQualifiedClassName(notice);
			}
			throw new IllegalArgumentException();
		}
	}
}