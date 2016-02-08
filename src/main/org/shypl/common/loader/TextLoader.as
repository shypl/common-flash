package org.shypl.common.loader {
	internal class TextLoader extends SimpleLoader {
		private var _receiver:TextReceiver;

		function TextLoader(url:String, receiver:TextReceiver) {
			super(url, false);
			_receiver = receiver;
		}

		override protected function completeText(data:String):void {
			_receiver.receiveText(data);
			_receiver = null;
		}
	}
}
