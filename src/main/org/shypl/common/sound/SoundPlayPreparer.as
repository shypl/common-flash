package org.shypl.common.sound {
	import flash.media.Sound;

	public class SoundPlayPreparer {
		private var _system:SoundSystem;
		private var _sound:Sound;

		private var _volume:Number = 1;
		private var _loop:Boolean = false;
		private var _start:Number = 0;
		private var _end:Number = 0;
		private var _restart:Number = 0;
		private var _endHandler:Function = null;

		public function SoundPlayPreparer(system:SoundSystem, sound:Sound) {
			_system = system;
			_sound = sound;
		}

		public function play():SoundStream {
			return new SoundFlow(_system, _volume, _sound, _loop, _start, _end, _restart, _endHandler)
		}

		public function setVolume(value:Number):SoundPlayPreparer {
			_volume = value;
			return this;
		}

		public function setLoop(value:Boolean):SoundPlayPreparer {
			_loop = value;
			return this;
		}

		public function setStart(value:Number):SoundPlayPreparer {
			_start = value;
			return this;
		}

		public function setEnd(value:Number):SoundPlayPreparer {
			_end = value;
			return this;
		}

		public function setRestart(value:Number):SoundPlayPreparer {
			_restart = value;
			return this;
		}

		public function setEndHandler(value:Function):SoundPlayPreparer {
			_endHandler = value;
			return this;
		}
	}
}