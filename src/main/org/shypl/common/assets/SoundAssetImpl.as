package org.shypl.common.assets {
	import flash.media.Sound;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SoundReceiver;
	import org.shypl.common.sound.SoundPlayPreparer;
	import org.shypl.common.sound.SoundStream;
	import org.shypl.common.sound.SoundSystem;
	import org.shypl.common.util.Progress;

	internal class SoundAssetImpl extends AbstractAsset implements SoundAsset, SoundReceiver {
		private var _sound:Sound;

		public function SoundAssetImpl(name:String, path:String, deferred:Boolean) {
			super(name, path, deferred);
		}

		public function get sound():Sound {
			return _sound;
		}

		override public function load():Progress {
			return FileLoader.loadSound(path, this);
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
			return new SoundPlayPreparerFake();
		}

		public function receiveSound(sound:Sound):void {
			_sound = sound;
			completeLoad();
		}

		override protected function doFree():void {
			_sound = null;
		}
	}
}
