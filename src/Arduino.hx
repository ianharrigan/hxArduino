package;

/**
    @see https://www.arduino.cc/reference/en/
**/
@:include("Arduino.h")
extern class Arduino {

    public static inline var LED_BUILTIN:Int = untyped 'LED_BUILTIN';

    public static inline var A0:Int = untyped 'A0';
    public static inline var A1:Int = untyped 'A1';
    public static inline var A2:Int = untyped 'A2';
    public static inline var A3:Int = untyped 'A3';
    public static inline var A4:Int = untyped 'A4';
    public static inline var A5:Int = untyped 'A5';
    public static inline var A6:Int = untyped 'A6';
    public static inline var A7:Int = untyped 'A7';

    public static inline var INPUT:Int = untyped 'INPUT';
    public static inline var OUTPUT:Int = untyped 'OUTPUT';

    public static inline var HIGH:Int = untyped 'HIGH';
    public static inline var LOW:Int = untyped 'LOW';

    public static inline var MSBFIRST : Int = untyped 'MSBFIRST';
    public static inline var LSBFIRST : Int = untyped 'LSBFIRST';

    // --- Digital I/O

    /**
        Reads the value from a specified digital pin, either `HIGH` or `LOW`
    **/
    static function digitalRead( pin : Int ) : Int;

    /**
        Write a `HIGH` or a `LOW` value to a digital pin.
    **/
    static function digitalWrite( pin : Int, value : Int ) : Void;

    /**
        Configures the specified pin to behave either as an input or an output.
    **/
    static function pinMode( pin : Int, mode : Int ) : Void;

    // --- Analog I/O

    /**
        Reads the value from the specified analog pin.
    **/
    static function analogRead( pin : Int ) : Int;

    /**
        Configures the reference voltage used for analog input (i.e. the value used as the top of the input range)
    **/
    static function analogReference( type : Int ) : Void;

    /**
        Writes an analog value (PWM wave) to a pin.
    **/
    static function analogWrite( pin : Int, value : Int ) : Void;

    // --- Zero, Due & MKR Family
    //TODO

    // --- Advanced I/O

    /**
        Stops the generation of a square wave triggered by `tone()`.
    **/
    static function noTone( pin : Int ) : Void;

    /**
        Reads a pulse (either `HIGH` or `LOW`) on a pin.
    **/
    static function pulseIn( pin : Int, value : Int, timeout : Int ) : Float;

    /**
        Alternative to pulseIn() which is better at handling long pulse and interrupt affected scenarios.
    **/
    static function pulseInLong( pin : Int, value : Int, ?timeout : Int ) : Float;

    /**
        Shifts in a byte of data one bit at a time.
    **/
    static function shiftIn( dataPin : Int, clockPin : Int, bitOrder : Int ) : Int;

    /**
        Shifts out a byte of data one bit at a time.
    **/
    static function shiftOut( dataPin : Int, clockPin : Int, bitOrder : Int, value : Int ) : Void;

    /**
        Shifts out a byte of data one bit at a time.
    **/
    static function tone( pin : Int, frequency : Int, ?duration : Float ) : Void;

    // --- Time

    /**
        Pauses the program for the amount of time (in milliseconds).
    **/
    static function delay( ms : Int ) : Void;

    /**
        Pauses the program for the amount of time (in microseconds).
    **/
    static function delayMicroseconds( us : Int ) : Void;

    /**
        Returns the number of microseconds since the Arduino board began running the current program.
    **/
    static function micros() : Float;

    /**
        Returns the number of milliseconds since the Arduino board began running the current program.
    **/
    static function millis() : Float;

    // --- Math

    /**
        Calculates the absolute value of a number.
    **/
    static function abs( x : Float ) : Float;

    /**
        Constrains a number to be within a range.
    **/
    static function constrain( x : Float, a : Float, b : Float ) : Float;

    /**
        Re-maps a number from one range to another.
    **/
    static function map( value:Int, fromLow:Int, fromHigh:Int, toLow:Int, toHigh:Int):Int;

    /**
        Calculates the maximum of two numbers.
    **/
    static function max( x : Float, y : Float ) : Float;

    /**
        Calculates the minimum of two numbers.
    **/
    static function min( x : Float, y : Float ) : Float;

    /**
        Calculates the value of a number raised to a power.
    **/
    static function pow( base : Float, exponent : Float ) : Float;

    /**
        Calculates the square of a number: the number multiplied by itself.
    **/
    static function sq( x : Float ) : Float;

    /**
        Calculates the square root of a number.
    **/
    static function sqrt( x : Float ) : Float;

    // --- Trigonometry

    /**
        Calculates the cosine of an angle (in radians).
    **/
    static function cos( rad : Float ) : Float;

    /**
        Calculates the sine of an angle (in radians).
    **/
    static function sin( rad : Float ) : Float;

    /**
        Calculates the tangent of an angle (in radians).
    **/
    static function tan( rad : Float ) : Float;

    // --- Characters

    /**
        Analyse if a char is alpha (that is a letter).
        Returns true if `thisChar` contains a letter.
    **/
    static function isAlpha( thisChar : Int ) : Int;

    /**
        Analyse if a char is alphanumeric (that is a letter or a numbers).
        Returns true if `thisChar` contains either a number or a letter.
    **/
    static function isAlphaNumeric( thisChar : Int ) : Int;

    /**
        Analyse if a char is Ascii.
        Returns true if `thisChar` contains an Ascii character.
    **/
    static function isAscii( thisChar : Int ) : Int;

    /**
        Analyse if a char is a control character.
        Returns true if `thisChar` contains is a control character.
    **/
    static function isControl( thisChar : Int ) : Int;

    /**
        Analyse if a char is a digit.
        Returns true if `thisChar` is a number.
    **/
    static function isDigit( thisChar : Int ) : Int;

    /**
        Analyse if a char is printable with some content (space is printable but has no content).
        Returns true if `thisChar` is printable.
    **/
    static function isGraph( thisChar : Int ) : Int;

    /**
        Analyse if a char is an hexadecimal digit (A-F, 0-9).
        Returns true if `thisChar` contains an hexadecimal digit.
    **/
    static function isHexadecimalDigit( thisChar : Int ) : Int;

    /**
        Analyse if a char is lower case (that is a letter in lower case).
        Returns true if `thisChar` contains a letter in lower case.
    **/
    static function isLowerCase( thisChar : Int ) : Int;

    /**
        Analyse if a char is printable (that is any character that produces an output, even a blank space).
        Returns true if `thisChar` is printable.
    **/
    static function isPrintable( thisChar : Int ) : Int;

    /**
        Analyse if a char is punctuation (that is a comma, a semicolon, an exlamation mark and so on).
        Returns true if `thisChar` is punctuation.
    **/
    static function isPunct( thisChar : Int ) : Int;

    /**
        Analyse if a char is the space character.
        Returns true if `thisChar` contains the space character.
    **/
    static function isSpace( thisChar : Int ) : Int;

    /**
        Analyse if a char is upper case (that is, a letter in upper case).
        Returns true if `thisChar` is upper case.
    **/
    static function isUpperCase( thisChar : Int ) : Int;

    /**
        Analyse if a char is a white space, that is space, formfeed ('\f'), newline ('\n'), carriage return ('\r'), horizontal tab ('\t'), and vertical tab ('\v')).
        Returns true if `thisChar` contains a white space.
    **/
    static function isWhitespace( thisChar : Int ) : Int;

    // --- Random Numbers

    /**
        Generates pseudo-random numbers.
    **/
    @:overload(function(min:Float,max:Float):Float{})
    static function random( max : Float ) : Float;

    /**
        Initializes the pseudo-random number generator.
    **/
    static function randomSeed( max : Float ) : Void;

    // --- Bits and Bytes

    /**
        Computes the value of the specified bit (bit 0 is 1, bit 1 is 2, bit 2 is 4, etc.).
    **/
    static function bit( n : Int ) : Int;

    /**
        Clears (writes a 0 to) a bit of a numeric variable.
    **/
    static function bitClear( x : Int, n : Int ) : Void;

    /**
        Reads a bit of a number.
    **/
    static function bitRead( x : Int, n : Int ) : Int;

    /**
        Sets (writes a 1 to) a bit of a numeric variable.
    **/
    static function bitSet( x : Int, n : Int ) : Void;

    /**
        Writes a bit of a numeric variable.
    **/
    static function bitWrite( x : Int, n : Int ) : Void;

    /**
        Extracts the high-order (leftmost) byte of a word (or the second lowest byte of a larger data type).
    **/
    static function highByte( x : Int ) : Int;

    /**
        Extracts the low-order (rightmost) byte of a variable (e.g. a word).
    **/
    static function lowByte( x : Int ) : Int;

    // --- External Interrupts

    /**
    **/
    //TODO static function attachInterrupt();

    /**
        Turns off the given interrupt.
    **/
    //TODO static function detachInterrupt() : Void;

    // --- Interrupts

    /**
        Re-enables interrupts.
    **/
    static function interrupts() : Void;

    /**
        Disables interrupts.
    **/
    static function noInterrupts() : Void;

}
