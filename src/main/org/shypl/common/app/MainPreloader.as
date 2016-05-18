package org.shypl.common.app {
	import flash.display.Stage;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfFile;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.AbstractProgress;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;
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
			_progresses.handleComplete(complete, true);
		}

		public function receiveSwf(swf:SwfFile):void {
			var main:AbstractMain = AbstractMain(swf.content);
			var progress:Progress = main.run(_parameters, _stage);

			_progresses.setChild(1, progress);

			_parameters = null;
			_stage = null;
		}

		override protected function calculatePercent():Number {
			return _progresses.percent;
		}

		override protected function complete():void {
			_progresses = null;
			super.complete();
		}
	}
}
