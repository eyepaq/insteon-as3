package app.model
{
	import app.controllers.ModemController;
	import app.insteon.PowerLineModem;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	[Bindable]
	public class AppModel
	{
		public static var instance:AppModel;
		
		public var modemController:ModemController;
		
		public var insteonData:XML;
		
		// This is the value we're showing in the main display
		public var watts:int;
		
		public function AppModel()
		{
			readInsteonData();
			
			modemController = new ModemController();
			modemController.host = "192.168.1.5";
			modemController.connect();
		}
		
		private function readInsteonData():void
		{
			var file:File = File.applicationDirectory.resolvePath("assets/insteon.xml");
			if (!file.exists)
			{
				throw new Error("Can't find app:/assets/insteon.xml");
			}
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			insteonData = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
		}
	}
}