package org.shypl.common.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public final class BitmapUtils {

		public static function getRectangle(source:BitmapData, rect:Rectangle):BitmapData {
			var copy:BitmapData = new BitmapData(rect.width, rect.height);
			copy.copyPixels(source, rect, StaticPoint0.INSTANCE);
			return copy;
		}

		public static function createBitmap(image:BitmapData, smoothing:Boolean = true, pixelSnapping:String = PixelSnapping.AUTO, x:Number = 0, y:Number = 0,
			scale:Number = 1
		):Bitmap {
			const bitmap:Bitmap = new Bitmap(image, pixelSnapping, smoothing);
			bitmap.x = x;
			bitmap.y = y;
			bitmap.scaleX = scale;
			bitmap.scaleY = scale;
			return bitmap;
		}

		public static function defineVisibleBounds(target:IBitmapDrawable):Rectangle {
			if (target is DisplayObject) {
				return defineVisibleBoundsForDisplayObject(DisplayObject(target));
			}
			return defineVisibleBoundsForBitmapData(BitmapData(target));
		}

		public static function defineVisibleBoundsForDisplayObject(target:DisplayObject):Rectangle {
			var object:DisplayObject = DisplayObject(target);
			var data:BitmapData = new BitmapData(object.width, object.height, true, 0);

			data.draw(object);
			var rect:Rectangle = defineVisibleBounds(data);
			data.dispose();

			return rect;
		}

		public static function defineVisibleBoundsForBitmapData(target:BitmapData):Rectangle {
			var w:int = target.width;
			var h:int = target.height;
			var x:int;
			var y:int;
			var l:int = -1;
			var t:int = -1;
			var r:int = -1;
			var b:int = -1;

			for (x = 0; x < w; x++) {
				for (y = 0; y < h; y++) {
					if (0 != target.getPixel32(x, y)) {
						l = x;
						break;
					}
				}
				if (l >= 0) {
					break;
				}
			}

			for (y = 0; y < h; y++) {
				for (x = 0; x < w; x++) {
					if (0 != target.getPixel32(x, y)) {
						t = y;
						break;
					}
				}
				if (t >= 0) {
					break;
				}
			}

			for (x = w - 1; x >= 0; x--) {
				for (y = 0; y < h; y++) {
					if (0 != target.getPixel32(x, y)) {
						r = x + 1;
						break;
					}
				}
				if (r >= 0) {
					break;
				}
			}

			for (y = h - 1; y >= 0; y--) {
				for (x = 0; x < w; x++) {
					if (0 != target.getPixel32(x, y)) {
						b = y + 1;
						break;
					}
				}
				if (b >= 0) {
					break;
				}
			}

			if (l == -1) {
				l = 0;
				r = 0;
				t = 0;
				b = 0;
			}

			return new Rectangle(l, t, r - l, b - t);
		}

		public static function resize(source:BitmapData, width:int, height:int):BitmapData {
			var target:BitmapData = new BitmapData(width, height, true, 0);
			var matrix:Matrix = new Matrix();

			matrix.scale(source.width / width, source.height / height);
			target.draw(source, matrix, null, null, null, true);

			return target;
		}
	}
}
