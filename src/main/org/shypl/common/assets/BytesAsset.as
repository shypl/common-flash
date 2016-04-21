package org.shypl.common.assets {
	import flash.utils.ByteArray;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.util.progress.Progress;

	public class BytesAsset extends Asset {
		private var _bytes:ByteArray;

		public function BytesAsset(path:String) {
			super(path);
		}

		public function get bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(_bytes);
			bytes.position = 0;
			return bytes;
		}

		override protected function doLoad():Progress {
			return new BytesAssetLoader(this);
		}

		override protected function doFree():void {
			_bytes.length = 0;
			_bytes = null;
		}

		internal function receiveData(data:ByteArray):void {
			_bytes = data;
			completeLoad();
		}
	}
}
