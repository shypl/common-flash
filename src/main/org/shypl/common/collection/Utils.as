package org.shypl.common.collection {
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	internal final class Utils {
		public static function extractFlashProxyName(name:*):String {
			return name is QName ? QName(name).localName : name.toString();
		}
	}
}
