package org.shypl.common.assets {
	import flash.display.Sprite;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.ProgressProxy;

	internal class SwfAssetLoader extends ProgressProxy implements SwfReceiver {
		private var _asset:SwfAsset;

		public function SwfAssetLoader(asset:SwfAsset) {
			_asset = asset;
			setProgress(FileLoader.loadSwf(_asset.path, this, _asset.domain));
		}

		public function receiveSwf(sprite:Sprite):void {
			_asset.receiveData(sprite);
			_asset = null;
		}
	}
}



