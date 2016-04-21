package org.shypl.common.assets {
	import flash.media.Sound;

	import org.shypl.common.sound.SoundPlayPreparer;
	import org.shypl.common.sound.SoundStream;
	import org.shypl.common.sound.SoundSystem;
	import org.shypl.common.util.progress.Progress;

	public class SoundAsset extends Asset {
		private var _sound:Sound;

		function SoundAsset(path:String) {
			super(path);
		}

		public function get sound():Sound {
			return _sound;
		}

		public function play(soundSystem:SoundSystem, loop:Boolean = false):SoundStream {
			if (loaded) {
				return soundSystem.play(_sound, loop);
			}
			return null;
		}

		public function prepare(soundSystem:SoundSystem):SoundPlayPreparer {
			if (loaded) {
				return soundSystem.prepare(_sound);
			}
			return new SoundAssetFakePlayPreparer();
		}

		override protected function doLoad():Progress {
			return new SoundAssetLoader(this);
		}

		override protected function doFree():void {
			_sound = null;
		}

		internal function receiveData(sound:Sound):void {
			_sound = sound;
			completeLoad();
		}
	}
}
