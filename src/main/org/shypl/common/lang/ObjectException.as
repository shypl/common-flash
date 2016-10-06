package org.shypl.common.lang {
	import flash.utils.getQualifiedClassName;
	
	import org.shypl.common.util.StringUtils;
	
	public class ObjectException extends RuntimeException {
		private var _object:Object;
		
		public function ObjectException(object:Object, message:String = null) {
			super(message === null ? getQualifiedClassName(object) : message);
			_object = object;
		}
		
		public function get object():Object {
			return _object;
		}
		
		override public function getStackTrace():String {
			return super.getStackTrace()
				+ "\nCaused by: " + getQualifiedClassName(_object)
				+ "\n  info: " + StringUtils.toString(object);
		}
	}
}
