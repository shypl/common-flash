package org.shypl.common.assets {

	import flash.system.ApplicationDomain;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.StringUtils;
	import org.shypl.common.util.progress.Progress;

	public class AssetsProducer implements AssetsCollector {
		private var _basePath:FilePath;
		private var _items:Object = {};

		public function AssetsProducer(path:FilePath) {
			_basePath = path;
		}

		public function addBinary(name:String, deferred:Boolean = false, path:String = null):BytesAsset {
			return BytesAsset(add(name, AssetType.BYTES, deferred, path));
		}

		public function addText(name:String, deferred:Boolean = false, path:String = null):TextAsset {
			return TextAsset(add(name, AssetType.TEXT, deferred, path));
		}

		public function addXml(name:String, deferred:Boolean = false, path:String = null):XmlAsset {
			return XmlAsset(add(name, AssetType.XML, deferred, path));
		}

		public function addImage(name:String, deferred:Boolean = false, path:String = null):ImageAsset {
			return ImageAsset(add(name, AssetType.IMAGE, deferred, path));
		}

		public function addAtlas(name:String, deferred:Boolean = false, path:String = null):AtlasAsset {
			return AtlasAsset(add(name, AssetType.ATLAS, deferred, path));
		}

		public function addSound(name:String, deferred:Boolean = false, path:String = null):SoundAsset {
			return SoundAsset(add(name, AssetType.SOUND, deferred, path));
		}

		public function addSwf(name:String, deferred:Boolean = false, path:String = null, inCurrentDomain:Boolean = false):SwfAsset {
			return addSwfInDomain(name,
				inCurrentDomain ? ApplicationDomain.currentDomain : new ApplicationDomain(ApplicationDomain.currentDomain),
				deferred, path);
		}

		public function addSwfInDomain(name:String, domain:ApplicationDomain, deferred:Boolean = false, path:String = null):SwfAsset {
			return SwfAsset(add(name, AssetType.SWF, deferred, path, domain));
		}

		public function addFont(name:String, deferred:Boolean = false, path:String = null):FontAsset {
			return FontAsset(add(name, AssetType.FONT, deferred, path));
		}

		public function add(name:String, type:AssetType = null, deferred:Boolean = false, path:String = null, domain:ApplicationDomain = null):Asset {
			var item:AssetsCollectionItem = _items[name];
			if (item === null) {
				item = new AssetsCollectionItem(name, createAsset(name, path, type, domain), deferred);
				_items[name] = item;
			}
			else {
				item.deferred = deferred;
			}
			return item.asset;
		}

		public function addMany(names:Vector.<String>, deferred:Boolean = false, paths:Vector.<String> = null):Vector.<Asset> {
			var assets:Vector.<Asset> = new Vector.<Asset>(names.length, true);
			for (var i:int = 0; i < names.length; i++) {
				assets[i] = add(names[i], null, deferred, paths !== null ? paths[i] : null);
			}
			return assets;
		}

		public function load(receiver:AssetsReceiver = null):Progress {
			var items:Object = _items;
			_items = {};
			return new AssetsLoader(items, receiver);
		}

		private function createAsset(name:String, path:String, type:AssetType, domain:ApplicationDomain):Asset {
			path = _basePath.resolve(path === null ? name : path).toString();

			if (type === null) {
				type = defineTypeByExt(path);
			}

			switch (type) {
				case AssetType.IMAGE:
					return new ImageAsset(path);
				case AssetType.SOUND:
					return new SoundAsset(path);
				case AssetType.SWF:
					return new SwfAsset(path, domain === null ? new ApplicationDomain(ApplicationDomain.currentDomain) : domain);
				case AssetType.TEXT:
					return new TextAsset(path);
				case AssetType.XML:
					return new XmlAsset(path);
				case AssetType.FONT:
					return new FontAsset(path);
				case AssetType.ATLAS:
					return new AtlasAsset(path);
				case AssetType.BYTES:
					return new BytesAsset(path);
				default:
					throw new IllegalArgumentException();
			}
		}

		private function defineTypeByExt(path:String):AssetType {
			var ext:String = path.substr(path.lastIndexOf(".") + 1).toLowerCase();

			switch (ext) {
				case "png":
				case "jpg":
				case "jpeg":
				case "gif":
					return AssetType.IMAGE;

				case "mp3":
					return AssetType.SOUND;

				case "swf":
					if (StringUtils.contains(path, ".font.")) {
						return AssetType.FONT;
					}
					return AssetType.SWF;

				case "txt":
				case "properties":
					return AssetType.TEXT;

				case "xml":
					if (StringUtils.contains(path, ".atlas.")) {
						return AssetType.ATLAS;
					}
					return AssetType.XML;

				default :
					return AssetType.BYTES;
			}
		}
	}
}
