package org.shypl.common.logging {
	public class Record {
		private var _time:int;
		private var _level:Level;
		private var _logger:String;
		private var _message:String;
		
		public function Record(time:int, level:Level, logger:String, message:String) {
			_time = time;
			_level = level;
			_logger = logger;
			_message = message;
		}
		
		public function get time():int {
			return _time;
		}
		
		public function get level():Level {
			return _level;
		}
		
		public function get logger():String {
			return _logger;
		}
		
		public function get message():String {
			return _message;
		}
	}
}
