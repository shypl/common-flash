package org.shypl.common.util.notice {
	public class TypedNotice implements Notice {
		private var _type:NoticeType;
		
		public function TypedNotice(type:NoticeType) {
			_type = type;
		}
		
		public function get type():NoticeType {
			return _type;
		}
		
		public function toString():String {
			return "[" + type.name + "]";
		}
	}
}
