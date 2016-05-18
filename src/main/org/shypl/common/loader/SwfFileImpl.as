package org.shypl.common.loader {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.lang.IllegalArgumentException;

	public class SwfFileImpl implements SwfFile {
		private var _domain:ApplicationDomain;
		private var _url:String;
		private var _content:Sprite;
		private var _width:int;
		private var _height:int;

		public function SwfFileImpl(domain:ApplicationDomain, url:String, loader:Loader) {
			_domain = domain;
			_url = url;

			_content = Sprite(loader.content);
			_width = loader.contentLoaderInfo.width;
			_height = loader.contentLoaderInfo.height;
		}

		public function get content():Sprite {
			return _content;
		}

		public function get width():int {
			return _width;
		}

		public function get height():int {
			return _height;
		}

		public function get domain():ApplicationDomain {
			return _domain;
		}

		public function hasClass(className:String):Boolean {
			return _domain.hasDefinition(className);
		}

		public function create(className:String):Object {
			if (hasClass(className)) {
				var Cls:Class = Class(_domain.getDefinition(className));
				return new Cls();
			}
			throw new IllegalArgumentException("Class " + className + " is not defined in SwfFile " + _url);
		}

		public function cloneContent():Sprite {
			return Sprite(create(getQualifiedClassName(_content)));
		}

		internal function matches(domain:ApplicationDomain, url:String):Boolean {
			return _domain == domain && _url == url;
		}
	}
}
