package org.shypl.common.assets {

	import flash.system.ApplicationDomain;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.sound.SoundSystem;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.StringUtils;

	public class AssetsProducer implements AssetsCollector {
		private var _basePath:FilePath;
		private var _map:Object = {};

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
			var asset:AbstractAsset = _map[name];
			if (!asset) {
				asset = createAsset(name, path, type, deferred, domain);
				_map[name] = asset;
			}
			return asset;
		}

		public function addMany(names:Vector.<String>, deferred:Boolean = false, paths:Vector.<String> = null):Vector.<Asset> {
			var assets:Vector.<Asset> = new Vector.<Asset>(names.length, true);
			for (var i:int = 0; i < names.length; i++) {
				assets[i] = add(names[i], null, deferred, paths !== null ? paths[i] : null);
			}
			return assets;
		}

		public function load(receiver:AssetsReceiver = null):Progress {
			var map:Object = _map;
			_map = {};
			return new AssetsLoader(map, receiver);
		}

		private function createAsset(name:String, path:String, type:AssetType, deferred:Boolean, domain:ApplicationDomain):AbstractAsset {
			path = _basePath.resolve(path === null ? name : path).toString();

			if (type === null) {
				type = defineTypeByExt(path);
			}

			switch (type) {
				case AssetType.IMAGE:
					return new ImageAssetImpl(name, path, deferred);
				case AssetType.SOUND:
					return new SoundAssetImpl(name, path, deferred);
				case AssetType.SWF:
					return new SwfAssetImpl(name, path, domain === null ? new ApplicationDomain(ApplicationDomain.currentDomain) : domain, deferred);
				case AssetType.TEXT:
					return new TextAssetImpl(name, path, deferred);
				case AssetType.XML:
					return new XmlAssetImpl(name, path, deferred);
				case AssetType.FONT:
					return new FontAssetImpl(name, path, deferred);
				case AssetType.ATLAS:
					return new AtlasAssetImpl(name, path, deferred);
				case AssetType.BYTES:
					return new BytesAssetImpl(name, path, deferred);
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
