
import haxe.extern.EitherType;
import HID;

/**
	The mouse functions enable 32u4 or SAMD micro based boards to control cursor movement on a connected computer through their micro’s native USB port.
	When updating the cursor position, it is always relative to the cursor’s previous location.

	@see https://www.arduino.cc/reference/en/language/functions/usb/mouse/
**/
@:include("Mouse.h")
@:native("Mouse")
extern class Mouse {

	public static inline var MOUSE_LEFT : Int = untyped 'MOUSE_LEFT';
	public static inline var MOUSE_RIGHT : Int = untyped 'MOUSE_RIGHT';
	public static inline var MOUSE_MIDDLE : Int = untyped 'MOUSE_MIDDLE';

	/**
		Begins emulating the mouse connected to a computer.
	**/
	static function begin() : Void;

	/**
		Sends a momentary click to the computer at the location of the cursor.
	**/
	static function click( ?button : Int ) : Void;

	/**
		Stops emulating the mouse connected to a computer.
	**/
	static function end() : Void;

	/**
		Moves the cursor on a connected computer.
	**/
	static function move( xVal : Int, yPos : Int, wheel : Int ) : Void;

	/**
		Sends a button press to a connected computer.
	**/
	static function press( ?button : Int ) : Void;

	/**
		Sends a message that a previously pressed button.
	**/
	static function release( ?button : Int ) : Void;

	/**
		Checks the current status of all mouse buttons, and reports if any are pressed or not.
	**/
	static function isPressed( ?button : Int ) : Int;

}
