package org.shypl.common.app {
	import flash.display.Stage;
	import flash.events.Event;

	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.logging.LogManager;
	import org.shypl.common.logging.Logger;

	public class Preloader {
		private var _logger:Logger = LogManager.getLoggerByClass(Preloader);
		private var _flashVars:Object;
		private var _stage:Stage;
		private var _screen:AbstractPreloaderScreen;
		private var _currentPhase:PreloaderPhase;
		private var _currentPhaseNeedStart:Boolean;
		private var _currentPhaseTotalProgressDelta:Number = 0;
		private var _prevPhaseTotalProgress:Number = 0;

		public function Preloader(flashVars:Object, stage:Stage, screen:AbstractPreloaderScreen, firstPhase:PreloaderPhase) {
			_flashVars = flashVars;
			_stage = stage;
			_screen = screen;

			_stage.addChild(_screen);
			_stage.addEventListener(Event.RESIZE, onResize);

			_screen.show();
			resizeScreen();

			_screen.updateTotalProgress(0);
			_screen.updatePhaseProgress(0);

			startPhase(firstPhase);
		}

		private function startPhase(phase:PreloaderPhase):void {
			if (_currentPhase != null && _currentPhase.totalFinalProgress <= phase.totalFinalProgress) {
				throw new IllegalStateException("Phase totalFinalProgress value less or equal previous phase");
			}

			_currentPhaseNeedStart = true;
			_currentPhase = phase;
			_currentPhase.init(_flashVars, _stage);
			_currentPhaseTotalProgressDelta = _currentPhase.totalFinalProgress - _prevPhaseTotalProgress;

			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_screen.updatePhaseName(_currentPhase.name);
		}

		private function updateProgress():void {
			var phaseProgress:Number = _currentPhase.percent;

			var total:Number = _prevPhaseTotalProgress + _currentPhaseTotalProgressDelta * phaseProgress;
			_screen.updateTotalProgress(total);
			_screen.updatePhaseProgress(phaseProgress);
		}

		private function finishPhase():void {
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_prevPhaseTotalProgress = _currentPhase.totalFinalProgress;

			var phase:PreloaderPhase = _currentPhase;
			_currentPhase = null;

			var nextPhase:PreloaderPhase = phase.finish();

			if (_prevPhaseTotalProgress == 1) {
				if (nextPhase != null) {
					throw new IllegalStateException("Total progress is complete, but there is a next phase");
				}
				finishTotal();
			}
			else if (nextPhase == null) {
				throw new IllegalStateException("Total progress is not complete, but there is no next phase");
			}
			else {
				startPhase(nextPhase);
			}
		}

		private function finishTotal():void {
			_screen.hide(destroy);
		}

		private function destroy():void {
			_stage.removeChild(_screen);
			_stage.removeEventListener(Event.RESIZE, onResize);

			_flashVars = null;
			_stage = null;
			_screen = null;
		}

		private function resizeScreen():void {
			_screen.resize(_stage.stageWidth, _stage.stageHeight);
		}

		private function onResize(event:Event):void {
			resizeScreen();
		}

		private function onEnterFrame(event:Event):void {
			if (_currentPhaseNeedStart) {
				_currentPhaseNeedStart = false;
				_logger.trace("Start phase: {}", _currentPhase.name);
				_currentPhase.start();
			}

			updateProgress();
			if (_currentPhase.completed) {
				_logger.trace("Finish phase: {}", _currentPhase.name);
				finishPhase();
			}
		}
	}
}
