package
{
	import com.microsoft.azure.media.AdaptiveStreamingPluginInfo;
	
	import flash.display.Sprite;
	
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	

	import flash.display.*;
	import org.osmf.media.*;
	import org.osmf.containers.MediaContainer;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.layout.ScaleMode;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.layout.*;
		

	
	
	//Sets the size of the SWF
	
	[SWF(width="640", height="480", backgroundColor='#405050', frameRate="25")]
	public class SimpleOSMFPlayer extends Sprite
	{
		public var _container:MediaContainer;
		public var _mediaFactory:DefaultMediaFactory;
		private var _mediaPlayerSprite:MediaPlayerSprite;
		
		public function SimpleOSMFPlayer( )
		{
			//stage.quality = StageQuality.HIGH;

			initMediaPlayer();
//			var worker:Worker = WorkerDomain.current.createWorker(this.loaderInfo.bytes);

		}
		
		private function initMediaPlayer():void
		{
			
			trace("OSMFSmooth: initMediaPlayer()");
			ExternalInterface.call("console.log", "OSMFSmooth: initMediaPlayer()");
			
			// Create the container (sprite) for managing display and layout
			_mediaPlayerSprite = new MediaPlayerSprite();
			_mediaPlayerSprite.addEventListener(MediaErrorEvent.MEDIA_ERROR, onPlayerFailed);
			_mediaPlayerSprite.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			
			trace("OSMFSmooth: addEventListener added");
			ExternalInterface.call("console.log", "addEventListener added");
			//Adds the container to the stage
			addChild(_mediaPlayerSprite);
			
			// Create a mediafactory instance
			_mediaFactory = new DefaultMediaFactory();

			trace("OSMFSmooth: _mediaFactory: " + _mediaFactory);
			ExternalInterface.call("console.log", "_mediaFactory: " + _mediaFactory);

			
			// Add the listeners for PLUGIN_LOADING
			_mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD,onPluginLoaded);
			_mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onPluginLoadFailed );
			
			// Load the plugin class
			loadAdaptiveStreamingPlugin( );
			
		}
		
		private function loadAdaptiveStreamingPlugin( ):void
		{
			var pluginResource:MediaResourceBase;
			var adaptiveStreamingPluginUrl:String;

			trace("OSMFSmooth: loadAdaptiveStreamingPlugin( )");
			ExternalInterface.call("console.log", "loadAdaptiveStreamingPlugin( )");

			// Your dynamic plugin web server needs to host a valid crossdomain.xml file to allow loading plugins.
			
			adaptiveStreamingPluginUrl = "http://localhost:8000/SimpleOSMFPlayer/bin-debug/MSAdaptiveStreamingPlugin-v1.0.12-osmf2.0.swf";
			pluginResource = new URLResource(adaptiveStreamingPluginUrl);
			trace("OSMFSmooth: pluginResource: " + pluginResource);
			ExternalInterface.call("console.log", "pluginResource: " + pluginResource);

			_mediaFactory.loadPlugin( pluginResource );
			
		}
		
		private function onPluginLoaded( event:MediaFactoryEvent ):void
		{
			// The plugin is loaded successfully.
			
			// Your web server needs to host a valid crossdomain.xml file to allow plugin to download Smooth Streaming files.
			trace("OSMFSmooth: Plugin LOADED");
			ExternalInterface.call("console.log", "Plugin LOADED");

			loadMediaSource("http://wams.edgesuite.net/media/SintelTrailer_MP4_from_WAME/sintel_trailer-1080p.ism/manifest")
		}
		
		private function onPluginLoadFailed( event:MediaFactoryEvent ):void
		{
			// The plugin is failed to load ...
			trace("OSMFSmooth: Plugin LOAD FAILED");
			ExternalInterface.call("console.log", "Plugin LOAD FAILED");
		}
		
		
		private function onPlayerStateChange(event:MediaPlayerStateChangeEvent) : void
		{
			var state:String;
			
			state = event.state;
			
			switch (state)
			{
				case MediaPlayerState.LOADING:
					
					// A new source is started to load.
					
					break;
				
				case MediaPlayerState.READY :
					// Add code to deal with Player Ready when it is hit the first load after a source is loaded.
					
					break;
				
				case MediaPlayerState.BUFFERING :
					
					break;
				
				case MediaPlayerState.PAUSED :
					break;
				// other states ...
			}
		}
		
		private function onPlayerFailed(event:MediaErrorEvent) : void
		{
			// Media Player is failed .
		}
		
		private function loadMediaSource(sourceURL : String):void
		{
			// Take an URL of SmoothStreamingSource's manifest and add it to the page.
			trace("OSMFSmooth: loadMediaSource");
			ExternalInterface.call("console.log", "loadMediaSource");

			var resource:URLResource= new URLResource( sourceURL );
			
			var element:MediaElement = _mediaFactory.createMediaElement( resource );
			_mediaPlayerSprite.scaleMode = ScaleMode.LETTERBOX;
			_mediaPlayerSprite.width = stage.stageWidth;
			_mediaPlayerSprite.height = stage.stageHeight;
			// Add the media element
			_mediaPlayerSprite.media = element;
			trace("OSMFSmooth: loadMediaSource LOADED");
			ExternalInterface.call("console.log", "loadMediaSource LOADED");
		}
		
	}
}
