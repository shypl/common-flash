package org.shypl.common.logging {
	import org.shypl.common.lang.Enum;

	public final class Level extends Enum {
		public static const FATAL:Level = new Level("FATAL");
		public static const ERROR:Level = new Level("ERROR");
		public static const WARN:Level = new Level("WARN");
		public static const INFO:Level = new Level("INFO");
		public static const DEBUG:Level = new Level("DEBUG");
		public static const TRACE:Level = new Level("TRACE");

		public function Level(name:String) {
			super(name);
		}

		public function isAllow(level:Level):Boolean {
			return ordinal >= level.ordinal;
		}
	}
}
