package org.shypl.common.app {
	import flash.display.Sprite;
	import flash.display.Stage;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;
	import org.shypl.common.util.progress.UnevenCompositeProgress;

	public class MainPreloader implements Progress, SwfReceiver {
		private var _parameters:Object;
		private var _stage:Stage;
		private var _progresses:CompositeProgress;

		public function MainPreloader(parameters:Object, stage:Stage) {
			_parameters = parameters;
			_stage = stage;

			_progresses = UnevenCompositeProgress.factoryEmpty(new <int>[1, 9]);
			_progresses.setProgressAt(0, FileLoader.loadSwf(_parameters["main"], this));
		}

		public function get completed():Boolean {
			return _progresses.completed;
		}

		public function get percent():Number {
			return _progresses.percent;
		}

		public function receiveSwf(sprite:Sprite):void {
			var main:AbstractMain = AbstractMain(sprite);
			var progress:Progress = main.run(_parameters, _stage);

			_progresses.setProgressAt(1, progress);

			_parameters = null;
			_stage = null;
			_progresses = null;
		}
	}
}
