package org.shypl.common.util {
	public interface Lock {
		function get locked():Boolean;

		function lock():void;

		function unlock():void;
	}
}
