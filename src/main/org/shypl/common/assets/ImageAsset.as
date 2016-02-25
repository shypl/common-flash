package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface ImageAsset extends Asset {
		function get bitmapData():BitmapData;

		function getRectangle(rect:Rectangle):BitmapData;

		function copyRectangle(rect:Rectangle, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void;

		function createBitmap(rect:Rectangle = null):Bitmap;
	}
}
