package org.shypl.common.loader {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.ErrorEventException;
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.progress.AbstractProgress;
	import org.shypl.common.util.progress.CancelableProgress;
	
	[Abstract]
	internal class AbstractLoader extends AbstractProgress implements CancelableProgress {
		private var _url:String;
		private var _loading:Boolean;
		private var _attempt:int;
		private var _failHandler:LoadingFailHandler;
		
		function AbstractLoader(url:String, failHandler:LoadingFailHandler) {
			_url = url;
			_failHandler = failHandler;
		}
		
		internal final function get url():String {
			return _url;
		}
		
		public final function cancel():void {
			cancelLoading();
			freeLoading();
			complete();
		}
		
		override final protected function calculatePercent():Number {
			if (_loading) {
				return getLoadingPercent();
			}
			return 0;
		}
		
		override final protected function complete():void {
			super.complete();
			FileLoader.handleLoadingComplete();
		}
		
		[Abstract]
		protected function startLoading():void {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function getLoadingPercent():Number {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function cancelLoading():void {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function freeLoading():void {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function produceResult():void {
			throw new AbstractMethodException();
		}
		
		protected final function handleLoadingCompleteEvent(event:Event):void {
			_loading = false;
			FileLoader.LOGGER.trace("Loaded {}", url);
			
			produceResult();
			freeLoading();
			complete();
		}
		
		protected final function handleLoadingErrorEvent(event:ErrorEvent):void {
			freeLoading();
			_loading = false;
			if (_attempt == 3) {
				FileLoader.LOGGER.warn("Unable to load {}", url);
				handleLoadingFail(event);
			}
			else {
				GlobalTimeline.schedule(1000, attemptLoading);
			}
		}
		
		internal final function run():void {
			if (_loading || completed) {
				throw new IllegalStateException();
			}
			FileLoader.LOGGER.trace("Load {}", url);
			attemptLoading();
		}
		
		private function attemptLoading():void {
			++_attempt;
			_loading = true;
			startLoading();
		}
		
		private function handleLoadingFail(event:ErrorEvent):void {
			if (_failHandler === null) {
				throw new ErrorEventException(event, "Error on load file " + _url);
			}
			else {
				_failHandler.handleLoadingFail(_url);
				complete();
			}
		}
	}
}
