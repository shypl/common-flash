package org.shypl.common.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.StaticPoint0;
	import org.shypl.common.util.progress.Progress;
	
	public class AtlasAsset extends Asset {
		private var _atlas:BitmapData;
		private var _areas:Object = {};
		private var _cache:Object = {};
		
		function AtlasAsset(path:FilePath) {
			super(path);
		}
		
		public function contains(name:String):Boolean {
			checkAvailable();
			return name in _areas;
		}
		
		public function getBitmapData(name:String):BitmapData {
			checkAvailable();
			var bitmapData:BitmapData = _cache[name];
			if (bitmapData === null) {
				bitmapData = createBitmapData(getArea(name));
				_cache[name] = bitmapData;
			}
			return bitmapData;
		}
		
		public function copyBitmapData(name:String, target:BitmapData, targetPoint:Point, mergeAlpha:Boolean = false):void {
			checkAvailable();
			target.copyPixels(_atlas, getArea(name), targetPoint, null, null, mergeAlpha);
		}
		
		public function createBitmap(name:String):Bitmap {
			checkAvailable();
			return new Bitmap(getBitmapData(name), PixelSnapping.AUTO, true);
		}
		
		override protected function doLoad():Progress {
			return new AtlasAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
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
		
		internal function receiveData(xml:XML, image:BitmapData):void {
			_atlas = image;
			for each (var subTexture:XML in xml.SubTexture) {
				_areas[subTexture.attribute("name").toString()] = new Rectangle(
					parseInt(subTexture.attribute("x")),
					parseInt(subTexture.attribute("y")),
					parseInt(subTexture.attribute("width")),
					parseInt(subTexture.attribute("height"))
				);
			}
			completeLoad();
		}
		
		private function getArea(name:String):Rectangle {
			if (!contains(name)) {
				throw new IllegalArgumentException("This Atlas does not contains area with name " + name);
			}
			return _areas[name];
		}
		
		private function createBitmapData(area:Rectangle):BitmapData {
			var bitmapData:BitmapData;
			
			if (area.x == 0 && area.y == 0 && area.width == _areas.width && area.height == _areas.high) {
				bitmapData = _atlas;
			}
			else {
				bitmapData = new BitmapData(area.width, area.height);
				bitmapData.copyPixels(_atlas, area, StaticPoint0.INSTANCE);
			}
			
			return bitmapData;
		}
	}
}
