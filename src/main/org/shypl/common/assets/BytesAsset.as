package org.shypl.common.assets {
	import flash.utils.ByteArray;
	
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	
	public class BytesAsset extends Asset {
		private var _bytes:ByteArray;
		
		public function BytesAsset(path:FilePath) {
			super(path);
		}
		
		public function get bytes():ByteArray {
			checkAvailable();
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(_bytes);
			bytes.position = 0;
			return bytes;
		}
		
		override protected function doLoad():Progress {
			return new BytesAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			_bytes.length = 0;
			_bytes = null;
		}
		
		internal function receiveData(data:ByteArray):void {
			_bytes = data;
			completeLoad();
		}
	}
}
