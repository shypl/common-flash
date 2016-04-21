package org.shypl.common.assets {
	import org.shypl.common.util.progress.Progress;

	public class TextAsset extends Asset {
		private var _text:String;

		function TextAsset(path:String) {
			super(path);
		}

		public function get text():String {
			return _text;
		}

		override protected function doLoad():Progress {
			return new TextAssetLoader(this);
		}

		override protected function doFree():void {
			_text = null;
		}

		internal function receiveData(text:String):void {
			_text = text;
			completeLoad();
		}
	}
}
