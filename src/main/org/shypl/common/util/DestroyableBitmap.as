package org.shypl.common.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.utils.Dictionary;

	[Event(name="destroy", type="org.shypl.common.util.DestroyEvent")]
	public class DestroyableBitmap extends Bitmap implements CheckableDestroyable {
		private var _destroyed:Boolean;
		private var _eventListeners:Object = {};
		
		public function DestroyableBitmap(bitmapData:BitmapData = null, pixelSnapping:String = PixelSnapping.AUTO, smoothing:Boolean = true) {
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		public final function get destroyed():Boolean {
			return _destroyed;
		}
		
		override public final function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
			useWeakReference:Boolean = false
		):void {
			if (_destroyed) {
				return;
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var listeners:Dictionary = _eventListeners[type];
			if (listeners === null) {
				listeners = new Dictionary();
				_eventListeners[type] = listeners;
			}
			listeners[listener] = listener;
		}
		
		override public final function hasEventListener(type:String):Boolean {
			return _destroyed ? false : super.hasEventListener(type);
		}
		
		override public final function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (_destroyed) {
				return;
			}
			super.removeEventListener(type, listener, useCapture);
			
			const listeners:Dictionary = _eventListeners[type];
			if (listeners !== null) {
				delete listeners[listener];
			}
		}
		
		public final function destroyBitmapData():void {
			if (bitmapData !== null) {
				bitmapData.dispose();
				bitmapData = null;
			}
		}
		
		public final function destroy():void {
			if (!_destroyed) {
				dispatchEvent(new DestroyEvent());
				_destroyed = true;
				doDestroy();
			}
		}
		
		public function removeAllEventListeners():void {
			for (var type:String in _eventListeners) {
				var listeners:Dictionary = _eventListeners[type];
				for (var listener:Object in listeners) {
					delete listeners[listener];
				}
				delete _eventListeners[type];
			}
		}
		
		override public final function dispatchEvent(event:Event):Boolean {
			if (_destroyed) {
				return false;
			}
			return super.dispatchEvent(event);
		}

		protected function doDestroy():void {
			if (super.parent !== null) {
				super.parent.removeChild(this);
			}

			destroyBitmapData();
			
			removeAllEventListeners();
			_eventListeners = null;
		}
	}
}
