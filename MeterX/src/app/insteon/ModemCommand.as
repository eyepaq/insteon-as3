package app.insteon
{
	public class ModemCommand
	{
		public static const INSTEON_MESSAGE_RECEIVED:int = 0x50;
		public static const INSTEON_EXTENDED_MESSAGE_RECEIVED:int = 0x51;
		public static const X10_RECEIVED:int = 0x52;
		public static const ALL_LINKING_COMPLETED:int = 0x53;
		public static const BUTTON_EVENT_REPORT:int = 0x54;
		public static const USER_RESET_DETECTED:int = 0x55;
		public static const ALL_LINK_CLEANUP_FAILURE_REPORT:int = 0x56;
		public static const ALL_LINK_RESPONSE_RECORD = 0x57;

	}
}