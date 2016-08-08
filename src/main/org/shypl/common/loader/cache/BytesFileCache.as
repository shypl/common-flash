package org.shypl.common.loader.cache {
	import flash.utils.ByteArray;
	
	import org.shypl.common.loader.BytesReceiver;
	import org.shypl.common.loader.FileLoader;
	
	internal class BytesFileCache extends FileCache implements BytesReceiver {
		public function BytesFileCache(url:String) {
			setProgress(FileLoader.loadBytes(url, this, this));
		}
		
		public function receiveBytes(bytes:ByteArray):void {
			handleLoadingComplete(bytes);
		}
	}
}
