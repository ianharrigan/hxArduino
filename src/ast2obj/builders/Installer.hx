package ast2obj.builders;
import firmware.hardware.MCU.MCUProvider;
import haxe.io.Path;
import helpers.ProcessHelper;
import helpers.SizeHelper;

class Installer {
    private static var ARDUINO_HOME:String = "C:\\PROGRA~2\\Arduino";
    private static var ARDUINO_HOME_OSX:String = "/Applications/Arduino.app/Contents/Java";

    private static var DUDE:String = '%ARDUINO_HOME%/hardware/tools/avr/bin/avrdude';
    private static var SIZE:String = '%ARDUINO_HOME%/hardware/tools/avr/bin/avr-size';

    public static function install(hexFile:String, ?port: String = null, ?speed: Null<Int> = null) {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) {
          Sys.println(v);
        }

        if (Sys.getEnv("ARDUINO_HOME") != null) {
            ARDUINO_HOME = Sys.getEnv("ARDUINO_HOME");
        } else if (Sys.systemName() == "Mac") {
            ARDUINO_HOME = ARDUINO_HOME_OSX;
        }
        var board_code = Sys.getEnv("TARGET_BOARD");
        if (board_code == null) {
            trace("Error, set env TARGET_BOARD.");
            return;
        }
        var board = MCUProvider.byCode(board_code);

        if (board == null) {
            trace('Error, board "$board_code" is not support.');
            return;
        }

        if (speed == null) {
            speed = board.UploadingSpeed;
        }

        if (hexFile == null) {
            hexFile = Sys.getCwd() + "/build/hxArduino/out/MyApp.hex";
        }

        expandVars();
        hexFile = Path.normalize(hexFile);

        if (Sys.getEnv("ARDUINO_PORT") != null && port == null) {
            port = Sys.getEnv("ARDUINO_PORT");
        }
        if (port == null) {
            trace("Error, provide 'ARDUINO_PORT' env or '-port' argument.");
            return;
        }

        trace("Installing: " + hexFile + " via " + port);
        var params:Array<String> = '-C${ARDUINO_HOME}/hardware/tools/avr/etc/avrdude.conf -v -p${board_code} -carduino -P${port} -b${speed} -D'.split(" ");
        params.push('-Uflash:w:${hexFile}:i');
        var n = new ProcessHelper().run(DUDE, params);
        if (n != 0) {
            trace("INSTALL FAILED!");
            Sys.getChar(false);
            return;
        }

        /////////////////////////////////////////////////////////////////////////////
        // SIZE
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = "-A".split(" ");
        params.push(Path.normalize('${StringTools.replace(hexFile, ".hex", ".elf")}'));
        var sizeHelper = new SizeHelper(Path.normalize(SIZE), params);
        sizeHelper.displayStats();
    }

    private static function expandVars() {
        DUDE = StringTools.replace(DUDE, "%ARDUINO_HOME%", ARDUINO_HOME);
        SIZE = StringTools.replace(SIZE, "%ARDUINO_HOME%", ARDUINO_HOME);
    }
}