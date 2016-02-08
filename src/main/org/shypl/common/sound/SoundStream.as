package org.shypl.common.sound {
	public interface SoundStream {
		function get volume():Number;

		function set volume(value:Number):void;

		function get realVolume():Number;

		function changeVolume(value:Number, duration:int):void;

		function stop(fadeDuration:int = 0):void;

		function pause():void;

		function resume():void;
	}
}
