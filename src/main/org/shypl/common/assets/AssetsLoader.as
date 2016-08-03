package org.shypl.common.assets {
	import org.shypl.common.util.progress.AbstractProgress;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;
	
	internal class AssetsLoader extends AbstractProgress implements Progress {
		private var _receiver:AssetsReceiver;
		private var _collection:AssetsCollectionImpl;
		private var _loading:Progress;
		private var _deferred:Vector.<Asset> = new Vector.<Asset>();
		
		public function AssetsLoader(items:Object, receiver:AssetsReceiver) {
			_receiver = receiver;
			
			var map:Object = {};
			var progresses:Vector.<Progress> = new Vector.<Progress>();
			
			for each (var item:AssetsCollectionItem in items) {
				map[item.name] = item.asset;
				if (item.deferred) {
					_deferred.push(item.asset);
				}
				else {
					progresses.push(item.asset.load());
				}
			}
			
			_collection = new AssetsCollectionImpl(map);
			_loading = new CompositeProgress(progresses);
			
			_loading.handleComplete(complete, true);
		}
		
		override protected function calculatePercent():Number {
			return _loading.percent;
		}
		
		override protected function complete():void {
			if (_receiver != null) {
				_receiver.receiveAssets(_collection);
				_receiver = null;
			}
			_collection = null;
			_loading = null;
			
			super.complete();
			
			for each (var asset:Asset in _deferred) {
				asset.load();
			}
			_deferred.length = 0;
			_deferred = null;
		}
	}
}
