MeterX
by Steve Tibbett (stevex-github@gmail.com)

This is a fairly simple program that was intended to be the start of something bigger.  

In it's current form, it's an Insteon PLM (PowerLineModem) protocol client that uses a TCP
connection to an Insteon 2412N device to send commands over the power line / wireless mesh 
to an Insteon iMeter Solo (2423A1), to retrieve the current power consumption in watts of 
whatever device is connected to the iMeter.  It retrieves the watt usage and displays it 
in a huge number on the display of whatever is running the app.

It's a Flex Mobile app, and the intention was to build this for Android and iOS as an app 
that would let you monitor power consumption from anywhere in your house (or beyond, 
depending on your network configuration).

But, as I discovered once I acquired a few other Insteon devices, my house is not Insteon 
compatible.  Insteon requires specific wiring, with line, load, neutral and ground all 
available at the switch, and my house isn't wired that way.  (Our last house, which was 
built new, was wired for Insteon because I had that written into the plans).  

Since I'm not building out an Insteon network at home, I'm not going to pursue the Insteon 
software I was building.  So I'm releasing the code, as-is, for others to hopefully use as 
a starting point.

To use the included app, assuming you have the required hardware, entere the Insteon
address (the 3 byte hex value) of your iMeter Solo in the powerMeterAddress field of 
ModemController, enter the IP address of your 2412N in AppModel's constructor, and
that's it - you should have an app that can show you power consumption in watts, updated
every 5 seconds, of whatever device is plugged into the iMeter. 

There are a few useful things here:

app.insteon.PowerLineModem

	This class will connect given a host and port number, to a 2412N.  The 2412N
	offers PLM through TCP, but in a shaky, undocumented form.  The only really shaky
	thing about it is that it only supports one client, so I had planned to create a
	multiplexer that would let other home control software connect as well as this
	app and any other, but that didn't get off the ground.
	
	But this class does understand how to send and receive Insteon packets, including
	assembling incoming variable length packets.
	
app.insteon.ModemResponseParser

	This class, in conjunction with the insteon.xml file, can parse an Insteon command
	or response to determine the type and fields.  It understands that packets can
	be varying sizes based on what bits are set in what bytes, so the file includes a
	mechanism for inspecting the packet bytes received so far to determine how many
	more bytes to expect for a given packet.
	
insteon.xml

	This is an XML representation of a lot of a lot of information about Insteon packets
	for various devices.  Hopefully it's somewhat self-explanatory.

Some useful links for anyone doing Insteon development:

http://sharpeespace.blogspot.com/2011/03/insteon-2412n-protocol.html
https://github.com/zonyl/pyinsteon/blob/master/src/pyinsteon.py
http://www.insteon.net/pdf/INSTEON_Command_Tables_20070925a.pdf
http://www.aartech.ca/docs/2412sdevguide.pdf

Good luck; I hope someone finds this useful.
