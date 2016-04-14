package org.shypl.common.assets {
	import flash.display.BitmapData;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.FilePathUtils;
	import org.shypl.common.util.progress.FakeProgress;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.progress.UnevenCompositeProgress;

	internal class AtlasLoader extends UnevenCompositeProgress implements Progress, XmlReceiver, ImageReceiver {
		private var _asset:AtlasAssetImpl;
		private var _xml:XML;

		public function AtlasLoader(asset:AtlasAssetImpl) {
			super(
				new <Progress>[FileLoader.loadXml(asset.path, this), FakeProgress.NOT_COMPLETED],
				new <int>[2, 8]);
			_asset = asset;
		}

		public function receiveXml(xml:XML):void {
			_xml = xml;
			var imagePath:String = _xml.attribute("imagePath");
			if (imagePath.indexOf("/") !== 0 && imagePath.indexOf("://") === -1) {
				imagePath = FilePathUtils.resolveSibling(_asset.path, imagePath).toString();
			}
			setChild(1, FileLoader.loadImage(imagePath, this));
		}

		public function receiveImage(image:BitmapData):void {
			_asset.complete(_xml, image);
			_asset = null;
			_xml = null;
		}
	}
}
