package org.shypl.common.loader.cache {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.TextReceiver;
	
	internal class TextFileCache extends FileCache implements TextReceiver {
		public function TextFileCache(url:String) {
			setProgress(FileLoader.loadText(url, this, this));
		}
		
		public function receiveText(text:String):void {
			handleLoadingComplete(text);
		}
	}
}
