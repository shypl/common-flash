package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.CollectionUtils;

	internal class AssetsCollectionImpl implements AssetsCollection {
		private var _map:Object;

		function AssetsCollectionImpl(map:Object) {
			_map = map;
		}

		public function getBinary(name:String):BytesAsset {
			return BytesAsset(getAsset(name));
		}

		public function getText(name:String):TextAsset {
			return TextAsset(getAsset(name));
		}

		public function getXml(name:String):XmlAsset {
			return XmlAsset(getAsset(name));
		}

		public function getImage(name:String):ImageAsset {
			return ImageAsset(getAsset(name));
		}

		public function getAtlas(name:String):AtlasAsset {
			return AtlasAsset(getAsset(name));
		}

		public function getSound(name:String):SoundAsset {
			return SoundAsset(getAsset(name));
		}

		public function getSwf(name:String):SwfAsset {
			return SwfAsset(getAsset(name));
		}

		public function getFont(name:String):FontAsset {
			return FontAsset(getAsset(name));
		}

		public function getRawBinary(name:String):ByteArray {
			return getBinary(name).bytes;
		}

		public function getRawText(name:String):String {
			return getText(name).text;
		}

		public function getRawXml(name:String):XML {
			return getXml(name).xml;
		}

		public function getRawImage(name:String):BitmapData {
			return getImage(name).bitmapData;
		}

		public function getRawSound(name:String):Sound {
			return getSound(name).sound;
		}

		public function getRawSwf(name:String):Sprite {
			return getSwf(name).sprite;
		}

		public function getRawFont(name:String):Font {
			return getFont(name).font;
		}

		public function free():void {
			for each (var asset:AbstractAsset in _map) {
				asset.free();
			}
			CollectionUtils.clear(_map);
			_map = null;
		}

		private function getAsset(name:String):Asset {
			var asset:Asset = _map[name];
			if (asset == null) {
				throw new IllegalArgumentException("Asset named " + name + " is not exist");
			}
			return asset;
		}
	}
}
