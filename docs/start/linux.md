# hxArduino on Linux

Make sure you followed the [Getting Started](start/getting_started.md) instructions first.

**This needs more love**


## Environment variable

**Yes! you guessed it, we don't have a clue**

If you could point us to the correct direction, create an [issue](https://github.com/ianharrigan/hxArduino/issues).
Even better would be a pull request!

## Find Arduino Port

Find Port Number on Linux
Open terminal and type: `ls /dev/tty*.`

Note the port number listed for `/dev/ttyUSB*` or `/dev/ttyACM*`. The port number is represented with `*` here.

For example: `/dev/ttyUSB0`.


Or use build in tool:

`haxelib run hxArduino --portlist`