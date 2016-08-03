package org.shypl.common.assets {
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
	import org.shypl.common.loader.SwfFile;
	
	public interface AssetsCollection {
		function getBinary(name:String):BytesAsset;
		
		function getText(name:String):TextAsset;
		
		function getXml(name:String):XmlAsset;
		
		function getImage(name:String):ImageAsset;
		
		function getAtlas(name:String):AtlasAsset;
		
		function getSound(name:String):SoundAsset;
		
		function getSwf(name:String):SwfAsset;
		
		function getFont(name:String):FontAsset;
		
		function getRawBinary(name:String):ByteArray;
		
		function getRawText(name:String):String;
		
		function getRawXml(name:String):XML;
		
		function getRawImage(name:String):BitmapData;
		
		function getRawSound(name:String):Sound;
		
		function getRawSwf(name:String):SwfFile;
		
		function getRawFont(name:String):Font;
		
		function free():void;
	}
}
