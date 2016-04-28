package org.shypl.common.app {
	import flash.display.Sprite;
	import flash.display.Stage;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.AbstractProgress;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.progress.ProgressCompleteNotice;
	import org.shypl.common.util.progress.UnevenCompositeProgress;

	public class MainPreloader extends AbstractProgress implements Progress, SwfReceiver {
		private var _parameters:Object;
		private var _stage:Stage;
		private var _progresses:CompositeProgress;

		public function MainPreloader(parameters:Object, stage:Stage) {
			_parameters = parameters;
			_stage = stage;

			_progresses = UnevenCompositeProgress.factoryEmpty(new <int>[1, 9]);
			_progresses.setChild(0, FileLoader.loadSwf(_parameters["main"], this));
			_progresses.addNoticeHandler(ProgressCompleteNotice, onProgressesComplete, false);
		}

		public function receiveSwf(sprite:Sprite):void {
			var main:AbstractMain = AbstractMain(sprite);
			var progress:Progress = main.run(_parameters, _stage);

			_progresses.setChild(1, progress);

			_parameters = null;
			_stage = null;
		}

		override protected function calculatePercent():Number {
			return _progresses.percent;
		}

		private function onProgressesComplete():void {
			complete();
			_progresses = null;
		}
	}
}
