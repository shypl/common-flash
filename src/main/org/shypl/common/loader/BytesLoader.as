package org.shypl.common.loader {
	import flash.utils.ByteArray;

	internal class BytesLoader extends SimpleLoader {
		private var _receiver:BytesReceiver;

		function BytesLoader(url:String, receiver:BytesReceiver) {
			super(url, true);
			_receiver = receiver;
		}

		override protected function completeBytes(data:ByteArray):void {
			_receiver.receiveBytes(data);
			_receiver = null;
		}
	}
}
