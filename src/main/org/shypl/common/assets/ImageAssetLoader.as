package org.shypl.common.assets {
	import flash.display.BitmapData;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.util.progress.ProgressProxy;

	internal class ImageAssetLoader extends ProgressProxy implements ImageReceiver {
		private var _asset:ImageAsset;

		public function ImageAssetLoader(asset:ImageAsset) {
			_asset = asset;
			setProgress(FileLoader.loadImage(_asset.path.toString(), this));
		}

		public function receiveImage(image:BitmapData):void {
			_asset.receiveData(image);
			_asset = null;
		}
	}
}




