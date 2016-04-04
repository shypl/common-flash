package org.shypl.common.loader {
	import flash.events.ErrorEvent;
	import flash.events.Event;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.ErrorEventException;
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.progress.Progress;

	[Abstract]
	internal class AbstractLoader implements Progress {
		private var _url:String;
		private var _running:Boolean;
		private var _completed:Boolean;
		private var _attempt:int;
		private var _error:Boolean;

		function AbstractLoader(url:String) {
			_url = url;
		}

		public final function get completed():Boolean {
			return _completed;
		}

		public final function get percent():Number {
			if (_completed) {
				return 1;
			}
			if (_error) {
				return 0;
			}
			if (_running) {
				return getPercent();
			}
			return 0;
		}

		internal final function get url():String {
			return _url;
		}

		[Abstract]
		protected function getPercent():Number {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function start():void {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function complete():void {
			throw new AbstractMethodException();
		}

		[Abstract]
		protected function free():void {
			throw new AbstractMethodException();
		}

		protected final function onComplete(event:Event):void {
			_running = false;
			complete();
			free();
			_completed = true;
			FileLoader.LOGGER.trace("Loaded {}", url);
			FileLoader.handleLoadComplete();
		}

		protected final function onError(event:ErrorEvent):void {
			free();
			_error = true;
			if (_attempt == 3) {
				FileLoader.LOGGER.error("Unable to load {}", url);
				throw new ErrorEventException(event, "Error on load file " + _url);
			}
			else {
				_running = false;
				GlobalTimeline.schedule(1000, startAttempt);
			}
		}

		internal final function start0():void {
			if (_running || _completed) {
				throw new IllegalStateException();
			}
			FileLoader.LOGGER.trace("Load {}", url);
			startAttempt();
		}

		private function startAttempt():void {
			++_attempt;
			_running = true;
			start();
		}
	}
}
