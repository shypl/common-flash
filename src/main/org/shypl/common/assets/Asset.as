package org.shypl.common.assets {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.notice.FakeNoticeDispatchable;
	import org.shypl.common.util.notice.NoticeDispatchable;
	import org.shypl.common.util.notice.NoticeDispatcher;
	import org.shypl.common.util.notice.NoticeObservable;
	import org.shypl.common.util.progress.FakeProgress;
	import org.shypl.common.util.progress.Progress;

	[Abstract]
	public class Asset implements NoticeObservable {
		private var _path:String;
		private var _loading:Progress = FakeProgress.NOT_COMPLETED;
		private var _noticeDispatcher:NoticeDispatchable = new NoticeDispatcher();

		public function Asset(path:String) {
			_path = path;
		}

		public final function get path():String {
			return _path;
		}

		public final function get loaded():Boolean {
			return _loading.completed;
		}

		public final function get loading():Progress {
			return _loading;
		}

		public final function get freed():Boolean {
			return _path === null;
		}

		public final function load():Progress {
			if (_loading === FakeProgress.NOT_COMPLETED) {
				_loading = doLoad();
			}
			return _loading;
		}

		public final function free():void {
			if (freed) {
				_path = null;
				_loading = null;
				_noticeDispatcher = null;
				doFree();
			}
		}

		public final function addNoticeHandler(type:Object, handler:Function, obtainNotice:Boolean = true):void {
			_noticeDispatcher.addNoticeHandler(type, handler, obtainNotice);
		}

		public final function removeNoticeHandler(type:Object, handler:Function):void {
			_noticeDispatcher.removeNoticeHandler(type, handler);
		}

		[Abstract]
		protected function doLoad():Progress {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function doFree():void {
			throw new AbstractMethodException();
		}

		protected final function completeLoad():void {
			_loading = FakeProgress.COMPLETED;
			_noticeDispatcher.dispatchNotice(new AssetLoadedNotice(this));
			_noticeDispatcher = FakeNoticeDispatchable.INSTANCE;
		}
	}
}
