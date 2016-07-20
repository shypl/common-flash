package org.shypl.common.loader {
	import flash.system.ApplicationDomain;
	
	import org.shypl.common.collection.Deque;
	import org.shypl.common.collection.LinkedList;
	import org.shypl.common.logging.LogManager;
	import org.shypl.common.logging.Logger;
	import org.shypl.common.util.progress.CancelableProgress;
	
	public final class FileLoader {
		internal static const LOGGER:Logger = LogManager.getLoggerByClass(FileLoader);
		
		private static var _queue:Deque = new LinkedList();
		private static var _currentProcesses:int = 0;
		private static var _parallelProcesses:int = 5;
		
		public static function get parallelProcesses():int {
			return _parallelProcesses;
		}
		
		public static function set parallelProcesses(value:int):void {
			_parallelProcesses = value;
			loadNext();
		}
		
		public static function loadBytes(url:String, receiver:BytesReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			return addLoader(new BytesLoader(url, receiver, failHandler));
		}
		
		public static function loadText(url:String, receiver:TextReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			return addLoader(new TextLoader(url, receiver, failHandler));
		}
		
		public static function loadXml(url:String, receiver:XmlReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			return addLoader(new XmlLoader(url, receiver, failHandler));
		}
		
		public static function loadImage(url:String, receiver:ImageReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			return addLoader(new ImageLoader(url, receiver, failHandler));
		}
		
		public static function loadSound(url:String, receiver:SoundReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			return addLoader(new SoundLoader(url, receiver, failHandler));
		}
		
		public static function loadSwf(url:String, receiver:SwfReceiver, domain:ApplicationDomain = null,
			failHandler:LoadingFailHandler = null
		):CancelableProgress {
			return addLoader(new SwfLoader(url, receiver, domain, failHandler));
		}
		
		internal static function handleLoadingComplete():void {
			--_currentProcesses;
			loadNext();
		}
		
		private static function addLoader(loader:AbstractLoader):CancelableProgress {
			_queue.addLast(loader);
			loadNext();
			return loader;
		}
		
		private static function loadNext():void {
			if (_currentProcesses < _parallelProcesses && !_queue.isEmpty()) {
				++_currentProcesses;
				AbstractLoader(_queue.removeFirst()).run();
			}
		}
	}
}
