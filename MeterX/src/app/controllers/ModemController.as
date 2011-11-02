package app.controllers
{
	import app.insteon.CommandBuilder;
	import app.insteon.ModemResponseParser;
	import app.insteon.PowerLineModem;
	import app.insteon.PowerLineModemEvent;
	import app.model.AppModel;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import util.HexUtils;

	public class ModemController
	{
		public var plm:PowerLineModem;
		public var host:String;
		public var port:int = 9761;
		private var powerMeterAddress:String = "18F3EA";
		
		private var refreshTimer:Timer = new Timer(5000, 0);
		
		public function connect():void
		{
			if (plm != null)
				plm.disconnect();

			plm = new PowerLineModem(host, port);
			plm.addEventListener(Event.CONNECT, handleModemConnect);
			plm.connect();
		}
		
		
		protected function handleModemConnect(event:Event):void
		{
			trace("Connected to PLM @ " + plm.remoteAddress);

			plm.removeEventListener(Event.CONNECT, handleModemConnect);

			plm.addEventListener(PowerLineModemEvent.RAW_PACKET_RECEIVED, handleRawPacketReceived);

			// Enable Monitor Mode
//			var monitorModebytes:ByteArray = HexUtils.hexToBytes("6b40");
//			plm.send(monitorModebytes);

			// Status request
			var bytes:ByteArray = CommandBuilder.buildInsteonStatusRequestCommand(powerMeterAddress);

//			var bytes:ByteArray = CommandBuilder.buildInsteonDeviceTextStringRequestcommand(powerMeterAddress);
//			var bytes:ByteArray = HexUtils.hexToBytes("6217e4160f0300");
//			var bytes:ByteArray = CommandBuilder.buildInsteonProductDataRequestCommand(powerMeterAddress);
//			var bytes:ByteArray = CommandBuilder.buildGetModemInfoCommand();
//			var bytes:ByteArray = CommandBuilder.buildResetModemCommand();

			trace("Sending request: " + HexUtils.bytesToHex(bytes));
			
			plm.send(bytes);

		}
		
		private function handleTimer(event:TimerEvent):void
		{
			refreshTimer.removeEventListener(TimerEvent.TIMER, handleTimer);
			trace("Timer: requesting status update");
			var bytes:ByteArray = CommandBuilder.buildInsteonStatusRequestCommand(powerMeterAddress);
			plm.send(bytes);
		}
		
		private function handleRawPacketReceived(event:PowerLineModemEvent):void
		{
			trace("Received packet: " + HexUtils.bytesToHex(event.packetBytes));
			if (event.packetBytes.length == 24 && event.packetBytes[8] == 0x82 && event.packetBytes[9] == 0x00)
			{
				// It's an extended status response, so we'll just assume it's a watt report
				// TODO: it's obviously bad form here to write back into the AppModel
				AppModel.instance.watts = (event.packetBytes[16] << 8) | event.packetBytes[17]; 
				
				refreshTimer.addEventListener(TimerEvent.TIMER, handleTimer);
				refreshTimer.start();
			}
			
			var modemResponseParser:ModemResponseParser = new ModemResponseParser();
			trace(modemResponseParser.bytesToString(event.packetBytes));
		}
	}
}