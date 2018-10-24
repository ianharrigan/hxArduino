# Getting started

Please remember this is work in progress, and this documentation can change and/or not even reflect the current state.

But also remember, nobody writes documentation just to send you on a wild goose chase.

Also this document assumes a lot:

- knowledge of Haxe
- knowledge of Arduino
- how to use a terminal
- possession of a Arduino and the correct cables to connect
- probably a lot more...

## Step 0.

I am going to state the obvious here:

- [Install Haxe](https://haxe.org/download)
- [Install VS Code](https://code.visualstudio.com)
- [Install the Arduino IDE](https://www.arduino.cc/en/Main/Software)



## Step 1.

You need to install/download this project:

#### Methode 1:

Use git to download this project:

`cd` to correct folder and check out project

```bash
cd path/to/folder
git checkout https://github.com/ianharrigan/hxArduino.git
```

#### Methode 2:

Use haxelib to download this project:

```bash
haxelib git hxArduino https://github.com/ianharrigan/hxArduino.git
```


## Step 2.

You can use this git repos as a development directory:

```bash
haxelib dev hxArduino path/to/folder
```

## Step 3.


This project uses an extra lib "[hxSerial](https://lib.haxe.org/p/hxSerial/)", which can be install via Haxelib (the package manager for the Haxe Toolkit).

`haxelib install hxSerial`

or

`haxelib install build.hxml`

## Step 4.

Set Environment variable, this is platform specific:

- set `ARDUINO_HOME`
- optional set `ARDUINO_PORT`

Check out platform specific information:

* [Windows](start/windows.md?id=environment-variable)
* [OSX](start/osx.md?id=environment-variable)
* [Linux (needs love)](start/linux.md?id=environment-variable)


## Step 5.

Create a project you want to upload to your Arduino.

Check the [Example folder](https://github.com/ianharrigan/hxArduino/tree/master/examples)

Do you need more info, check out [Blink Example](example/blink.md)


## Step 6.

> Run commands


Install Arduino code on device.
`haxelib run hxArduino --install -port /dev/cu.usbmodem14101`

Monitor ports.
`haxelib run hxArduino --monitor -port /dev/cu.usbmodem14101`

Install and monitor.
`haxelib run hxArduino --test -port /dev/cu.usbmodem14101`

Get list of connected ports.
`haxelib run hxArduino --portlist`

Show this help message and exit.
`haxelib run hxArduino --help`



## ???


* `haxe -lib hxArduino -cp src -neko dummy.n -main Main`
	* (Need to use neko dummy output for now - not entirely sure why)
* `haxelib run hxArduino test C:\Temp\temp2\bin\generated`
	* Makes COM port assumption (needs to change!)
