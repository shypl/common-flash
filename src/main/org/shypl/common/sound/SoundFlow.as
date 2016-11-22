package org.shypl.common.sound {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.timeline.Timeline;
	import org.shypl.common.util.Cancelable;

	internal class SoundFlow extends AbstractSoundStream {
		private var _sound:Sound;
		private var _loop:Boolean;
		private var _end:Number;
		private var _restart:Number;
		private var _channel:SoundChannel;
		private var _endTask:Cancelable;
		private var _stopOnFade:Boolean;
		private var _endHandler:Function;
		private var _pausePosition:Number;

		public function SoundFlow(system:SoundSystem, volume:Number, sound:Sound, loop:Boolean, start:Number, end:Number, restart:Number, endHandler:Function) {
			super(system, volume);

			_sound = sound;
			_loop = loop;
			_end = end;
			_restart = restart;
			_endHandler = endHandler;
			
			var transform:SoundTransform = new SoundTransform(realVolume);

			try {
				if (_loop) {
					if (start == 0 && _end == 0) {
						_channel = _sound.play(0, int.MAX_VALUE, transform);
					}
					else {
						_channel = _sound.play(start, 1, transform);
					}
				}
				else {
					_channel = _sound.play(start, 1, transform);
				}
			}
			catch (ignored:Error) {
			}

			if (_channel === null) {
				_loop = false;
				GlobalTimeline.forNextFrame(handleEnd);
			}
			else {
				if (_end != 0) {
					if (_end < start) {
						throw new IllegalArgumentException("end < start");
					}
					_endTask = GlobalTimeline.schedule(_end - start, handleEnd);
				}
				_channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				
				if (system.paused) {
					pause();
				}
			}
		}

		override public function stop(fadeDuration:int = 0):void {
			if (_sound === null) {
				return;
			}

			if (fadeDuration == 0) {
				stopVolumeChanger();

				if (_channel) {
					_channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
					_channel.stop();
				}

				if (_endTask) {
					_endTask.cancel();
				}

				free();
			}
			else {
				changeVolume(0, fadeDuration);
				_stopOnFade = true;
			}
		}

		override public function changeVolume(value:Number, duration:int):void {
			if (!_stopOnFade) {
				super.changeVolume(value, duration);
			}
		}

		override protected function doPause():void {
			super.doPause();
			if (_channel) {
				_pausePosition = _channel.position;
				_channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				_channel.stop();
				if (_end != 0) {
					_endTask.cancel();
					_endTask = null;
				}
			}
		}

		override protected function doResume():void {
			super.doResume();
			if (_channel) {
				try {
					var transform:SoundTransform = _channel.soundTransform;
					
					_channel = _sound.play(_pausePosition, 1, transform);
					_channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
					
					if (_end != 0) {
						_endTask = GlobalTimeline.schedule(_end - _restart, handleEnd);
					}
				}
				catch (e:Error) {
					handleEnd();
				}
			}
		}

		override protected function free():void {
			super.free();

			_sound = null;
			_channel = null;
			_endTask = null;
			_endHandler = null;
		}

		override protected function applyVolume():void {
			if (_channel) {
				var transform:SoundTransform = _channel.soundTransform;
				transform.volume = realVolume;
				_channel.soundTransform = transform;
			}
			if (_stopOnFade && volume == 0) {
				stop();
			}
		}

		private function handleEnd():void {
			if (_loop) {
				var transform:SoundTransform = _channel.soundTransform;

				_channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				_channel.stop();

				_channel = _sound.play(_restart, 1, transform);
				_channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);

				if (_end != 0) {
					_endTask.cancel();
					_endTask = GlobalTimeline.schedule(_end - _restart, handleEnd);
				}
			}

			if (_endHandler !== null) {
				_endHandler();
			}

			if (!_loop) {
				stop();
			}

		}

		private function handleSoundComplete(event:Event):void {
			handleEnd();
		}
	}
}
