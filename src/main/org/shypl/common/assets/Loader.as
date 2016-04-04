package org.shypl.common.assets {
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.progress.Progress;

	internal class Loader implements Progress {
		private var _receiver:AssetsReceiver;
		private var _collection:AssetsCollectionImpl;
		private var _loadingProgresses:Vector.<Progress> = new Vector.<Progress>();
		private var _deferredAssets:Vector.<AbstractAsset> = new Vector.<AbstractAsset>();
		private var _competed:Boolean;
		private var _percent:Number = 0;
		private var _totalCount:uint;
		private var _frameTask:Cancelable;

		public function Loader(map:Object, receiver:AssetsReceiver) {
			_receiver = receiver;
			_collection = new AssetsCollectionImpl(map);

			for each (var asset:AbstractAsset in map) {
				if (asset.deferred) {
					_deferredAssets.push(asset);
				}
				else {
					_loadingProgresses.push(asset.load());
				}
			}
			_loadingProgresses.fixed = true;
			_deferredAssets.fixed = true;

			_totalCount = _loadingProgresses.length;

			if (_totalCount == 0) {
				GlobalTimeline.forNextFrame(complete);
			}
			else {
				_frameTask = GlobalTimeline.forEachFrame(onFrame);
			}
		}

		public function get completed():Boolean {
			return _competed;
		}

		public function get percent():Number {
			return _percent;
		}

		private function complete():void {
			_competed = true;
			_percent = 1;
			_receiver.receiveAssets(_collection);
			_receiver = null;
			_collection = null;

			if (_deferredAssets.length > 0) {
				for each (var asset:AbstractAsset in _deferredAssets) {
					asset.load();
				}
				_deferredAssets = null;
			}
		}

		private function onFrame():void {
			var percent:Number = 0;
			var competedCount:int = 0;

			for (var i:int = 0; i < _totalCount; i++) {
				var progress:Progress = _loadingProgresses[i];
				percent += progress.percent;
				if (progress.completed) {
					++competedCount;
				}
			}

			percent /= _totalCount;

			if (percent > _percent) {
				_percent = percent;
			}

			if (competedCount == _totalCount) {
				_frameTask.cancel();
				_frameTask = null;
				_loadingProgresses = null;
				complete();
			}
		}
	}
}
