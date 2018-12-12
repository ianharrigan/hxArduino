
import haxe.extern.EitherType;

/**
	The keyboard functions enable 32u4 or SAMD micro based boards to send keystrokes to an attached computer through their micro’s native USB port.

	@see https://www.arduino.cc/reference/en/language/functions/usb/keyboard/
**/
@:include("Keyboard.h")
@:native("Keyboard")
extern class Keyboard {

	/**
		When used with a Leonardo or Due board, Keyboard.begin() starts emulating a keyboard connected to a computer.
	**/
	static function begin() : Void;

	/**
		Stops the keyboard emulation to a connected computer.
	**/
	static function end() : Void;

	/**
		When called, Keyboard.press() functions as if a key were pressed and held on your keyboard.
	**/
	static function press( c : EitherType<Int,String> ) : Void;

	/**
		Sends a keystroke to a connected computer.
	**/
	static function print( c : EitherType<Int,String> ) : Int;

	/**
		Sends a keystroke to a connected computer.
	**/
	static function println( c : EitherType<Int,String> ) : Int;

	/**
		Lets go of the specified key.
	**/
	static function release( c : EitherType<Int,String> ) : Int;

	/**
		Lets go of all keys currently pressed.
	**/
	static function releaseAll() : Void;

	/**
		Sends a keystroke to a connected computer.
	**/
	static function write( c : EitherType<Int,String> ) : Int;

}
