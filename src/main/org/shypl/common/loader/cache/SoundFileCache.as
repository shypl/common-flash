package org.shypl.common.loader.cache {
	import flash.media.Sound;
	
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SoundReceiver;
	
	internal class SoundFileCache extends FileCache implements SoundReceiver {
		public function SoundFileCache(url:String) {
			setProgress(FileLoader.loadSound(url, this, this));
		}
		
		public function receiveSound(sound:Sound):void {
			handleLoadingComplete(sound);
		}
	}
}
