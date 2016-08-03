package org.shypl.common.assets {
	internal class AssetsCollectionItem {
		private var _name:String;
		private var _asset:Asset;
		private var _deferred:Boolean;
		
		public function AssetsCollectionItem(name:String, asset:Asset, deferred:Boolean) {
			_name = name;
			_asset = asset;
			_deferred = deferred;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get deferred():Boolean {
			return _deferred;
		}
		
		public function set deferred(deferred:Boolean):void {
			if (_deferred == false) {
				_deferred = deferred;
			}
		}
		
		internal function get asset():Asset {
			return _asset;
		}
	}
}
