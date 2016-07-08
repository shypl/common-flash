package org.shypl.common.lang {
	public final class Objects {
		public static function isNull(obj:Object):Boolean {
			return obj === null;
		}
		
		public static function notNull(obj:Object):Boolean {
			return obj !== null;
		}

		public static function requireNotNull(obj:Object, message:String = null):void {
			if (obj == null) {
				throw new NullPointerException(message);
			}
		}
	}
}
