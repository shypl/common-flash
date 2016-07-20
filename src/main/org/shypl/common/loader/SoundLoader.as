package org.shypl.common.loader {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	internal class SoundLoader extends AbstractLoader {
		private var _receiver:SoundReceiver;
		private var _sound:Sound;
		
		public function SoundLoader(url:String, receiver:SoundReceiver, failHandler:LoadingFailHandler) {
			super(url, failHandler);
			_receiver = receiver;
		}
		
		override protected function cancelLoading():void {
			_sound.close();
		}
		
		override protected function getLoadingPercent():Number {
			if (_sound.bytesTotal == 0) {
				return 0;
			}
			return _sound.bytesLoaded / _sound.bytesTotal;
		}
		
		override protected function startLoading():void {
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_sound.load(new URLRequest(url));
		}
		
		override protected function produceResult():void {
			_receiver.receiveSound(_sound);
			_receiver = null;
		}
		
		override protected function freeLoading():void {
			_sound.removeEventListener(Event.COMPLETE, handleLoadingCompleteEvent);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleLoadingErrorEvent);
			_sound = null;
		}
	}
}
