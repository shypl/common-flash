package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.ImageReceiver;
	import org.shypl.common.util.BitmapUtils;
	import org.shypl.common.util.Progress;

	internal class ImageAssetImpl extends AbstractAsset implements ImageAsset, ImageReceiver {
		private var _bitmapData:BitmapData;

		public function ImageAssetImpl(name:String, path:String, deferred:Boolean) {
			super(name, path, deferred);
		}

		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		override public function load():Progress {
			return FileLoader.loadImage(path, this);
		}

		public function getRectangle(rect:Rectangle):BitmapData {
			return BitmapUtils.getRectangle(_bitmapData, rect);
		}

		public function copyRectangle(rect:Rectangle, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void {
			target.copyPixels(_bitmapData, rect, targetPoint, null, null, mergeAlpha);
		}

		public function createBitmap(rect:Rectangle = null):Bitmap {
			var bitmapData:BitmapData;
			if (rect === null) {
				bitmapData = _bitmapData;
			}
			else {
				bitmapData = getRectangle(rect);
			}
			return new Bitmap(bitmapData, PixelSnapping.AUTO, true);
		}

		public function receiveImage(image:BitmapData):void {
			_bitmapData = image;
			completeLoad();
		}

		override protected function doFree():void {
			if (_bitmapData) {
				_bitmapData.dispose();
				_bitmapData = null;
			}
		}
	}
}
