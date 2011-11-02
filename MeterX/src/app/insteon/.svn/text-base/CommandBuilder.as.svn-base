package app.insteon
{
	import flash.utils.ByteArray;
	
	import util.HexUtils;

	public class CommandBuilder
	{
		public static function buildResetModemCommand():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x67);
			return bytes;
		}
		
		public static function buildGetModemInfoCommand():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x60);
			return bytes;
		}
		
		public static function buildInsteonStatusRequestCommand(dest:String):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x62); 	// send insteon command
			bytes.writeBytes(HexUtils.hexToBytes(dest));
			bytes.writeByte(0x0f);	// flags
			bytes.writeByte(0x19);  // status request
			bytes.writeByte(0x00);  // unused
			return bytes;
		}

		public static function buildInsteonDeviceTextStringRequestcommand(dest:String):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x62); 	// send insteon command
			bytes.writeBytes(HexUtils.hexToBytes(dest));
			bytes.writeByte(0x0f);	// flags
			bytes.writeByte(0x03);  // Device Text String Request
			bytes.writeByte(0x02); 
			return bytes;
		}

		public static function buildInsteonProductDataRequestCommand(dest:String):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0x62); 	// send insteon command
			bytes.writeBytes(HexUtils.hexToBytes(dest));
			bytes.writeByte(0x0f);	// flags
			bytes.writeByte(0x03);  // status request
			bytes.writeByte(0x00);  // unused
			return bytes;
		}
	}
}