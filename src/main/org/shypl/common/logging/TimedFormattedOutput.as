package org.shypl.common.logging {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.StringUtils;
	
	[Abstract]
	public class TimedFormattedOutput implements Output {
		public function write(record:Record):void {
			writeString(record, createString(record));
		}
		
		[Abstract]
		protected function writeString(record:Record, string:String):void {
			throw new AbstractMethodException();
		}
		
		protected function createString(record:Record):String {
			return formatString(record, formatTime(record), formatLevel(record), formatLogger(record), formatMessage(record));
		}
		
		protected function formatTime(record:Record):String {
			var ms:int = record.time;
			
			var h:int = ms / 3600000;
			ms -= h * 3600000;
			var m:int = ms / 60000;
			ms -= m * 60000;
			var s:int = ms / 1000;
			ms -= s * 1000;
			
			return StringUtils.padLeft(h.toString(), "0", 2)
				+ ":" + StringUtils.padLeft(m.toString(), "0", 2)
				+ ":" + StringUtils.padLeft(s.toString(), "0", 2)
				+ "." + StringUtils.padLeft(ms.toString(), "0", 3);
		}
		
		protected function formatLevel(record:Record):String {
			return StringUtils.padRight(record.level.name, " ", 5);
		}
		
		protected function formatLogger(record:Record):String {
			return record.logger;
		}
		
		protected function formatMessage(record:Record):String {
			return record.message;
		}
		
		protected function formatString(record:Record, time:String, level:String, logger:String, message:String):String {
			return "[" + time + " " + level + "] " + logger + ": " + message;
		}
	}
}
