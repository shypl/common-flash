package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.Path;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.StaticPoint0;

	internal class AtlasAssetImpl extends AbstractAsset implements AtlasAsset {
		private var _areas:Object = {};
		private var _cache:Object = {};
		private var _atlas:BitmapData;
		private var _dir:Path;

		function AtlasAssetImpl(name:String, path:String, deferred:Boolean, dir:Path) {
			super(name, path, deferred);
			_dir = dir;
		}

		override public function load():Progress {
			return new AtlasLoader(this, _dir);
		}

		public function contains(name:String):Boolean {
			return name in _areas;
		}

		public function getBitmapData(name:String):BitmapData {
			var bitmapData:BitmapData = _cache[name];
			if (bitmapData === null) {
				var area:Rectangle = getArea(name);
				if (area.x == 0 && area.y == 0 && area.width == _areas.width && area.height == _areas.high) {
					bitmapData = _atlas;
				}
				else {
					bitmapData = new BitmapData(area.width, area.height);
					bitmapData.copyPixels(_atlas, area, StaticPoint0.INSTANCE);
				}
				_cache[name] = bitmapData;
			}
			return bitmapData;
		}

		public function copyBitmapData(name:String, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void {
			target.copyPixels(_atlas, getArea(name), targetPoint, null, null, mergeAlpha);
		}

		public function createBitmap(name:String):Bitmap {
			return new Bitmap(getBitmapData(name), PixelSnapping.AUTO, true);
		}

		override protected function doFree():void {
			if (_atlas) {
				for each (var bitmapData:BitmapData in _cache) {
					bitmapData.dispose();
				}
				_atlas.dispose();
				_areas = null;
				_atlas = null;
				_cache = null;
			}
		}

		internal function complete(xml:XML, image:BitmapData):void {
			_atlas = image;
			for each (var subTexture:XML in xml.SubTexture) {
				_areas[subTexture.attribute("name").toString()] = new Rectangle(
					parseInt(subTexture.attribute("x")),
					parseInt(subTexture.attribute("y")),
					parseInt(subTexture.attribute("width")),
					parseInt(subTexture.attribute("height"))
				);
			}
			System.disposeXML(xml);
			completeLoad();
			_dir = null;
		}

		private function getArea(name:String):Rectangle {
			if (!contains(name)) {
				throw new IllegalArgumentException("This Atlas does not contains area with name " + name);
			}
			return _areas[name];
		}
	}
}
