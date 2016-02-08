package org.shypl.common.util {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextFieldBuilder {

		public static function createBuilder(params:Object):TextFieldBuilder {
			var builder:TextFieldBuilder = new TextFieldBuilder();

			for (var key:String in params) {
				if (params.hasOwnProperty(key)) {
					var filed:String = "_" + key;
					builder[filed] = params[key];
				}
			}

			return builder;
		}

		public static function createField(params:Object):TextField {
			return createBuilder(params).build();
		}

		private var _font:String = null;
		private var _size:int = 12;
		private var _color:uint = 0;
		private var _bold:Boolean = false;
		private var _italic:Boolean = false;
		private var _align:String = TextFormatAlign.LEFT;
		private var _leading:int = 0;
		private var _embedFonts:Boolean = false;
		private var _selectable:Boolean = false;
		private var _autoSize:String = TextFieldAutoSize.NONE;
		private var _wordWrap:Boolean;
		private var _x:int;
		private var _y:int;
		private var _width:int = -1;
		private var _height:int = -1;
		private var _text:String = null;
		private var _htmlText:String = null;

		public function TextFieldBuilder() {
		}

		public function build():TextField {
			var filed:TextField = new TextField();
			filed.defaultTextFormat = new TextFormat(_font, _size, _color, _bold, _italic, null, null, null, _align, null, null, null, _leading);
			filed.embedFonts = _embedFonts;
			filed.selectable = _selectable;
			filed.wordWrap = _wordWrap;
			filed.x = _x;
			filed.y = _y;

			if (_width > -1) {
				filed.width = _width;
			}
			if (_height > -1) {
				filed.height = _height;
			}

			filed.autoSize = _autoSize;

			if (_text !== null) {
				filed.text = _text;
			}
			if (_htmlText !== null) {
				filed.htmlText = _htmlText;
			}

			return filed;
		}

		public function setFont(value:String):TextFieldBuilder {
			_font = value;
			return this;
		}

		public function setSize(value:int):TextFieldBuilder {
			_size = value;
			return this;
		}

		public function setColor(value:uint):TextFieldBuilder {
			_color = value;
			return this;
		}

		public function setBold(value:Boolean):TextFieldBuilder {
			_bold = value;
			return this;
		}

		public function setItalic(value:Boolean):TextFieldBuilder {
			_italic = value;
			return this;
		}

		public function setAlign(value:String):TextFieldBuilder {
			_align = value;
			return this;
		}

		public function setLeading(value:int):TextFieldBuilder {
			_leading = value;
			return this;
		}

		public function setEmbedFonts(value:Boolean):TextFieldBuilder {
			_embedFonts = value;
			return this;
		}

		public function setSelectable(value:Boolean):TextFieldBuilder {
			_selectable = value;
			return this;
		}

		public function setAutoSize(value:String):TextFieldBuilder {
			_autoSize = value;
			return this;
		}

		public function setPosition(x:int, y:int):TextFieldBuilder {
			_x = x;
			_y = y;
			return this;
		}

		public function setX(value:int):TextFieldBuilder {
			_x = value;
			return this;
		}

		public function setY(value:int):TextFieldBuilder {
			_y = value;
			return this;
		}

		public function setBounds(width:int, height:int):TextFieldBuilder {
			_width = width;
			_height = height;
			return this;
		}

		public function setWidth(value:int):TextFieldBuilder {
			_width = value;
			return this;
		}

		public function setHeight(value:int):TextFieldBuilder {
			_height = value;
			return this;
		}

		public function setText(value:Object):TextFieldBuilder {
			_text = String(value);
			return this;
		}

		public function setHtmlText(value:Object):TextFieldBuilder {
			_htmlText = String(value);
			return this;
		}

		public function setWordWrap(value:Boolean):TextFieldBuilder {
			_wordWrap = value;
			return this;
		}
	}
}
