package org.shypl.common.loader {
	import flash.utils.ByteArray;

	public interface BytesReceiver {
		function receiveBytes(bytes:ByteArray):void;
	}
}
