package org.shypl.common.assets {
	import flash.utils.ByteArray;
	
	import org.shypl.common.loader.BytesReceiver;
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.util.progress.ProgressProxy;
	
	internal class BytesAssetLoader extends ProgressProxy implements BytesReceiver {
		private var _asset:BytesAsset;
		
		public function BytesAssetLoader(asset:BytesAsset) {
			_asset = asset;
			setProgress(FileLoader.loadBytes(_asset.path.toString(), this));
		}
		
		public function receiveBytes(bytes:ByteArray):void {
			_asset.receiveData(bytes);
			_asset = null;
		}
	}
}
