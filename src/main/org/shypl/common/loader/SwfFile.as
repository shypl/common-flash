package org.shypl.common.loader {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public interface SwfFile {
		function get content():Sprite;

		function get width():int;

		function get height():int;

		function get domain():ApplicationDomain;

		function hasClass(className:String):Boolean;

		function create(className:String):Object;

		function cloneContent():Sprite;
	}
}
