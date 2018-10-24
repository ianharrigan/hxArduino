# hxArduino on OSX

Make sure you followed the [Getting Started](start/getting_started.md) instructions first.


* `haxe -lib hxArduino -cp src -neko dummy.n -main Main`
	* (Need to use neko dummy output for now - not entirely sure why)
* `haxelib run hxArduino test C:\Temp\temp2\bin\generated`
	* Makes COM port assumption (needs to change!)



##

in 01-blink folder:

```
haxe build.hxml
```

and to test:


```
haxelib run hxArduino test -port COM3
```
(with whatever your com port is)


## todo



→ haxelib run hxArduino help
hxArduino
usage: haxelib run hxArduino [install/monitor/test] [-h] [-v] [-file FOO] [-port BAR]

Optional arguments:
  -install            Install Arduino code on device.
  -monitor            Monitor com ports.
  -test               Install and monitor.
  -help               This message .
  -h, --help          Show this help message and exit.
  -v, --version       Show program's version number and exit.
  -file               hexfile?.
  -port               port to use.




## ports

Select the serial device of the Arduino board from the Tools | Serial Port menu. On Windows, this should be COM1 or COM2 for a serial Arduino board, or COM3, COM4, or COM5 for a USB board. On the Mac, this should be something like /dev/cu.usbserial-1B1 for a USB board, or something like /dev/cu.USA19QW1b1P1.1 if using a Keyspan adapter with a serial board (other USB-to-serial adapters use different names).



→ haxelib run hxArduino -monitor
Starting serial monitor on COM3
Port list: [/dev/cu.Bluetooth-Incoming-Port,/dev/tty.Bluetooth-Incoming-Port,/dev/cu.usbmodem14101,/dev/tty.usbmodem14101]

→ haxelib run hxArduino -monitor
Starting serial monitor on COM3
Port list: [/dev/cu.Bluetooth-Incoming-Port,/dev/tty.Bluetooth-Incoming-Port]




haxelib run hxArduino test -port /dev/cu.usbmodem14101


## ENV VARS

https://www.schrodinger.com/kb/1842



OS X 10.10

To set an environment variable, enter the following command:

```
launchctl setenv variable "value"
```

To find out if an environment variable is set, use the following command:

```
launchctl getenv variable
```

To clear an environment variable, use the following command:

```
launchctl unsetenv variable
```

----

or



http://osxdaily.com/2015/07/28/set-enviornment-variables-mac-os-x/

write bash_profile


```bash
~/.bash_profile
nano .bash_profile
export ARDUINO_HOME=/Applications/Arduino.app
export ARDUINO_PORT=COM3
```

test

```bash
export ARDUINO_HOME=/Applications/Arduino.app
export ARDUINO_PORT=COM3
```



<!--
private static var ARDUINO_HOME:String = "C:\\PROGRA~2\\Arduino";
private static var ARDUINO_HOME_OSX:String = "/Applications/Arduino.app/Contents/Java";
-->
