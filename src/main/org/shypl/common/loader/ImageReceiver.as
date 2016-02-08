package org.shypl.common.loader {
	import flash.display.BitmapData;

	public interface ImageReceiver {
		function receiveImage(image:BitmapData):void;
	}
}
