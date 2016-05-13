package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;

	public class SwfAsset extends Asset {
		private var _sprite:Sprite;
		private var _domain:ApplicationDomain;

		public function SwfAsset(path:FilePath, domain:ApplicationDomain = null) {
			super(path);
			_domain = domain === null ? (new ApplicationDomain(ApplicationDomain.currentDomain)) : domain;
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

		public function hasClass(className:String):Boolean {
			return _domain.hasDefinition(className);
		}

		public function create(className:String):Object {
			if (hasClass(className)) {
				var Cls:Class = Class(_domain.getDefinition(className));
				return new Cls();
			}
			throw new IllegalArgumentException("Class " + className + " is not defined in SwfAsset " + path);
		}

		public function createRootSprite():Sprite {
			return createSprite(getQualifiedClassName(_sprite));
		}

		public function createRootMovieClip():MovieClip {
			return MovieClip(createRootSprite());
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

		public function createSound(className:String):Sound {
			return Sound(create(className));
		}

		override protected function doLoad():Progress {
			return new SwfAssetLoader(this);
		}

		override protected function doFree():void {
			_sprite = null;
			_domain = null;
		}

		internal function receiveData(sprite:Sprite):void {
			_sprite = sprite;
			completeLoad();
		}
	}
}
