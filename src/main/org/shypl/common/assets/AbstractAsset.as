package org.shypl.common.assets {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.Progress;

	[Abstract]
	internal class AbstractAsset extends EventDispatcher implements Asset {
		private var _loaded:Boolean;
		private var _path:String;
		private var _deferred:Boolean;

		public function AbstractAsset(path:String, deferred:Boolean) {
			_path = path;
			_deferred = deferred;
		}

		public final function get loaded():Boolean {
			return _loaded;
		}

		public final function get path():String {
			return _path;
		}

		public final function get deferred():Boolean {
			return _deferred;
		}

		[Abstract]
		public function load():Progress {
			throw new AbstractMethodException();
		}

		public final function free():void {
			if (_path !== null) {
				doFree();
				_loaded = false;
				_path = null;
			}
		}

		[Abstract]
		protected function doFree():void {
			throw new AbstractMethodException();
		}

		protected final function completeLoad():void {
			_loaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
