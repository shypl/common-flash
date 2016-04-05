package org.shypl.common.assets {
	import flash.display.BitmapData;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;

	public class AtlasLoader implements Progress, XmlReceiver, ImageReceiver {
		private var _asset:AtlasAssetImpl;
		private var _progress:Progress;
		private var _xml:XML;

		public function AtlasLoader(asset:AtlasAssetImpl) {
			_asset = asset;
			_progress = FileLoader.loadXml(asset.path, this);
		}

		public function get completed():Boolean {
			return _asset === null;
		}

		public function get percent():Number {
			if (completed) {
				return 1;
			}
			if (_xml) {
				return 0.2 + _progress.percent * 0.8;
			}
			return _progress.percent * 0.2;
		}

		public function receiveXml(xml:XML):void {
			_xml = xml;
			var imagePath:String = _xml.attribute("imagePath");
			if (imagePath.indexOf("/") !== 0 && imagePath.indexOf("://") === -1) {
				imagePath = FilePath.factory(_asset.path).resolveSibling(imagePath).toString();
			}
			FileLoader.loadImage(imagePath, this);
		}

		public function receiveImage(image:BitmapData):void {
			_asset.complete(_xml, image);
			_xml = null;
			_asset = null;
			_progress = null;
		}
	}
}
