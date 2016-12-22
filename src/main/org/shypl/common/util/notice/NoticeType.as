package org.shypl.common.util.notice {
	import flash.utils.getQualifiedClassName;
	
	import org.shypl.common.lang.newInstance;
	
	public class NoticeType {
		private var _owner:Class;
		private var _name:String;
		
		public function NoticeType(owner:Class, name:String) {
			_owner = owner;
			_name = getQualifiedClassName(_owner) + "-" + name;
		}
		
		public final function get name():String {
			return _name;
		}
		
		public final function createNotice(...arguments):TypedNotice {
			return newInstance(_owner, arguments);
		}
		
		public function toString():String {
			return name;
		}
	}
}
