package org.shypl.common.assets {
	import flash.utils.ByteArray;

	public interface BytesAsset extends Asset {
		function get bytes():ByteArray;
	}
}
