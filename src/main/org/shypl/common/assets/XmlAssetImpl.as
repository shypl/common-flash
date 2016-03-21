package org.shypl.common.assets {
	import flash.system.System;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.XmlReceiver;
	import org.shypl.common.util.Progress;

	internal class XmlAssetImpl extends AbstractAsset implements XmlAsset, XmlReceiver {
		private var _xml:XML;

		public function XmlAssetImpl(name:String, path:String, deferred:Boolean) {
			super(name, path, deferred);
		}

		public function get xml():XML {
			return _xml;
		}

		override public function load():Progress {
			return FileLoader.loadXml(path, this);
		}

		public function receiveXml(xml:XML):void {
			_xml = xml;
			completeLoad();
		}

		override protected function doFree():void {
			if (_xml) {
				System.disposeXML(_xml);
				_xml = null;
			}
		}
	}
}
