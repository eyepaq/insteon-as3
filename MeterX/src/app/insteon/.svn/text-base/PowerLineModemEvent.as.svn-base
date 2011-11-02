package app.insteon
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class PowerLineModemEvent extends Event
	{
		public static const RAW_PACKET_RECEIVED:String = "rawPacketData";
		public static const NAK:String = "nak";
		
		public function PowerLineModemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Byte[0] will be the command byte.
		 * So for an Insteon message received, byte[0] will be 0x50 or 0x51
		 * (for standard and extended). 
		 */
		public var packetBytes:ByteArray;
	}
}