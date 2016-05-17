package org.shypl.common.app {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import org.shypl.common.lang.UncaughtErrorDelegate;
	import org.shypl.common.util.progress.Progress;

	[Abstract]
	public class AbstractMain extends Sprite {
		public function AbstractMain() {
			if (loaderInfo.loader == null) {
				if (stage == null) {
					addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				}
				else {
					main();
				}
			}
		}

		public function run(parameters:Object, stage:Stage):Progress {
			return new MainPreloader(parameters, stage);
		}

		protected function defineStageAlign():String {
			return StageAlign.TOP_LEFT;
		}

		protected function defineStageScaleMode():String {
			return StageScaleMode.NO_SCALE;
		}

		//noinspection JSUnusedLocalSymbols
		protected function createPreloaderScreen(parameters:Object):AbstractPreloaderScreen {
			return new SimplePreloaderScreen();
		}

		private function main():void {
			UncaughtErrorDelegate.register(loaderInfo.uncaughtErrorEvents);

			var stage:Stage = this.stage;
			stage.removeChild(this);
			stage.scaleMode = defineStageScaleMode();
			stage.align = defineStageAlign();

			var parameters:Object = loaderInfo.parameters;

			new Preloader(stage, createPreloaderScreen(parameters), run(parameters, stage));
		}

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			main();
		}
	}
}
