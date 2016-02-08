package org.shypl.common.loader {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	internal class SwfLoaderCachedItem {
		private var _domain:ApplicationDomain;
		private var _url:String;
		private var _cls:Class;

		function SwfLoaderCachedItem(domain:ApplicationDomain, url:String, cls:Class) {
			_domain = domain;
			_url = url;
			_cls = cls;
		}

		public function matches(domain:ApplicationDomain, url:String):Boolean {
			return _domain == domain && _url == url;
		}

		public function createObject():Sprite {
			return new _cls();
		}
	}
}
