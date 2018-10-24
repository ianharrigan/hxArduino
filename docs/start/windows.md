# hxArduino on Windows

Make sure you followed the [Getting Started](start/getting_started.md) instructions first.

## Environment variable

To get the project working you need to set some environment variable

```bash
ARDUINO_HOME=C:\\path\\to\\arduino
```
(default: `C:\\PROGRA~2\\Arduino`)

You can also set the port of the serial device

```bash
ARDUINO_PORT=COM6
```
(default: `COM3`)


## Find Arduino Port

Find Port Number on Windows

- Open Device Manager, and expand the Ports (COM & LPT) list.
- Note the number on the USB Serial Port.


Or use build in tool:

`haxelib run hxArduino --portlist`

