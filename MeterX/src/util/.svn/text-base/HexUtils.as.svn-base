package util
{
	import flash.utils.ByteArray;

	public class HexUtils
	{
		public static function hexToByte(hexString:String):uint
		{
			return parseInt(hexString, 16);
		}
		
		public static function byteToHex(byte:uint):String
		{
			var hexChars:String = "0123456789ABCDEF";
			var hexStr:String = new String();
			hexStr += hexChars.charAt((byte>>4)&0xf);
			hexStr += hexChars.charAt(byte&0xf);
			return hexStr;
		}
		
		public static function hexToBytes(hex:String):ByteArray
		{
			var byteArray:ByteArray = new ByteArray();
			var len:int = hex.length;
			var pos:uint = 0;
			
			while(pos < len)
			{
				var hbyte:String = hex.charAt(pos) + hex.charAt((pos + 1));
				byteArray.writeByte(parseInt(hbyte, 16));
				pos = pos + 2;
			}
			
			return byteArray;
		}
		
		public static function bytesToHex(bytes:ByteArray):String
		{
			bytes.position = 0;
			var hex:String = new String(); 
			while (bytes.bytesAvailable > 0)
			{
				hex += byteToHex(bytes.readByte());	
			}
			return hex;
		}
	}
}