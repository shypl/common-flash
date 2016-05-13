package org.shypl.common.util {
	public interface FilePath {
		function get length():int;

		function get parent():FilePath;

		function get fileName():String;

		function get parts():Vector.<String>;

		function isEmpty():Boolean;

		function getPart(index:int):String;

		function resolve(path:String):FilePath;

		function resolvePath(path:FilePath):FilePath;

		function resolveSibling(path:String):FilePath;

		function resolveSiblingPath(path:FilePath):FilePath;

		function toString():String;

		function toUnixString():String;

		function toWindowsString():String;
	}
}
