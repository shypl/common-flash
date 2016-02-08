package org.shypl.common.loader {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	internal class ImageLoader extends AbstractLoader {
		private var _receiver:ImageReceiver;
		private var _loader:Loader;
		private var _loaderInfo:LoaderInfo;

		function ImageLoader(url:String, receiver:ImageReceiver) {
			super(url);
			_receiver = receiver;
		}

		override protected function getPercent():Number {
			if (_loaderInfo.bytesTotal == 0) {
				return 0;
			}
			return _loaderInfo.bytesLoaded / _loaderInfo.bytesTotal;
		}

		override protected function start():void {
			_loader = new Loader();

			_loaderInfo = _loader.contentLoaderInfo;
			_loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

			_loader.load(new URLRequest(url));
		}

		override protected function complete():void {
			_receiver.receiveImage(Bitmap(_loader.content).bitmapData);
			_receiver = null;
		}

		override protected function free():void {
			_loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);

			try {
				_loader.unloadAndStop(true);
			}
			catch (e:Error) {
			}

			_loader = null;
			_loaderInfo = null;
		}
	}
}
