package org.shypl.common.logging {
	public class LoggerProxy implements Logger {
		private var _logger:Logger;

		public function LoggerProxy(logger:Logger) {
			_logger = logger;
		}

		public function isFatalEnabled():Boolean {
			return _logger.isFatalEnabled();
		}

		public function isErrorEnabled():Boolean {
			return _logger.isErrorEnabled();
		}

		public function isWarnEnabled():Boolean {
			return _logger.isWarnEnabled();
		}

		public function isInfoEnabled():Boolean {
			return _logger.isInfoEnabled();
		}

		public function isDebugEnabled():Boolean {
			return _logger.isDebugEnabled();
		}

		public function isTraceEnabled():Boolean {
			return _logger.isTraceEnabled();
		}

		public function isEnabled(level:Level):Boolean {
			return _logger.isEnabled(level);
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
			_logger.log(level, message, args);
		}
	}
}
