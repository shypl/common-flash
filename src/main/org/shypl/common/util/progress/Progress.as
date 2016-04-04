package org.shypl.common.util.progress {
	public interface Progress {
		function get completed():Boolean;

		function get percent():Number;
	}
}
