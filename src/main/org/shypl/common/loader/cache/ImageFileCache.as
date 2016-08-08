package org.shypl.common.loader.cache {
	import flash.display.BitmapData;
	
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	
	internal class ImageFileCache extends FileCache implements ImageReceiver {
		public function ImageFileCache(url:String) {
			setProgress(FileLoader.loadImage(url, this, this));
		}
		
		public function receiveImage(image:BitmapData):void {
			handleLoadingComplete(image);
		}
	}
}
