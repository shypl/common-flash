package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.system.System;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.FilePathUtils;
	import org.shypl.common.util.progress.FakeProgress;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.progress.UnevenCompositeProgress;

	internal class AtlasAssetLoader extends UnevenCompositeProgress implements XmlReceiver, ImageReceiver {
		private var _asset:AtlasAsset;
		private var _xml:XML;

		public function AtlasAssetLoader(asset:AtlasAsset) {
			super(new <Progress>[FileLoader.loadXml(asset.path.toString(), this), FakeProgress.NOT_COMPLETED], new <int>[2, 8]);
			_asset = asset;
		}

		public function receiveXml(xml:XML):void {
			_xml = xml;
			var imagePath:String = _xml.attribute("imagePath");
			if (imagePath.indexOf("/") !== 0 && imagePath.indexOf("://") === -1) {
				imagePath = _asset.path.resolveSibling(imagePath).toString();
			}
			setChild(1, FileLoader.loadImage(imagePath, this));
		}

		public function receiveImage(image:BitmapData):void {
			_asset.receiveData(_xml, image);
			System.disposeXML(_xml);
			_asset = null;
			_xml = null;
		}
	}
}
