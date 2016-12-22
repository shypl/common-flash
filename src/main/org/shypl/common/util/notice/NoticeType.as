package org.shypl.common.util.notice {
	import flash.utils.getQualifiedClassName;
	
	public class NoticeType {
		private var _name:String;
		
		public function NoticeType(owner:Class, name:String) {
			_name = getQualifiedClassName(owner) + "-" + name;
		}
		
		public final function get name():String {
			return _name;
		}
		
		public function toString():String {
			return name;
		}
	}
}
