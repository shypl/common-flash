package org.shypl.common.util {
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	public final class SystemInfo {
		public static function define():SystemInfo {
			return new SystemInfo(
				Capabilities.os,
				defineBrowser(),
				Capabilities.playerType,
				Capabilities.version,
				defineScreenResolution()
			);
		}
		
		private static function defineBrowser():String {
			if (ExternalInterface.available) {
				try {
					return ExternalInterface.call("window.navigator.userAgent.toString");
				}
				catch (ignored:Error) {
				}
			}
			return "NA";
		}
		
		private static function defineScreenResolution():String {
			return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}
		
		private var _os:String;
		private var _browser:String;
		private var _playerType:String;
		private var _playerVersion:String;
		private var _screenResolution:String;
		
		public function SystemInfo(os:String, browser:String, playerType:String, playerVersion:String, screenResolution:String) {
			_os = os;
			_browser = browser;
			_playerType = playerType;
			_playerVersion = playerVersion;
			_screenResolution = screenResolution;
		}
		
		public function get os():String {
			return _os;
		}
		
		public function get browser():String {
			return _browser;
		}
		
		public function get playerType():String {
			return _playerType;
		}
		
		public function get playerVersion():String {
			return _playerVersion;
		}
		
		public function get screenResolution():String {
			return _screenResolution;
		}
		
		public function toObject():Object {
			return {
				os: _os,
				browser: _browser,
				player_type: _playerType,
				player_version: _playerVersion,
				screen_resolution: _screenResolution
			}
		}
		
		public function toString():String {
			return "os: " + _os + ", "
				+ "browser: " + _browser + ", "
				+ "player_type: " + _playerType + ", "
				+ "player_version: " + _playerVersion + ", "
				+ "screen_resolution: " + _screenResolution;
		}
	}
}
