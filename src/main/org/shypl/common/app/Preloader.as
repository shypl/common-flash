package org.shypl.common.app {
	import flash.display.Stage;
	import flash.events.Event;

	import org.shypl.common.util.progress.Progress;

	public class Preloader {
		private var _stage:Stage;
		private var _screen:AbstractPreloaderScreen;
		private var _progress:Progress;

		public function Preloader(stage:Stage, screen:AbstractPreloaderScreen, progress:Progress) {
			_stage = stage;
			_screen = screen;
			_progress = progress;

			_stage.addChild(_screen);
			_stage.addEventListener(Event.RESIZE, onStageResize);
			_stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);

			resize();
			update();
		}


		private function update():void {
			_screen.update(_progress.percent);
		}

		private function complete():void {
			_stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			_screen.hide(destroy);
		}

		private function destroy():void {
			_stage.removeChild(_screen);
			_stage.removeEventListener(Event.RESIZE, onStageResize);

			_stage = null;
			_screen = null;
			_progress = null;
		}

		private function resize():void {
			_screen.resize(_stage.stageWidth, _stage.stageHeight);
		}

		private function onStageResize(event:Event):void {
			resize();
		}

		private function onStageEnterFrame(event:Event):void {
			update();
			if (_progress.completed) {
				complete();
			}
		}
	}
}
