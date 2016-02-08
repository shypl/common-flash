package org.shypl.common.assets {
	import flash.utils.ByteArray;

	import org.shypl.common.loader.BytesReceiver;
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.util.Progress;

	internal class BytesAssetImpl extends AbstractAsset implements BytesReceiver {
		private var _bytes:ByteArray;

		public function BytesAssetImpl(path:String, deferred:Boolean) {
			super(path, deferred);
		}

		public function get bytes():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(_bytes);
			bytes.position = 0;
			return bytes;
		}

		override public function load():Progress {
			return FileLoader.loadBytes(path, this);
		}

		public function receiveBytes(bytes:ByteArray):void {
			_bytes = bytes;
			completeLoad();
		}

		override protected function doFree():void {
			_bytes.length = 0;
			_bytes = null;
		}
	}
}
