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
			const argsLen:int = args.length;
			var p:int = 0;
			var a:int = 0;
			while (a < argsLen) {
				p = message.indexOf("{", p);
				if (p === -1) {
					break;
				}
				if (message.charAt(p + 1) === "}") {
					var arg:Object = args[a++];
					var argString:String = StringUtils.toString(arg);
					message = StringUtils.insert(message, argString, p, 2);
					p += argString.length;
				}
				else {
					++p;
				}
			}
			if (a === argsLen - 1 && args[a] is Error) {
				var error:Error = args[a];
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
