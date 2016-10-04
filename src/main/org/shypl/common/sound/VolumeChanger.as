package org.shypl.common.sound {
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;
	
	internal class VolumeChanger {
		private var _stream:AbstractSoundStream;
		private var _current:Number;
		private var _target:Number;
		private var _increase:Boolean;
		private var _step:Number;
		private var _updateTask:Cancelable;
		
		public function VolumeChanger(stream:AbstractSoundStream, target:Number, duration:uint) {
			_stream = stream;
			_current = _stream.volume;
			_target = target;
			_increase = _target > _current;
			_step = (_target - _current) / duration;
			
			_updateTask = GlobalTimeline.forEachFrame(update);
		}
		
		public function stop():void {
			if (_updateTask !== null) {
				_updateTask.cancel();
				_updateTask = null;
				_stream.removeVolumeChanger();
				_stream = null;
			}
		}
		
		public function pause():void {
			_updateTask.cancel();
			_updateTask = null;
		}
		
		public function resume():void {
			_updateTask = GlobalTimeline.forEachFrame(update);
		}
		
		private function update(time:int):void {
			_current += time * _step;
			
			if ((_increase && (_current >= _target)) || (!_increase && (_current <= _target))) {
				_stream.setVolume(_target);
				stop();
			}
			else {
				_stream.setVolume(_current);
			}
		}
	}
}
