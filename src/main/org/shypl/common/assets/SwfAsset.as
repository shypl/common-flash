package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	
	import org.shypl.common.loader.SwfFile;
	import org.shypl.common.util.FilePath;
	import org.shypl.common.util.progress.Progress;
	
	public class SwfAsset extends Asset {
		private var _swf:SwfFile;
		private var _domain:ApplicationDomain;
		
		public function SwfAsset(path:FilePath, domain:ApplicationDomain = null) {
			super(path);
			_domain = domain === null ? (new ApplicationDomain(ApplicationDomain.currentDomain)) : domain;
		}
		
		public function get swf():SwfFile {
			checkAvailable();
			return _swf;
		}
		
		public function get domain():ApplicationDomain {
			return _domain;
		}
		
		public function createSprite(className:String):Sprite {
			checkAvailable();
			return _swf.create(className);
		}
		
		public function createMovieClip(className:String):MovieClip {
			checkAvailable();
			return _swf.create(className);
		}
		
		public function createBitmapData(className:String):BitmapData {
			checkAvailable();
			return _swf.create(className);
		}
		
		public function createSound(className:String):Sound {
			checkAvailable();
			return _swf.create(className);
		}
		
		override protected function doLoad():Progress {
			return new SwfAssetLoader(this);
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			_swf = null;
			_domain = null;
		}
		
		internal function receiveData(swf:SwfFile):void {
			_swf = swf;
			completeLoad();
		}
	}
}
