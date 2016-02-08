package org.shypl.common.logging {
	public interface Output {
		function write(level:Level, logger:String, message:String):void;
	}
}
