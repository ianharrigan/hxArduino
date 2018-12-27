package;

/**

	The microcontroller on the Arduino and Genuino AVR based board has EEPROM: memory whose values are kept when the board is turned off (like a tiny hard drive).
	This library enables you to read and write those bytes.

    @see https://www.arduino.cc/en/Reference/EEPROM
**/
@:include("EEPROM.h")
@:native("EEPROM")
extern class EEPROM {

	/**
		Reads a byte from the EEPROM.
	**/
	static function read( address : Int ) : Int;

	/**
		Write a byte to the EEPROM.
	**/
	static function write( address : Int, value : Int ) : Void;

	/**
		Write a byte to the EEPROM.
		The value is written only if differs from the one already saved at the same address.
	**/
	static function update( address : Int, value : Int ) : Void;

	/**
		Read any data type or object from the EEPROM.
	**/
	static function get( address : Int, data : Float ) : Void;

	/**
		Write any data type or object to the EEPROM.
	**/
	static function put( address : Int, data : Float ) : Void;

}
