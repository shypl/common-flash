package org.shypl.common.lang {
	public function requireNotNull(obj:Object, message:String = null):void {
		if (obj === null) {
			throw new NullPointerException(message);
		}
	}
}
