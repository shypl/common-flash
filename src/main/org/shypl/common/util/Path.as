package org.shypl.common.util {
	public interface Path {
		function get parent():Path;

		function get isEmpty():Boolean;

		function resolve(path:String):Path;

		function resolveSibling(path:String):Path;

		function toString():String;
	}
}
