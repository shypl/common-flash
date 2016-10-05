package org.shypl.common.loader {
	internal class TextLoader extends DataLoader {
		private var _receiver:TextReceiver;
		
		function TextLoader(url:String, receiver:TextReceiver, failHandler:LoadingFailHandler) {
			super(url, failHandler, false);
			_receiver = receiver;
		}
		
		override protected function produceText(data:String):void {
			_receiver.receiveText(data);
			_receiver = null;
		}
		
		override protected function free():void {
			super.free();
		}
	}
}
