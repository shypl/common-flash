package org.shypl.common.assets {
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	
	public class TextAsset extends Asset {
		private var _text:String;
		
		function TextAsset(path:FilePath) {
			super(path);
		}
		
		public function get text():String {
			checkAvailable();
			return _text;
		}
		
		override protected function doLoad():Progress {
			return new TextAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			_text = null;
		}
		
		internal function receiveData(text:String):void {
			_text = text;
			completeLoad();
		}
	}
}
