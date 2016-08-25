package org.shypl.common.sound {
	import flash.media.Sound;
	
	import org.shypl.common.collection.HashSet;
	import org.shypl.common.collection.Set;
	
	public final class SoundSystem extends AbstractSoundStream implements SoundStream {
		private var _streams:Set = new HashSet();
		private var _volumeBeforeMute:Number;
		
		public function SoundSystem(volume:Number = 1, system:SoundSystem = null) {
			super(system, volume);
			_volumeBeforeMute = volume;
			if (hasParent() && system.paused) {
				pause();
			}
		}
		
		public function toggleMute():void {
			if (volume == 0) {
				volume = _volumeBeforeMute;
			}
			else {
				_volumeBeforeMute = volume;
				volume = 0;
			}
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
		
		private function hasParent():Boolean {
			return system !== null;
		}
	}
}
