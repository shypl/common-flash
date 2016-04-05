package org.shypl.common.app {
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import org.shypl.common.lang.ErrorEventException;
	import org.shypl.common.lang.UncaughtErrorDelegate;

	public class MainPreloaderPhase extends PreloaderPhase {
		private var _loader1:URLLoader;
		private var _loader2:Loader;
		private var _main:AbstractMain;
		private var _mainFileProperty:String;

		public function MainPreloaderPhase(mainFileProperty:String = "main", name:String = "Loading main file", totalFinalProgress:int = 10) {
			super(name, totalFinalProgress);
			_mainFileProperty = mainFileProperty;
		}

		override public function get percent():Number {
			if (_loader1 !== null) {
				return _loader1.bytesLoaded / _loader1.bytesTotal * 0.99;
			}
			if (_loader2 !== null) {
				return 0.99;
			}
			return 1;
		}

		override public function get completed():Boolean {
			return _main !== null;
		}

		override public function start():void {
			var mainFile:String = flashVars[_mainFileProperty];
			if (mainFile == null) {
				mainFile = "Main.swf";
			}

			_loader1 = new URLLoader();
			_loader1.dataFormat = URLLoaderDataFormat.BINARY;
			_loader1.addEventListener(Event.COMPLETE, onComplete1);
			_loader1.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_loader1.load(new URLRequest(mainFile));
		}

		override public function finish():PreloaderPhase {
			var nextPhase:PreloaderPhase = _main.run(flashVars, stage);
			_main = null;
			return nextPhase;
		}

		private function onComplete1(event:Event):void {
			_loader1.removeEventListener(Event.COMPLETE, onComplete1);

			_loader2 = new Loader();
			_loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete2);
			_loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

			UncaughtErrorDelegate.register(_loader2.uncaughtErrorEvents);

			_loader2.loadBytes(_loader1.data, new LoaderContext(false, ApplicationDomain.currentDomain));

			_loader1 = null;
		}

		private function onComplete2(event:Event):void {
			_loader2.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete2);

			_main = AbstractMain(_loader2.content);

			_loader2.unloadAndStop();
			_loader2 = null;
		}

		private function onError(event:ErrorEvent):void {
			throw new ErrorEventException(event, "Can not load main file");
		}
	}
}
