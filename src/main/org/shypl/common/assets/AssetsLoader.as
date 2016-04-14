package org.shypl.common.assets {
	import org.shypl.common.util.callDelayed;
	import org.shypl.common.util.progress.AbstractProgress;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.progress.ProgressCompleteNotice;

	internal class AssetsLoader extends AbstractProgress implements Progress {
		private var _receiver:AssetsReceiver;
		private var _collection:AssetsCollectionImpl;
		private var _loading:Progress;
		private var _deferred:Vector.<AbstractAsset> = new Vector.<AbstractAsset>();

		public function AssetsLoader(map:Object, receiver:AssetsReceiver) {
			_receiver = receiver;
			_collection = new AssetsCollectionImpl(map);

			var progresses:Vector.<Progress> = new Vector.<Progress>();

			for each (var asset:AbstractAsset in map) {
				if (asset.deferred) {
					_deferred.push(asset);
				}
				else {
					progresses.push(asset.load());
				}
			}

			_loading = new CompositeProgress(progresses);


			if (_loading.completed) {
				callDelayed(complete);
			}
			else {
				_loading.addNoticeHandler(ProgressCompleteNotice, complete, false);
			}
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

			for each (var asset:AbstractAsset in _deferred) {
				asset.load();
			}
			_deferred = null;
		}
	}
}
