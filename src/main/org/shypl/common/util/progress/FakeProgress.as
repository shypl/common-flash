package org.shypl.common.util.progress {
	import org.shypl.common.util.callDelayed;
	
	public class FakeProgress implements Progress {
		public static const COMPLETED:Progress = new FakeProgress(true);
		public static const NOT_COMPLETED:Progress = new FakeProgress(false);
		
		private var _completed:Boolean;
		
		public function FakeProgress(completed:Boolean) {
			_completed = completed;
		}
		
		public function get completed():Boolean {
			return _completed;
		}
		
		public function get percent():Number {
			return _completed ? 1 : 0;
		}
		
		public function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
		}
		
		public function removeNoticeHandler(type:Object, handler:Function):void {
		}
		
		public function removeNoticeHandlers(type:Object):void {
		}
		
		public function handleComplete(handler:Function, delayed:Boolean = false):void {
			if (_completed) {
				if (delayed) {
					callDelayed(handler);
				}
				else {
					handler();
				}
			}
		}
		
		public function removeAllNoticeHandlers():void {
		}
	}
}
