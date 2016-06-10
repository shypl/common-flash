package org.shypl.common.util.notice {
	import org.shypl.common.collection.LiteLinkedMap;
	import org.shypl.common.util.Executor;

	internal class NoticeDispatcher_Handlers {
		private var _handlers:LiteLinkedMap = new LiteLinkedMap();
		private var _changer:Executor = new Executor();

		public function NoticeDispatcher_Handlers() {
		}

		public function add(handler:Function, obtainNotice:Boolean = false):void {
			_changer.executeFunction(function ():void {
				_handlers.put(handler, obtainNotice);
			});
		}

		public function remove(handler:Function):void {
			_changer.executeFunction(function ():void {
				_handlers.remove(handler);
			});
		}

		public function clear():void {
			_changer.executeFunction(_handlers.clear);
		}

		public function dispatch(notice:Object):void {
			_changer.lock();

			while (_handlers.next()) {
				var f:Function = _handlers.currentKey as Function;
				if (_handlers.currentValue) {
					f(notice);
				}
				else {
					f();
				}
			}

			_changer.unlock();
		}

		public function isEmpty():Boolean {
			return _handlers.isEmpty();
		}
	}
}



