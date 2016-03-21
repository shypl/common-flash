package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.Progress;

	internal class SwfAssetImpl extends AbstractAsset implements SwfAsset, SwfReceiver {
		private var _objectFactory:SwfAssetObjectResolver = SwfAssetObjectResolver.DEFAULT;
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

		public function setObjectResolver(factory:SwfAssetObjectResolver):void {
			_objectFactory = factory;
		}

		public function getObject(name:String, type:String = null):Object {
			var Cls:Class = Class(_domain.getDefinition(_objectFactory.getClassName(name, type)));
			return _objectFactory.resolveObject(new Cls(), type);
		}

		public function getBitmapData(name:String):BitmapData {
			return BitmapData(getObject(name, SwfAssetObjectType.BITMAP_DATA));
		}

		public function getMovieClip(name:String):MovieClip {
			return MovieClip(getObject(name, SwfAssetObjectType.MOVIE_CLIP));
		}

		public function getSprite(name:String):Sprite {
			return Sprite(getObject(name, SwfAssetObjectType.SPRITE));
		}

		public function getTextField(name:String, text:String = null):TextField {
			var textField:TextField = TextField(getObject(name, SwfAssetObjectType.TEXT_FIELD));
			if (text !== null) {
				textField.text = text;
			}
			return textField;
		}

		public function receiveSwf(sprite:Sprite):void {
			_sprite = sprite;
			completeLoad();
		}

		override protected function doFree():void {
			_objectFactory = null;
			_sprite = null;
			_domain = null;
		}
	}
}
