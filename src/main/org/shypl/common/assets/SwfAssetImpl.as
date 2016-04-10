package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.Progress;

	internal class SwfAssetImpl extends AbstractAsset implements SwfAsset, SwfReceiver {
		private var _sprite:Sprite;
		private var _domain:ApplicationDomain;

		public function SwfAssetImpl(name:String, path:String, domain:ApplicationDomain, deferred:Boolean) {
			super(name, path, deferred);
			_domain = domain;
		}

		public function get sprite():Sprite {
			return _sprite;
		}

		public function get movieClip():MovieClip {
			return MovieClip(_sprite);
		}

		public function get domain():ApplicationDomain {
			return _domain;
		}

		override public function load():Progress {
			return FileLoader.loadSwf(path, this, _domain);
		}

		public function hasClass(className:String):Boolean {
			return _domain.hasDefinition(className);
		}

		public function create(className:String):Object {
			if (hasClass(className)) {
				var Cls:Class = Class(_domain.getDefinition(className));
				return new Cls();
			}
			throw new IllegalArgumentException("Class " + className + " is not defined in SwfAsset " + name);
		}

		public function createSprite(className:String):Sprite {
			return Sprite(create(className));
		}

		public function createMovieClip(className:String):MovieClip {
			return MovieClip(create(className));
		}

		public function createBitmapData(className:String):BitmapData {
			return BitmapData(create(className));
		}

		public function receiveSwf(sprite:Sprite):void {
			_sprite = sprite;
			completeLoad();
		}

		override protected function doFree():void {
			_sprite = null;
			_domain = null;
		}
	}
}
