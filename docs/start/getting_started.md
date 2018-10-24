# Getting started



I am going to state the obvious here:

- [Install Haxe](https://haxe.org/download)
- [Install VS Code](https://code.visualstudio.com)
- [Install the Arduino IDE](https://www.arduino.cc/en/Main/Software)


## Step 1.

You need to install/download this project:

#### methode 1

use git:

`cd` to correct folder and check out project

```bash
cd path/to/folder
git checkout https://github.com/ianharrigan/hxArduino.git
```

#### methode 2

use haxelib:

```bash
haxelib git hxArduino https://github.com/ianharrigan/hxArduino.git
```


## Step 2.

You can use this git repos as a development directory:

```bash
haxelib dev hxArduino path/to/folder
```

## Step 3.


This project uses an extra lib ["hxSerial"](https://lib.haxe.org/p/hxSerial/), which can be install via Haxelib (the package manager for the Haxe Toolkit).

`haxelib install hxSerial`

or

`haxelib install build.hxml`

## Step 4.

Do the platform specific stuff:

* [Windows](start/windows.md)
* [OSX](start/osx.md)
* [Linux (needs love)](start/linux.md)



* `haxe -lib hxArduino -cp src -neko dummy.n -main Main`
	* (Need to use neko dummy output for now - not entirely sure why)
* `haxelib run hxArduino test C:\Temp\temp2\bin\generated`
	* Makes COM port assumption (needs to change!)
