package org.shypl.common.util.notice {
	import org.shypl.common.collection.LiteLinkedSet;
	import org.shypl.common.util.ChangeExecutor;
	
	internal class NoticeDispatcherHandlers {
		private var _handlers:LiteLinkedSet = new LiteLinkedSet();
		private var _changer:ChangeExecutor = new ChangeExecutor();
		
		public function NoticeDispatcherHandlers() {
		}
		
		public function add(handler:Function):void {
			_changer.executeFunction(_handlers.add, handler);
		}
		
		public function remove(handler:Function):void {
			_changer.executeFunction(_handlers.remove, handler);
		}
		
		public function clear():void {
			_changer.executeFunction(_handlers.clear);
		}
		
		public function dispatch(notice:Object):void {
			_changer.executeFunction(doDispatch, notice);
		}
		
		public function isEmpty():Boolean {
			return _handlers.isEmpty();
		}
		
		private function doDispatch(notice:Object):void {
			_changer.lock();
			
			while (_handlers.next()) {
				var f:Function = _handlers.current;
				if (f.length === 0) {
					f.apply();
				}
				else {
					f.call(null, notice);
				}
			}
			
			_changer.unlock();
		}
	}
}



