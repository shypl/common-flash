package org.shypl.common.assets {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.progress.ProgressProxy;
	
	internal class XmlAssetLoader extends ProgressProxy implements XmlReceiver {
		private var _asset:XmlAsset;
		
		public function XmlAssetLoader(asset:XmlAsset) {
			_asset = asset;
			setProgress(FileLoader.loadXml(_asset.path.toString(), this));
		}
		
		public function receiveXml(xml:XML):void {
			_asset.receiveData(xml);
			_asset = null;
		}
	}
}
