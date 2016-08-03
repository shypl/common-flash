package org.shypl.common.assets {
	import flash.media.Sound;
	
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SoundReceiver;
	import org.shypl.common.util.progress.ProgressProxy;
	
	internal class SoundAssetLoader extends ProgressProxy implements SoundReceiver {
		private var _asset:SoundAsset;
		
		public function SoundAssetLoader(asset:SoundAsset) {
			_asset = asset;
			setProgress(FileLoader.loadSound(_asset.path.toString(), this));
		}
		
		public function receiveSound(sound:Sound):void {
			_asset.receiveData(sound);
			_asset = null;
		}
	}
}
