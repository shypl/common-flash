package org.shypl.common.loader {
	internal class XmlLoader extends SimpleLoader {
		private var _receiver:XmlReceiver;

		function XmlLoader(url:String, receiver:XmlReceiver) {
			super(url, false);
			_receiver = receiver;
		}

		override protected function completeText(data:String):void {
			_receiver.receiveXml(new XML(data));
			_receiver = null;
		}
	}
}