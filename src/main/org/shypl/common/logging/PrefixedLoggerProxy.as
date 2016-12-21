package org.shypl.common.logging {
	public class PrefixedLoggerProxy extends LoggerProxy {
		private var _prefix:String;
		
		public function PrefixedLoggerProxy(logger:Logger, prefix:String) {
			super(logger);
			_prefix = prefix;
		}
		
		override public function log(level:Level, message:String, args:Array):void {
			if (isEnabled(level)) {
				super.log(level, _prefix + message, args);
			}
		}
	}
}
