package org.shypl.common.sound {
	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	internal class AbstractSoundStream implements SoundStream {
		private var _system:SoundSystem;
		private var _volume:Number;
		private var _volumeChanger:VolumeChanger;
		private var _paused:Boolean;

		public function AbstractSoundStream(system:SoundSystem, volume:Number) {
			_system = system;
			_volume = volume;
			if (_system !== null) {
				_system.addStream(this);
			}
		}

		public final function get volume():Number {
			return _volume;
		}

		public final function set volume(value:Number):void {
			changeVolume(value, 0);
		}

		public function get realVolume():Number {
			return _volume * _system.realVolume;
		}

		protected final function get system():SoundSystem {
			return _system;
		}

		internal function get paused():Boolean {
			return _paused;
		}

		public function changeVolume(value:Number, duration:int):void {
			if (value > 1) {
				value = 1;
			}
			else if (value < 0) {
				value = 0;
			}

			if (duration < 0) {
				duration = 0;
			}

			stopVolumeChanger();

			if (value == _volume) {
				return;
			}

			if (duration == 0) {
				setVolume(value);
			}
			else {
				_volumeChanger = new VolumeChanger(this, value, duration);
			}
		}

		public final function stopVolumeChanger():void {
			if (_volumeChanger !== null) {
				_volumeChanger.stop();
				removeVolumeChanger();
			}
		}

		internal final function removeVolumeChanger():void {
			_volumeChanger = null;
		}

		[Abstract]
		public function stop(fadeDuration:int = 0):void {
			throw new AbstractMethodException();
		}

		public final function pause():void {
			if (!_paused) {
				_paused = true;
				doPause();
			}
		}

		public final function resume():void {
			if (_paused) {
				_paused = false;
				doResume();
			}
		}

		protected function doPause():void {
			if (_volumeChanger !== null) {
				_volumeChanger.pause();
			}
		}

		protected function doResume():void {
			if (_volumeChanger !== null) {
				_volumeChanger.resume();
			}
		}

		protected function free():void {
			stopVolumeChanger();
			if (_system !== null) {
				_system.removeStream(this);
				_system = null;
			}
		}

		[Abstract]
		protected function applyVolume():void {
			throw new AbstractMethodException();
		}

		internal final function setVolume(value:Number):void {
			_volume = value;
			applyVolume();
		}
	}
}
