package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;

	public interface AtlasAsset extends Asset {
		function contains(name:String):Boolean;

		function getBitmapData(name:String):BitmapData;

		function copyBitmapData(name:String, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void;

		function createBitmap(name:String):Bitmap;
	}
}
