package org.shypl.common.loader {
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
	import flash.utils.ByteArray;
	
	import org.shypl.common.lang.UncaughtErrorDelegate;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;
	
	internal class SwfLoader extends AbstractLoader {
		private static const CACHE:Vector.<SwfFileImpl> = new Vector.<SwfFileImpl>();
		
		private var _receiver:SwfReceiver;
		private var _domain:ApplicationDomain;
		private var _cache:SwfFileImpl;
		private var _loader1:URLLoader;
		private var _loader2:Loader;
		private var _emulateLoad:Cancelable;
		
		function SwfLoader(url:String, receiver:SwfReceiver, domain:ApplicationDomain,
			failHandler:LoadingFailHandler
		) {
			super(url, failHandler);
			_receiver = receiver;
			_domain = domain === null ? ApplicationDomain.currentDomain : domain;
		}
		
		public final function get domain():ApplicationDomain {
			return _domain;
		}
		
		override protected function cancelLoading():void {
			if (_emulateLoad) {
				_emulateLoad.cancel();
			}
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
			for each (var swf:SwfFileImpl in CACHE) {
				if (swf.matches(_domain, url)) {
					_cache = swf;
					_emulateLoad = GlobalTimeline.callDeferred(emulateLoad);
					return;
				}
			}
			
			_loader1 = new URLLoader();
			_loader1.dataFormat = URLLoaderDataFormat.BINARY;
			_loader1.addEventListener(Event.COMPLETE, onComplete1);
			_loader1.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_loader1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadingErrorEvent);
			_loader1.load(new URLRequest(url));
		}
		
		override protected function produceResult():void {
			var swf:SwfFileImpl;
			if (_cache != null) {
				swf = _cache;
				_cache = null;
			}
			else {
				swf = new SwfFileImpl(_domain, url, _loader2);
				CACHE.push(swf);
				unloadAndStop();
			}
			
			_receiver.receiveSwf(swf);
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
				
				unloadAndStop();
				_loader2 = null;
			}
		}
		
		override protected function free():void {
			super.free();
			_receiver = null;
			_cache = null;
			_emulateLoad = null;
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
			var source:ByteArray = _loader1.data;
			var target:ByteArray = new ByteArray();
			target.writeBytes(source);
			target.position = 0;
			
			_loader2 = new Loader();
			
			const info:LoaderInfo = _loader2.contentLoaderInfo;
			info.addEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			info.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			
			UncaughtErrorDelegate.register(_loader2.uncaughtErrorEvents);
			
			_loader2.loadBytes(target, new LoaderContext(false, _domain, null));
		}
	}
}
