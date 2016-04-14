package org.shypl.common.loader {
	import flash.utils.ByteArray;

	internal class BytesLoader extends DataLoader {
		private var _receiver:BytesReceiver;

		function BytesLoader(url:String, receiver:BytesReceiver) {
			super(url, true);
			_receiver = receiver;
		}

		override protected function produceBytes(data:ByteArray):void {
			_receiver.receiveBytes(data);
			_receiver = null;
		}
	}
}
