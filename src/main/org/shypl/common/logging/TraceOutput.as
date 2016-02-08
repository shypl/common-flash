package org.shypl.common.logging {
	public class TraceOutput extends TimedFormattedOutput {
		override protected function writeRecord(record:String):void {
			trace(record);
		}
	}
}
