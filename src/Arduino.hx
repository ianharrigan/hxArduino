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
    //TODO

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
    //TODO

    // --- External Interrupts
    //TODO

    // --- Interrupts
    //TODO

    // --- Communication
    //TODO

    // --- USB
    //TODO

}
