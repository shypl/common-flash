package org.shypl.common.assets {
	import org.shypl.common.util.notice.Notice;

	public class AssetLoadedNotice implements Notice {
		private var _asset:Asset;

		public function AssetLoadedNotice(asset:Asset) {
			_asset = asset;
		}

		public function get asset():Asset {
			return _asset;
		}
	}
}
