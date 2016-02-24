package org.shypl.common.util {

	public interface Path {
		function get empty():Boolean;

		function get parent():Path;

		function get value():String;

		function resolve(path:String):Path;

		function resolveSibling(path:String):Path;
	}
}
