package org.shypl.common.loader {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	internal class SoundLoader extends AbstractLoader {
		private var _receiver:SoundReceiver;
		private var _sound:Sound;

		public function SoundLoader(url:String, receiver:SoundReceiver) {
			super(url);
			_receiver = receiver;
		}

		override protected function getPercent():Number {
			if (_sound.bytesTotal == 0) {
				return 0;
			}
			return _sound.bytesLoaded / _sound.bytesTotal;
		}

		override protected function start():void {
			_sound = new Sound();
			_sound.addEventListener(Event.COMPLETE, onComplete);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound.load(new URLRequest(url));
		}

		override protected function complete():void {
			_receiver.receiveSound(_sound);
			_receiver = null;
		}

		override protected function free():void {
			_sound.removeEventListener(Event.COMPLETE, onComplete);
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound = null;
		}
	}
}
