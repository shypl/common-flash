package org.shypl.common.logging {
	import flash.utils.getTimer;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.StringUtils;

	[Abstract]
	public class TimedFormattedOutput implements Output {
		public function write(level:Level, logger:String, message:String):void {
			writeRecord(createRecord(getTimer(), level, logger, message));
		}

		[Abstract]
		protected function writeRecord(record:String):void {
			throw new AbstractMethodException();
		}

		protected function createRecord(time:int, level:Level, logger:String, message:String):String {
			return "[" + formatTime(time) + " " + formatLevel(level) + "] " + formatLogger(logger) + ": " + formatMessage(message);
		}

		protected function formatTime(ms:int):String {
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

		protected function formatLevel(level:Level):String {
			return StringUtils.padRight(level.name, " ", 5);
		}

		protected function formatLogger(logger:String):String {
			return logger;
		}

		protected function formatMessage(message:String):String {
			return message;
		}
	}
}
