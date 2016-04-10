package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;

	public interface SwfAsset extends Asset {
		function get domain():ApplicationDomain;

		function get sprite():Sprite;

		function get movieClip():MovieClip;

		function hasClass(className:String):Boolean;

		function create(className:String):Object;

		function createSprite(className:String):Sprite;

		function createMovieClip(className:String):MovieClip;

		function createBitmapData(className:String):BitmapData;

		function createSound(className:String):Sound;
	}
}
