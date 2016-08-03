package org.shypl.common.assets {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfFile;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.ProgressProxy;
	
	internal class SwfAssetLoader extends ProgressProxy implements SwfReceiver {
		private var _asset:SwfAsset;
		
		public function SwfAssetLoader(asset:SwfAsset) {
			_asset = asset;
			setProgress(FileLoader.loadSwf(_asset.path.toString(), this, _asset.domain));
		}
		
		public function receiveSwf(swf:SwfFile):void {
			_asset.receiveData(swf);
			_asset = null;
		}
	}
}



