package org.shypl.common.loader {
	internal class XmlLoader extends DataLoader {
		private var _receiver:XmlReceiver;

		function XmlLoader(url:String, receiver:XmlReceiver) {
			super(url, false);
			_receiver = receiver;
		}

		override protected function produceText(data:String):void {
			_receiver.receiveXml(new XML(data));
			_receiver = null;
		}
	}
}