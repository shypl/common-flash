package org.shypl.common.loader {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	internal class DataLoader extends AbstractLoader {
		private var _loader:URLLoader;
		private var _asBytes:Boolean;

		function DataLoader(url:String, asBytes:Boolean) {
			super(url);
			_asBytes = asBytes;
		}

		override protected final function getLoadingPercent():Number {
			if (_loader.bytesTotal == 0) {
				return 0;
			}
			return _loader.bytesLoaded / _loader.bytesTotal;
		}

		override protected final function startLoading():void {
			_loader = new URLLoader();
			_loader.dataFormat = _asBytes ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadingErrorEvent);
			_loader.load(new URLRequest(url));
		}

		override protected final function produceResult():void {
			if (_asBytes) {
				produceBytes(ByteArray(_loader.data));
			}
			else {
				produceText(String(_loader.data));
			}
		}

		override protected final function freeLoading():void {
			_loader.removeEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadingErrorEvent);
			_loader = null;
		}

		protected function produceBytes(data:ByteArray):void {
		}

		protected function produceText(data:String):void {
		}
	}
}
