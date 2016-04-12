package org.shypl.common.ui.button {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.DestroyableSprite;

	[Abstract]
	[Event(name="press", type="org.shypl.common.ui.button.ButtonEvent")]
	public class Button extends DestroyableSprite {
		private var _state:ButtonState = ButtonState.NORMAL;
		private var _enabled:Boolean = true;
		private var _underMouse:Boolean;
		private var _pressed:Boolean;
		private var _data:*;

		public function Button(hitArea:Sprite = null) {
			mouseChildren = false;

			if (hitArea) {
				addChild(hitArea);
				this.hitArea = hitArea;
				hitArea.mouseEnabled = false;
				hitArea.alpha = 0;
			}

			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStageEvent);

			enable0();
		}

		public function get state():ButtonState {
			return _state;
		}

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(v:Boolean):void {
			if (v) {
				enable();
			}
			else {
				disable();
			}
		}

		public function get data():* {
			return _data;
		}

		public function set data(v:*):void {
			_data = v;
		}

		public function enable():void {
			if (!_enabled) {
				_enabled = true;
				enable0();
				setState(_underMouse ? ButtonState.HOVER : ButtonState.NORMAL);
			}
		}

		public function disable():void {
			if (_enabled) {
				_enabled = false;
				buttonMode = false;
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				setState(ButtonState.DISABLED);
			}
		}

		public function press():void {
			if (_enabled) {
				dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
			}
		}

		[Abstract]
		protected function update():void {
			throw new AbstractMethodException();
		}

		private function enable0():void {
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		}

		private function setState(state:ButtonState):void {
			if (_state !== state) {
				_state = state;
				update();
			}
		}

		private function removeStageMouseHandlers():void {
			stage.removeEventListener(Event.MOUSE_LEAVE, handleStageMouseEvent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseEvent);
		}

		private function mouseHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					_underMouse = true;
					if (_enabled) {
						setState(_pressed ? ButtonState.ACTIVE : ButtonState.HOVER);
					}
					break;

				case MouseEvent.MOUSE_OUT:
					_underMouse = false;
					if (_enabled) {
						setState(ButtonState.NORMAL);
					}
					break;

				case MouseEvent.MOUSE_DOWN:
					_pressed = true;
					setState(ButtonState.ACTIVE);
					stage.addEventListener(Event.MOUSE_LEAVE, handleStageMouseEvent);
					stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseEvent);
					break;

				case MouseEvent.MOUSE_UP:
					removeStageMouseHandlers();
					setState(ButtonState.HOVER);
					if (_pressed) {
						_pressed = false;
						press();
					}
					break;
			}
		}

		private function handleStageMouseEvent(event:Event):void {
			removeStageMouseHandlers();

			switch (event.type) {
				case Event.MOUSE_LEAVE:
					_underMouse = false;
					_pressed = false;
					if (_enabled) {
						setState(ButtonState.NORMAL);
					}
					break;
				case MouseEvent.MOUSE_UP:
					_pressed = false;
					break;
			}
		}

		private function handleRemovedFromStageEvent(event:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStageEvent);
			removeStageMouseHandlers();
		}
		
		override protected function doDestroy():void {
			super.doDestroy();
			_data = null;
		}
	}
}
