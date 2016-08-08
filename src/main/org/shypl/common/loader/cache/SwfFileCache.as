package org.shypl.common.loader.cache {
	import flash.system.ApplicationDomain;
	
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfFile;
	import org.shypl.common.loader.SwfReceiver;
	
	internal class SwfFileCache extends FileCache implements SwfReceiver {
		public function SwfFileCache(url:String, domain:ApplicationDomain) {
			setProgress(FileLoader.loadSwf(url, this, domain, this));
		}
		
		public function receiveSwf(swf:SwfFile):void {
			handleLoadingComplete(swf);
		}
	}
}
