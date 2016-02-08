package org.shypl.common.util.notice {
	import org.shypl.common.collection.LiteLinkedMap;
	import org.shypl.common.util.Changes;

	internal class NoticeDispatcher_Handlers {
		private var _handlers:LiteLinkedMap = new LiteLinkedMap();
		private var _changes:Changes = new Changes();

		public function NoticeDispatcher_Handlers() {
		}

		public function add(handler:Function, obtainNotice:Boolean):void {
			if (_changes.locked) {
				_changes.add(new NoticeDispatcher_Handlers_Change(this, NoticeDispatcher_Handlers_Change.ADD, handler, obtainNotice));
			}
			else {
				_handlers.put(handler, obtainNotice);
			}
		}

		public function remove(handler:Function):void {
			if (_changes.locked) {
				_changes.add(new NoticeDispatcher_Handlers_Change(this, NoticeDispatcher_Handlers_Change.REMOVE, handler));
			}
			else {
				_handlers.remove(handler);
			}
		}

		public function clear():void {
			if (_changes.locked) {
				_changes.add(new NoticeDispatcher_Handlers_Change(this, NoticeDispatcher_Handlers_Change.CLEAR));
			}
			else {
				_handlers.clear();
			}
		}

		public function dispatch(notice:Object):void {
			_changes.lock();

			while (_handlers.next()) {
				var f:Function = _handlers.currentKey as Function;
				if (_handlers.currentValue) {
					f(notice);
				}
				else {
					f();
				}
			}

			_changes.unlock();
		}

		public function isEmpty():Boolean {
			return _handlers.isEmpty();
		}
	}
}



