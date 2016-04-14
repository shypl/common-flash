package org.shypl.common.loader {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.lang.UncaughtErrorDelegate;
	import org.shypl.common.timeline.GlobalTimeline;

	internal class SwfLoader extends AbstractLoader {
		private static const CACHE:Vector.<SwfLoaderCachedItem> = new Vector.<SwfLoaderCachedItem>();

		private var _receiver:SwfReceiver;
		private var _domain:ApplicationDomain;
		private var _cache:SwfLoaderCachedItem;
		private var _loader1:URLLoader;
		private var _loader2:Loader;

		function SwfLoader(url:String, receiver:SwfReceiver, domain:ApplicationDomain) {
			super(url);
			_receiver = receiver;
			_domain = domain === null ? ApplicationDomain.currentDomain : domain;
		}

		public final function get domain():ApplicationDomain {
			return _domain;
		}

		override protected function getLoadingPercent():Number {
			if (_cache) {
				return 1;
			}
			if (_loader2 == null) {
				if (_loader1.bytesTotal == 0) {
					return 0;
				}
				return _loader1.bytesLoaded / _loader1.bytesTotal * 0.99;
			}
			return 1;
		}

		override protected function startLoading():void {
			for each (var item:SwfLoaderCachedItem in CACHE) {
				if (item.matches(_domain, url)) {
					_cache = item;
					GlobalTimeline.forNextFrame(emulateLoad);
					return;
				}
			}

			_loader1 = new URLLoader();
			_loader1.dataFormat = URLLoaderDataFormat.BINARY;
			_loader1.addEventListener(Event.COMPLETE, onComplete1);
			_loader1.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_loader1.load(new URLRequest(url));
		}

		override protected function produceResult():void {
			var sprite:Sprite;
			if (_cache) {
				sprite = _cache.createObject();
				_cache = null;
			}
			else {
				sprite = Sprite(_loader2.content);
				CACHE.push(new SwfLoaderCachedItem(_domain, url, Class(_domain.getDefinition(getQualifiedClassName(sprite)))));
				unloadAndStop();
			}

			_receiver.receiveSwf(sprite);
			_receiver = null;
		}

		override protected function freeLoading():void {
			if (_loader1) {
				_loader1.removeEventListener(Event.COMPLETE, onComplete1);
				_loader1.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
				_loader1 = null;
			}
			if (_loader2) {
				const info:LoaderInfo = _loader2.contentLoaderInfo;
				info.removeEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
				info.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);

				unloadAndStop();
				_loader2 = null;
			}
		}

		private function unloadAndStop():void {
			if (_loader2) {
				try {
					_loader2.unloadAndStop(true);
				}
				catch (e:Error) {
				}
			}
		}

		private function emulateLoad():void {
			handleLoadingCompleteEvent(null);
		}

		private function onComplete1(event:Event):void {
			_loader2 = new Loader();

			const info:LoaderInfo = _loader2.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			info.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);

			UncaughtErrorDelegate.register(_loader2.uncaughtErrorEvents);

			_loader2.loadBytes(_loader1.data, new LoaderContext(false, _domain, null));
		}
	}
}
