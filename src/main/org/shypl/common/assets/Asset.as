package org.shypl.common.assets {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.CheckableDestroyable;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.notice.NoticeDispatcher;
	import org.shypl.common.util.notice.NoticeObservable;
	import org.shypl.common.util.progress.FakeProgress;
	import org.shypl.common.util.progress.Progress;
	
	[Abstract]
	public class Asset extends NoticeDispatcher implements NoticeObservable, CheckableDestroyable {
		private var _path:FilePath;
		private var _loading:Progress = FakeProgress.NOT_COMPLETED;
		
		public function Asset(path:FilePath) {
			_path = path;
		}
		
		public final function get path():FilePath {
			return _path;
		}
		
		public final function get loaded():Boolean {
			return _loading.completed;
		}
		
		public final function get loading():Progress {
			return _loading;
		}
		
		public final function load():Progress {
			if (_loading === FakeProgress.NOT_COMPLETED) {
				_loading = doLoad();
			}
			return _loading;
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			_path = null;
			_loading = null;
		}
		
		[Abstract]
		protected function doLoad():Progress {
			throw new AbstractMethodException();
		}
		
		protected final function completeLoad():void {
			if (destroyed) {
				doDestroy();
			}
			else {
				_loading = FakeProgress.COMPLETED;
				dispatchNotice(new AssetLoadedNotice(this));
				removeNoticeHandlers(AssetLoadedNotice);
			}
		}
	}
}
