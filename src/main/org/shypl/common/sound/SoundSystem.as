package org.shypl.common.sound {
	import flash.media.Sound;

	import org.shypl.common.collection.HashSet;
	import org.shypl.common.collection.Set;

	public final class SoundSystem extends AbstractSoundStream {
		private var _streams:Set = new HashSet();

		public function SoundSystem(volume:Number = 1, system:SoundSystem = null) {
			super(system, volume);
			if (hasParent() && system.paused) {
				pause();
			}
		}

		private function hasParent():Boolean {
			return system !== null;
		}

		override public function get realVolume():Number {
			return hasParent() ? super.realVolume : volume;
		}

		override public function stop(duration:int = 0):void {
			stopVolumeChanger();
			for each (var stream:SoundStream in _streams) {
				stream.stop(duration);
			}
		}

		public function play(sound:Sound, loop:Boolean = false):SoundStream {
			return new SoundFlow(this, 1, sound, loop, 0, 0, 0, null);
		}

		public function prepare(sound:Sound):SoundPlayPreparer {
			return new SoundPlayPreparer(this, sound);
		}

		override protected function doPause():void {
			for each (var stream:SoundStream in _streams) {
				stream.pause();
			}
		}

		override protected function doResume():void {
			for each (var stream:SoundStream in _streams) {
				stream.resume();
			}
		}

		override protected function applyVolume():void {
			for each (var stream:AbstractSoundStream in _streams) {
				stream.setVolume(volume);
			}
		}

		internal function addStream(stream:AbstractSoundStream):void {
			_streams.add(stream);
		}

		internal function removeStream(stream:AbstractSoundStream):void {
			_streams.remove(stream);
		}
	}
}
