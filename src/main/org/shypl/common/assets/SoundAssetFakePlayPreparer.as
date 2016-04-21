package org.shypl.common.assets {
	import org.shypl.common.sound.SoundPlayPreparer;
	import org.shypl.common.sound.SoundStream;

	internal class SoundAssetFakePlayPreparer extends SoundPlayPreparer {
		public function SoundAssetFakePlayPreparer() {
			super(null, null);
		}

		override public function play():SoundStream {
			return null;
		}
	}
}
