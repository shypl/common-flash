package org.shypl.common.loader {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	internal class SimpleLoader extends AbstractLoader {
		private var _loader:URLLoader;
		private var _asBytes:Boolean;

		function SimpleLoader(url:String, asBytes:Boolean) {
			super(url);
			_asBytes = asBytes;
		}

		override protected final function getPercent():Number {
			if (_loader.bytesTotal == 0) {
				return 0;
			}
			return _loader.bytesLoaded / _loader.bytesTotal;
		}

		override protected final function start():void {
			_loader = new URLLoader();
			_loader.dataFormat = _asBytes ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_loader.load(new URLRequest(url));
		}

		override protected final function complete():void {
			if (_asBytes) {
				completeBytes(ByteArray(_loader.data));
			}
			else {
				completeText(String(_loader.data));
			}
		}

		override protected final function free():void {
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_loader = null;
		}

		protected function completeBytes(data:ByteArray):void {
		}

		protected function completeText(data:String):void {
		}
	}
}
