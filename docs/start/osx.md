# hxArduino on OSX

Make sure you followed the [Getting Started](getting_started.md) instructions first.

## Environment variable

Normally if you follow the install instructions, you will install Arduino into `~/Applications` folder

If you did that, this app will run smooth!



Otherwise you need to set some environment variable

```bash
ARDUINO_HOME=/NotApplications/Arduino.app/Contents/Java
```
(default: `/Applications/Arduino.app/Contents/Java`)

You can also set the port of the serial device

```bash
ARDUINO_PORT=/dev/cu.usbmodem14101
```
(default: `COM3` which will never work!)

Forgot how to? Check [How to set environment variable](osx.md?id=how-to-set-environment-variable)


## Find Arduino Port

Find Port Number on Macintosh
Open terminal and type: `ls /dev/*`.

Note the port number listed for `/dev/tty.usbmodem*` or `/dev/tty.usbserial*`. The port number is represented with `*` here.

For example: `/dev/ttyUSB0`.

Or use build in tool:

`haxelib run hxArduino --portlist`

Possible answer **without** an Arduino connected to your computer:

```bash
Port list: [/dev/cu.Bluetooth-Incoming-Port,/dev/tty.Bluetooth-Incoming-Port]
        - port: /dev/cu.Bluetooth-Incoming-Port, available: 0,
        - port: /dev/tty.Bluetooth-Incoming-Port, available: 0, null
Your guess is as good as mine; try to disconnect and run this command again and see the differences
```

Possible answer **with** an Arduino connected to your computer:

```bash
Port list: [/dev/cu.Bluetooth-Incoming-Port,/dev/tty.Bluetooth-Incoming-Port,/dev/cu.usbmodem14101,/dev/tty.usbmodem14101]
        - port: /dev/cu.Bluetooth-Incoming-Port, available: 0,
        - port: /dev/tty.Bluetooth-Incoming-Port, available: 0, null
        - port: /dev/cu.usbmodem14101, available: 11,
        - port: /dev/tty.usbmodem14101, available: 0, null
Use: haxelib run hxArduino --test -port /dev/cu.usbmodem14101
```

## How to set environment variable

#### Methode 1:

To set an environment variable, enter the following command:

```bash
launchctl setenv variable "value"
```

To find out if an environment variable is set, use the following command:

```bash
launchctl getenv variable
```

To clear an environment variable, use the following command:

```bash
launchctl unsetenv variable
```

#### Methode 2:


Write bash_profile


```bash
~/.bash_profile
nano .bash_profile
export ARDUINO_HOME=/Applications/Arduino.app/Contents/Java
export ARDUINO_PORT=/dev/cu.usbmodem14101
```

Or just test it:

```bash
export ARDUINO_HOME=/Applications/Arduino.app/Contents/Java
export ARDUINO_PORT=/dev/cu.usbmodem14101
```



Source:

- <https://www.schrodinger.com/kb/1842>
- <http://osxdaily.com/2015/07/28/set-enviornment-variables-mac-os-x/>


