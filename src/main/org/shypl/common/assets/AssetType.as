package org.shypl.common.assets {
	import org.shypl.common.lang.Enum;

	public final class AssetType extends Enum {
		public static const BYTES:AssetType = new AssetType("BYTES");
		public static const TEXT:AssetType = new AssetType("TEXT");
		public static const XML:AssetType = new AssetType("XML");
		public static const IMAGE:AssetType = new AssetType("IMAGE");
		public static const ATLAS:AssetType = new AssetType("ATLAS");
		public static const SOUND:AssetType = new AssetType("SOUND");
		public static const SWF:AssetType = new AssetType("SWF");
		public static const FONT:AssetType = new AssetType("FONT");

		public function AssetType(name:String) {
			super(name);
		}
	}
}
