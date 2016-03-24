package org.shypl.common.net {
	public class InetSocketAddress {
		private var _host:String;
		private var _port:int;

		public function InetSocketAddress(host:String, port:int) {
			_host = host;
			_port = port;
		}

		public function get host():String {
			return _host;
		}

		public function get port():int {
			return _port;
		}

		public function toString():String {
			return _host + ":" + _port;
		}
	}
}
