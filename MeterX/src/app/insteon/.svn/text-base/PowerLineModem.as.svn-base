package app.insteon
{
	import app.model.AppModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import util.HexUtils;

	public class PowerLineModem extends EventDispatcher
	{
		private var _host:String;
		private var _port:int;
		
		private var _socket:Socket;
		private var _currentPacket:ByteArray = new ByteArray();

		private var _processChar:Function = processIdle;
		
		private var _expectedPacketSize:int;
		
		protected function log(msg:String):void
		{
			trace(msg);
		}
		
		public function get remoteAddress():String
		{
			return _socket.remoteAddress;
		}

		public function get remotePort():int
		{
			return _socket.remotePort;
		}

		public function PowerLineModem(host:String, port:int = 9761)
		{
			_host = host;
			_port = port;
		}
		
		public function connect():void
		{
			disconnect();
			
			_socket = new Socket(_host, _port);
			_socket.addEventListener(Event.CONNECT, handleSocketConnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
		}
		
		public function disconnect():void
		{
			if (_socket)
			{
				if (_socket.connected)
					_socket.close();
				
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
			}
		}
		
		public function send(bytes:ByteArray):void
		{
			_socket.writeByte(0x02);
			_socket.writeBytes(bytes);
			_socket.flush();
		}

		/**
		 * Notification that the socket is connected.
		 */
		protected function handleSocketConnect(event:Event):void
		{
			// Redispatch to our listeners
			dispatchEvent(event);
		}
		
		protected function processIdle(ch:uint):void
		{
			switch (ch)
			{
				case 0x02:
					_processChar = processModemCommandByte;
					break;
				case 0x15:
					var event:PowerLineModemEvent = new PowerLineModemEvent(PowerLineModemEvent.NAK);
					dispatchEvent(event);
					return;
				default:
					log("Received unexpected byte in idle state: " + ch.toString(16));
					break;
			}
		}
		
		protected function processModemCommandByte(ch:int):void
		{
			// Look up how many bytes to expect
			for each (var command:* in AppModel.instance.insteonData.modemCommands.modemCommand)
			{
				if (ch == parseInt(command.command))
				{
					_expectedPacketSize = parseInt(command.response[0].length) + 1;
				}
			}

			_processChar = assemblePacket;
			_processChar(ch);
		}

		private function assemblePacket(ch:int):void
		{
			_currentPacket.writeByte(ch);
			if (_currentPacket.length == _expectedPacketSize)
			{
				// A packet may have multiple responses with different sizes .. check the conditional
				// responses and update the size if required.
				var command:XML = ModemResponseParser.findCommand(_currentPacket[0]);
				if (command == null)
				{
					log("Unrecognized command: " + HexUtils.byteToHex(ch));
				} else
				{
					var response:XML = ModemResponseParser.findMatchingResponse(command, _currentPacket); 
					if (_expectedPacketSize < (parseInt(response.length) + 1))
					{
						// Need more bytes to complete the matching response.
						return;
					}
				}

				// Dispatch back to our listeners
				var event:PowerLineModemEvent = new PowerLineModemEvent(PowerLineModemEvent.RAW_PACKET_RECEIVED);
				event.packetBytes = _currentPacket;
				dispatchEvent(event);
				
				// Reset for next packet
				_currentPacket = new ByteArray();
				_processChar = processIdle;
			}
		}

		/**
		 * Notification that there is socket data ready to read.
		 */
		protected function handleSocketData(event:ProgressEvent):void
		{
			var numBytes:int = _socket.bytesAvailable;
			for (var i:int=0; i<numBytes; i++)
			{
				var ch:int = _socket.readByte();
				_processChar(ch);
			}
		}
	}
}