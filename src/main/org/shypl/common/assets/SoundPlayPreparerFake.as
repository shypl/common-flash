package org.shypl.common.assets {
	import org.shypl.common.sound.SoundPlayPreparer;
	import org.shypl.common.sound.SoundStream;

	internal class SoundPlayPreparerFake extends SoundPlayPreparer {
		public function SoundPlayPreparerFake() {
			super(null, null);
		}

		override public function play():SoundStream {
			return null;
		}
	}
}
