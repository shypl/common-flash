package org.shypl.common.assets {
	import flash.system.ApplicationDomain;
	
	public interface AssetsCollector {
		function addBinary(name:String, deferred:Boolean = false, path:String = null):BytesAsset;
		
		function addText(name:String, deferred:Boolean = false, path:String = null):TextAsset;
		
		function addXml(name:String, deferred:Boolean = false, path:String = null):XmlAsset;
		
		function addImage(name:String, deferred:Boolean = false, path:String = null):ImageAsset;
		
		function addAtlas(name:String, deferred:Boolean = false, path:String = null):AtlasAsset;
		
		function addSound(name:String, deferred:Boolean = false, path:String = null):SoundAsset;
		
		function addSwf(name:String, deferred:Boolean = false, path:String = null, inCurrentDomain:Boolean = false):SwfAsset;
		
		function addSwfInDomain(name:String, domain:ApplicationDomain, deferred:Boolean = false, path:String = null):SwfAsset;
		
		function addFont(name:String, deferred:Boolean = false, path:String = null):FontAsset;
		
		function add(name:String, type:AssetType = null, deferred:Boolean = false, path:String = null, domain:ApplicationDomain = null):Asset;
		
		function addMany(names:Vector.<String>, deferred:Boolean = false, paths:Vector.<String> = null):Vector.<Asset>;
	}
}
