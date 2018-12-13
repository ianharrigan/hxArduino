package;

/**
    Used for communication between the Arduino board and a computer or other devices.

    @see https://www.arduino.cc/reference/en/language/functions/communication/serial/
**/
@:include("Arduino.h")
@:native("Serial")
extern class Serial {

    public static inline var SERIAL_5N1 : Int = untyped "SERIAL_5N1";
    public static inline var SERIAL_6N1 : Int = untyped "SERIAL_6N1";
    public static inline var SERIAL_7N1 : Int = untyped "SERIAL_7N1";
    public static inline var SERIAL_8N1 : Int = untyped "SERIAL_8N1";
    public static inline var SERIAL_5N2 : Int = untyped "SERIAL_5N2";
    public static inline var SERIAL_6N2 : Int = untyped "SERIAL_6N2";
    public static inline var SERIAL_7N2 : Int = untyped "SERIAL_7N2";
    public static inline var SERIAL_8N2 : Int = untyped "SERIAL_8N2";
    public static inline var SERIAL_5E1 : Int = untyped "SERIAL_5E1";
    public static inline var SERIAL_6E1 : Int = untyped "SERIAL_6E1";
    public static inline var SERIAL_7E1 : Int = untyped "SERIAL_7E1";
    public static inline var SERIAL_8E1 : Int = untyped "SERIAL_8E1";
    public static inline var SERIAL_5E2 : Int = untyped "SERIAL_5E2";
    public static inline var SERIAL_6E2 : Int = untyped "SERIAL_6E2";
    public static inline var SERIAL_7E2 : Int = untyped "SERIAL_7E2";
    public static inline var SERIAL_8E2 : Int = untyped "SERIAL_8E2";
    public static inline var SERIAL_5O1 : Int = untyped "SERIAL_5O1";
    public static inline var SERIAL_6O1 : Int = untyped "SERIAL_6O1";
    public static inline var SERIAL_7O1 : Int = untyped "SERIAL_7O1";
    public static inline var SERIAL_8O1 : Int = untyped "SERIAL_8O1";
    public static inline var SERIAL_5O2 : Int = untyped "SERIAL_5O2";
    public static inline var SERIAL_6O2 : Int = untyped "SERIAL_6O2";
    public static inline var SERIAL_7O2 : Int = untyped "SERIAL_7O2";
    public static inline var SERIAL_8O2 : Int = untyped "SERIAL_8O2";

    public static inline var BIN : Int = untyped "BIN";
    public static inline var OCT : Int = untyped "OCT";
    public static inline var DEC : Int = untyped "DEC";
    public static inline var HEX : Int = untyped "HEX";

    /**
        Get the number of bytes (characters) available for reading from the serial port.
        This is data that’s already arrived and stored in the serial receive buffer (which holds 64 bytes). available() inherits from the Stream utility class.
    **/
    static function available() : Int;

    /**
        Get the number of bytes (characters) available for writing in the serial buffer without blocking the write operation.
    **/
    static function availableForWrite() : Int;

    /**
        Sets the data rate in bits per second (baud) for serial data transmission.
    **/
    static function begin( baud : Int, ?config : Int ) : Void;

    /**
        Disables serial communication, allowing the RX and TX pins to be used for general input and output.
        To re-enable serial communication, call `Serial.begin()`.
    **/
    static function end() : Void;

    /**
        Serial.find() reads data from the serial buffer until the target string of given length is found.
        The function returns `true` if target string is found, `false` if it times out.
    **/
    static function find( target : String ) : Int;

    /**
        Reads data from the serial buffer until a target string of given length or terminator string is found.
        The function returns `true` if the target string is found, `false` if it times out.
    **/
    static function findUntil( target : Int, terminal : Int ) : Int;

    /**
        Waits for the transmission of outgoing serial data to complete.
    **/
    static function flush() : Void;

    /**
        Returns the first valid floating point number from the Serial buffer.
    **/
    static function parseFloat() : Float;

    /**
        Looks for the next valid integer in the incoming stream.
    **/
    static function parseInt( ?skipChar : Int ) : Int;

    /**
        Returns the next byte (character) of incoming serial data without removing it from the internal serial buffer.
    **/
    static function peek() : Int;

    /**
        Prints data to the serial port as human-readable ASCII text.
    **/
    @:overload(function( val : String, ?format : Int) : Int {})
    @:overload(function( val : Float, ?format : Int) : Int {})
    static function print( val : Int, ?format : Int ) : Int;

    /**
        Prints data to the serial port as human-readable ASCII text followed by a carriage return character (ASCII 13, or '\r') and a newline character (ASCII 10, or '\n').
    **/
    @:overload(function( val : String, ?format : Int) : Int {})
    @:overload(function( val : Float, ?format : Int) : Int {})
    static function println( val : Int, ?format : Int ) : Int;

    /**
        Reads incoming serial data.
        Returns the first byte of incoming serial data available (or -1 if no data is available)
    **/
    static function read() : Int;

    /**
        Reads characters from the serial port into a buffer.
        The function terminates if the determined length has been read, or it times out (see `Serial.setTimeout()`).
    **/
    //TODO static function readBytes( buffer, length : Int ) : Int;

    /**
    **/
    //TODO static function readBytesUntil() : Int;

    /**
        Reads characters from the serial buffer into a string.
        The function terminates if it times out (see `setTimeout()`).
    **/
    static function readString() : String;

    /**
        Reads characters from the serial buffer into a string.
        The function terminates if it times out (see `setTimeout()`).
    **/
    static function readStringUntil( terminator : Int ) : String;

    /**
        Sets the maximum milliseconds to wait for serial data when using serial.readBytesUntil() or serial.readBytes().
        It defaults to 1000 milliseconds.
    **/
    static function setTimeout( time : Float ) : Void;

    /**
        Writes binary data to the serial port.
        This data is sent as a byte or series of bytes; to send the characters representing the digits of a number use the `print()` function instead.
    **/
    @:overload(function( val : Int, len : Int ) : Int {})
    @:overload(function( val : String ) : Int {})
    static function write( val : Int ) : Int;
}
