package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.shypl.common.util.BitmapUtils;
	import org.shypl.common.util.DestroyableBitmap;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	
	public class ImageAsset extends Asset {
		private var _bitmapData:BitmapData;
		
		public function ImageAsset(path:FilePath) {
			super(path);
		}
		
		public function get bitmapData():BitmapData {
			checkAvailable();
			return _bitmapData;
		}
		
		public function getRectangle(rect:Rectangle):BitmapData {
			checkAvailable();
			return BitmapUtils.getRectangle(_bitmapData, rect);
		}
		
		public function copyRectangle(rect:Rectangle, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void {
			checkAvailable();
			target.copyPixels(_bitmapData, rect, targetPoint, null, null, mergeAlpha);
		}
		
		public function createBitmap(rect:Rectangle = null):Bitmap {
			checkAvailable();
			var bitmapData:BitmapData;
			if (rect === null) {
				bitmapData = _bitmapData;
			}
			else {
				bitmapData = getRectangle(rect);
			}
			return new Bitmap(bitmapData, PixelSnapping.AUTO, true);
		}
		
		public function createDestroyableBitmap(rect:Rectangle = null):DestroyableBitmap {
			checkAvailable();
			var bitmapData:BitmapData;
			if (rect === null) {
				bitmapData = _bitmapData;
			}
			else {
				bitmapData = getRectangle(rect);
			}
			return new DestroyableBitmap(bitmapData);
		}
		
		override protected function doLoad():Progress {
			return new ImageAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			if (_bitmapData) {
				_bitmapData.dispose();
				_bitmapData = null;
			}
		}
		
		internal function receiveData(image:BitmapData):void {
			_bitmapData = image;
			completeLoad();
		}
	}
}
