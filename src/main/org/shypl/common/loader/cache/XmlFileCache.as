package org.shypl.common.loader.cache {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.XmlReceiver;
	
	internal class XmlFileCache extends FileCache implements XmlReceiver {
		public function XmlFileCache(url:String) {
			setProgress(FileLoader.loadXml(url, this, this));
		}
		
		public function receiveXml(xml:XML):void {
			handleLoadingComplete(xml);
		}
	}
}
