package org.shypl.common.assets {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.TextReceiver;
	import org.shypl.common.util.progress.ProgressProxy;

	internal class TextAssetLoader extends ProgressProxy implements TextReceiver {
		private var _asset:TextAsset;

		public function TextAssetLoader(asset:TextAsset) {
			_asset = asset;
			setProgress(FileLoader.loadText(_asset.path, this));
		}

		public function receiveText(text:String):void {
			_asset.receiveData(text);
			_asset = null;
		}
	}
}
