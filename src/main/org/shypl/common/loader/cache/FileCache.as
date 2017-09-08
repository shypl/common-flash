package org.shypl.common.loader.cache {
	import org.shypl.common.lang.notNull;
	import org.shypl.common.loader.FileLoaderException;
	import org.shypl.common.loader.LoadingFailHandler;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.progress.CancelableProgress;
	import org.shypl.common.util.progress.CancelableProgressProxy;
	
	internal class FileCache extends CancelableProgressProxy implements CancelableProgress, LoadingFailHandler {
		private var _receivers:Vector.<Function> = new Vector.<Function>();
		private var _failHandlers:Vector.<LoadingFailHandler> = new Vector.<LoadingFailHandler>();
		
		private var _loaded:Boolean;
		private var _loadedContent:Object;
		private var _failed:Boolean;
		private var _failedUrl:String;
		
		public function FileCache() {
		}
		
		public function addReceiver(receiver:Function, failHandler:LoadingFailHandler):void {
			if (_failed) {
				if (notNull(failHandler)) {
					_failHandlers.push(failHandler);
				}
				GlobalTimeline.callDeferred(callFailHandlers);
			}
			else {
				_receivers.push(receiver);
				if (_loaded) {
					GlobalTimeline.callDeferred(callReceivers);
				}
				else if (notNull(failHandler)) {
					_failHandlers.push(failHandler);
				}
			}
		}
		
		public function handleLoadingFail(url:String):void {
			_failed = true;
			_failedUrl = url;
			_receivers.length = 0;
			callFailHandlers();
		}
		
		protected function handleLoadingComplete(content:Object):void {
			_loaded = true;
			_loadedContent = content;
			_failHandlers.length = 0;
			callReceivers();
		}
		
		private function callReceivers():void {
			var receivers:Vector.<Function> = _receivers.concat();
			_receivers.length = 0;
			
			for each (var receiver:Function in receivers) {
				receiver.call(null, _loadedContent);
			}
		}
		
		private function callFailHandlers():void {
			if (_failHandlers.length == 0) {
				throw new FileLoaderException("Cannot load file " + _failedUrl);
			}
			
			for each (var handler:LoadingFailHandler in _failHandlers) {
				handler.handleLoadingFail(_failedUrl);
			}
			_failHandlers.length = 0;
		}
	}
}
