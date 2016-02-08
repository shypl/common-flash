package org.shypl.common.assets {
	import flash.media.Sound;

	import org.shypl.common.sound.SoundPlayPreparer;

	import org.shypl.common.sound.SoundStream;
	import org.shypl.common.sound.SoundSystem;

	public interface SoundAsset extends Asset {
		function get sound():Sound;

		function play(soundSystem:SoundSystem, loop:Boolean = false):SoundStream;

		function prepare(soundSystem:SoundSystem):SoundPlayPreparer;
	}
}
