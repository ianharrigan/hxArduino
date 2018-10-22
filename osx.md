

## hxArduino on OSX

- [Haxe](https://haxe.org/download/file/3.4.7/haxe-3.4.7-osx-installer.pkg/)
- [VS Code for Mac](https://code.visualstudio.com/docs/?dv=osx)
- [Download the Arduino IDE](https://www.arduino.cc/en/Main/Software)




## todo






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

