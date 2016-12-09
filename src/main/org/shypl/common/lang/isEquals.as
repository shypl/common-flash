package org.shypl.common.lang {
	public function isEquals(a:Object, b:Object):Boolean {
		if (a === b) {
			return true;
		}
		if (a is Equally && b is Equally) {
			return Equally(a).equals(b);
		}
		return false;
	}
}
