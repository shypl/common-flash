package org.shypl.common.logging {
	import org.shypl.common.util.StringUtils;

	internal final class LoggerImpl implements Logger {
		private var _name:String;
		private var _level:Level;

		public function LoggerImpl(name:String, level:Level) {
			_name = name;
			_level = level;
		}

		public function isFatalEnabled():Boolean {
			return _level.isAllow(Level.FATAL);
		}

		public function isErrorEnabled():Boolean {
			return _level.isAllow(Level.ERROR);
		}

		public function isWarnEnabled():Boolean {
			return _level.isAllow(Level.WARN);
		}

		public function isInfoEnabled():Boolean {
			return _level.isAllow(Level.INFO);
		}

		public function isDebugEnabled():Boolean {
			return _level.isAllow(Level.DEBUG);
		}

		public function isTraceEnabled():Boolean {
			return _level.isAllow(Level.TRACE);
		}

		public function isEnabled(level:Level):Boolean {
			return _level.isAllow(level);
		}

		public function fatal(message:String, ...args):void {
			log(Level.FATAL, message, args);
		}

		public function error(message:String, ...args):void {
			log(Level.ERROR, message, args);
		}

		public function warn(message:String, ...args):void {
			log(Level.WARN, message, args);
		}

		public function info(message:String, ...args):void {
			log(Level.INFO, message, args);
		}

		public function debug(message:String, ...args):void {
			log(Level.DEBUG, message, args);
		}

		public function trace(message:String, ...args):void {
			log(Level.TRACE, message, args);
		}

		public function log(level:Level, message:String, args:Array):void {
			if (_level.isAllow(level)) {
				LogManager.log(level, _name, prepareMessage(message, args));
			}
		}

		internal function setLevel(level:Level):void {
			_level = level;
		}

		private function prepareMessage(message:String, args:Array):String {
			var l:int = args.length - 1;
			var e:Boolean = l >= 0 && args[l] is Error && StringUtils.count(message, "{}") == l;

			message = StringUtils.formatByArray(message, args);

			if (e) {
				var error:Error = args[l];
				var stackTrace:String = error.getStackTrace();
				if (stackTrace === null || stackTrace.length === 0 || stackTrace === "null") {
					stackTrace = error.toString();
				}
				message += "\n" + stackTrace;
			}

			return message;
		}
	}
}
