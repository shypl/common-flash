package org.shypl.common.assets {
	import flash.system.System;
	
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	
	public class XmlAsset extends Asset {
		private var _xml:XML;
		
		function XmlAsset(path:FilePath) {
			super(path);
		}
		
		public function get xml():XML {
			return _xml;
		}
		
		override protected function doLoad():Progress {
			return new XmlAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			if (_xml) {
				System.disposeXML(_xml);
				_xml = null;
			}
		}
		
		internal function receiveData(xml:XML):void {
			_xml = xml;
			completeLoad();
		}
	}
}
