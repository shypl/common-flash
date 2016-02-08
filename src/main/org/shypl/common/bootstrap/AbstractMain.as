package org.shypl.common.bootstrap {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.UncaughtErrorDelegate;

	[Abstract]
	public class AbstractMain extends Sprite {
		public function AbstractMain() {
			if (loaderInfo.loader == null) {
				if (stage == null) {
					addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				}
				else {
					initRun();
				}
			}
		}

		protected function get stageAlign():String {
			return StageAlign.TOP_LEFT;
		}

		protected function get stageScaleMode():String {
			return StageScaleMode.NO_SCALE;
		}

		public function run(flashVars:Object, stage:Stage):PreloaderPhase {
			return new LoadMainFilePhase();
		}

		[Abstract]
		protected function getPreloaderScreen():AbstractPreloaderScreen {
			throw new AbstractMethodException();
		}

		private function initRun():void {
			UncaughtErrorDelegate.register(loaderInfo.uncaughtErrorEvents);

			var stage:Stage = this.stage;
			stage.removeChild(this);
			stage.scaleMode = stageScaleMode;
			stage.align = stageAlign;

			var flashVars:Object = loaderInfo.parameters;

			new Preloader(flashVars, stage, getPreloaderScreen(), run(flashVars, stage));
		}

		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initRun();
		}
	}
}
