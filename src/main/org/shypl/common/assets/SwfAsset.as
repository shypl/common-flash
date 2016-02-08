package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;

	public interface SwfAsset extends Asset {
		function get sprite():Sprite;

		function get domain():ApplicationDomain;

		function setObjectResolver(factory:SwfAssetObjectResolver):void;

		function getObject(name:String, type:String = null):Object;

		function getBitmapData(name:String):BitmapData;

		function getMovieClip(name:String):MovieClip;

		function getSprite(name:String):Sprite;

		function getTextField(name:String, text:String = null):TextField;
	}
}
