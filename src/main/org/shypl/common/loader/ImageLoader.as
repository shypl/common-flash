package org.shypl.common.loader {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.shypl.common.lang.UncaughtErrorDelegate;
	
	internal class ImageLoader extends AbstractLoader {
		private var _loader1:URLLoader;
		private var _loader2:Loader;
		private var _receiver:ImageReceiver;
		
		function ImageLoader(url:String, receiver:ImageReceiver, failHandler:LoadingFailHandler) {
			super(url, failHandler);
			_receiver = receiver;
		}
		
		override protected function cancelLoading():void {
			if (_loader1) {
				try {
					_loader1.close();
				}
				catch (e:Error) {
				}
			}
			if (_loader2) {
				try {
					_loader2.close();
				}
				catch (e:Error) {
				}
			}
		}
		
		override protected function produceResult():void {
			_receiver.receiveImage(Bitmap(_loader2.content).bitmapData);
		}
		
		override protected function getLoadingPercent():Number {
			if (_loader2 == null) {
				if (_loader1.bytesTotal == 0) {
					return 0;
				}
				return _loader1.bytesLoaded / _loader1.bytesTotal * 0.99;
			}
			return 1;
		}
		
		override protected function startLoading():void {
			_loader1 = new URLLoader();
			_loader1.dataFormat = URLLoaderDataFormat.BINARY;
			_loader1.addEventListener(Event.COMPLETE, onComplete1);
			_loader1.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_loader1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadingErrorEvent);
			_loader1.load(new URLRequest(url));
		}
		
		override protected function freeLoading():void {
			if (_loader1) {
				_loader1.removeEventListener(Event.COMPLETE, onComplete1);
				_loader1.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
				_loader1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadingErrorEvent);
				_loader1 = null;
			}
			if (_loader2) {
				const info:LoaderInfo = _loader2.contentLoaderInfo;
				info.removeEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
				info.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
				
				try {
					_loader2.unloadAndStop(true);
				}
				catch (e:Error) {
				}
				_loader2 = null;
			}
		}
		
		override protected function free():void {
			super.free();
			_receiver = null;
		}
		
		private function onComplete1(event:Event):void {
			_loader2 = new Loader();
			
			const info:LoaderInfo = _loader2.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			info.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			
			UncaughtErrorDelegate.register(_loader2.uncaughtErrorEvents);
			
			_loader2.loadBytes(_loader1.data, new LoaderContext(false, ApplicationDomain.currentDomain, null));
		}
	}
}
