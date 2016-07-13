package org.shypl.common.util {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	[Event(name="destroy", type="org.shypl.common.util.DestroyEvent")]
	public class DestroyableSprite extends Sprite implements CheckableDestroyable {
		private var _destroyed:Boolean;
		private var _eventListeners:Object = {};
		
		public function DestroyableSprite() {
		}
		
		public final function get destroyed():Boolean {
			return _destroyed;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
			useWeakReference:Boolean = false
		):void {
			if (!_destroyed) {
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);

				var listeners:Dictionary = _eventListeners[type];
				if (listeners === null) {
					listeners = new Dictionary();
					_eventListeners[type] = listeners;
				}
				listeners[listener] = listener;
			}
		}
		
		override public function hasEventListener(type:String):Boolean {
			return _destroyed ? false : super.hasEventListener(type);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (!_destroyed) {
				super.removeEventListener(type, listener, useCapture);

				const listeners:Dictionary = _eventListeners[type];
				if (listeners !== null) {
					delete listeners[listener];
				}
			}
		}

		public final function destroy():void {
			if (!_destroyed) {
				dispatchEvent(new DestroyEvent());
				doDestroy();
				_destroyed = true;
			}
		}
		
		public function removeAllEventListeners():void {
			if (!_destroyed) {
				for (var type:String in _eventListeners) {
					var listeners:Dictionary = _eventListeners[type];
					for (var listener:Object in listeners) {
						delete listeners[listener];
					}
					delete _eventListeners[type];
				}
			}
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			return _destroyed ? false : super.dispatchEvent(event);
		}

		protected function doDestroy():void {
			if (super.parent !== null) {
				super.parent.removeChild(this);
			}

			var i:int = super.numChildren;
			while (i != 0) {
				var child:DisplayObject = super.getChildAt(--i);
				super.removeChildAt(i);
				if (child is Destroyable) {
					Destroyable(child).destroy();
				}
			}

			removeAllEventListeners();
			_eventListeners = null;
		}
	}
}
