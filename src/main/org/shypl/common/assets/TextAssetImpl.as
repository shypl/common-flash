package org.shypl.common.assets {
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.TextReceiver;
	import org.shypl.common.util.Progress;

	internal class TextAssetImpl extends AbstractAsset implements TextAsset, TextReceiver {
		private var _text:String;

		public function TextAssetImpl(path:String, deferred:Boolean) {
			super(path, deferred);
		}

		public function get text():String {
			return _text;
		}

		override public function load():Progress {
			return FileLoader.loadText(path, this);
		}

		public function receiveText(text:String):void {
			_text = text;
			completeLoad();
		}

		override protected function doFree():void {
			_text = null;
		}
	}
}
