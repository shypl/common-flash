package org.shypl.common.loader.cache {
	import flash.system.ApplicationDomain;
	
	import org.shypl.common.collection.HashMap;
	import org.shypl.common.collection.Map;
	import org.shypl.common.lang.isNull;
	import org.shypl.common.loader.BytesReceiver;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.loader.LoadingFailHandler;
	import org.shypl.common.loader.SoundReceiver;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.loader.TextReceiver;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.progress.CancelableProgress;
	
	public class CachedFileLoader {
		private var _cache:Map = new HashMap();
		
		public function CachedFileLoader() {
		}
		
		public function loadBytes(url:String, receiver:BytesReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:BytesFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new BytesFileCache(url);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveBytes, failHandler);
			return cache;
		}
		
		public function loadText(url:String, receiver:TextReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:TextFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new TextFileCache(url);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveText, failHandler);
			return cache;
		}
		
		public function loadXml(url:String, receiver:XmlReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:XmlFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new XmlFileCache(url);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveXml, failHandler);
			return cache;
		}
		
		public function loadImage(url:String, receiver:ImageReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:ImageFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new ImageFileCache(url);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveImage, failHandler);
			return cache;
		}
		
		public function loadSound(url:String, receiver:SoundReceiver, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:SoundFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new SoundFileCache(url);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveSound, failHandler);
			return cache;
		}
		
		public function loadSwf(url:String, receiver:SwfReceiver, domain:ApplicationDomain = null, failHandler:LoadingFailHandler = null):CancelableProgress {
			var cache:SwfFileCache = _cache.get(url);
			if (isNull(cache)) {
				cache = new SwfFileCache(url, domain);
				_cache.put(url, cache);
			}
			cache.addReceiver(receiver.receiveSwf, failHandler);
			return cache;
		}
	}
}
