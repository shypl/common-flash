package org.shypl.common.logging {
	public class TraceOutput extends TimedFormattedOutput {
		override protected function writeString(record:Record, string:String):void {
			trace(record);
		}
	}
}
