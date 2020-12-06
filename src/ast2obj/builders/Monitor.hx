package ast2obj.builders;

import firmware.hardware.MCU.MCUProvider;

class Monitor {
    public static function portlist() {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) {
          Sys.println(v);
        }
        #if hxSerial
        var list = hxSerial.Serial.getDeviceList();
        trace("Port list: " + list);
        var useport = '';
        for (port in list){
            var serialObj = new hxSerial.Serial(port, 115200);
            serialObj.setup();

            var i = serialObj.available();
            var s = serialObj.readBytes(i);
            neko.Lib.println ('\t- port: $port, available: $i, $s');
            if(i>0) useport = port;
        }
        if(useport != ''){
            trace('Use: haxelib run hxArduino --test -port $useport'); // I am guessing here, but it seems to work on osx
        } else {
            trace('Your guess is as good as mine; try to disconnect and run this command again and see the differences');
        }
        #else
        trace("No hxSerial");
        #end

    }
    public static function monitor(port:String = null, speed: Null<Int>, ?board_code: String = null) {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) {
          Sys.println(v);
        }

        #if hxSerial

        if (Sys.getEnv("ARDUINO_PORT") != null && port == null) {
            port = Sys.getEnv("ARDUINO_PORT");
        }
        if (port == null) {
            trace("Error, provide 'ARDUINO_PORT' env or '-port' argument.");
            return;
        }

        if (speed == null) {
            if (board_code == null) {
                board_code = Sys.getEnv("TARGET_BOARD");
                if (board_code == null) {
                    trace("Error, provide 'TARGET_BOARD' env or '-boardcode' argument.");
                    return;
                }
            }
            var board = MCUProvider.byCode(board_code);
            if (board == null) {
                trace("cannot detect baudrate for connecting to serialport.");
                trace("Provide '-speed' argument or set 'TARGET_BOARD' env.");
                return;
            }
            speed = board.UploadingSpeed;
        }

        trace('Starting serial monitor on "$port" and "$speed" baudrate.');
        trace("Port list: " + hxSerial.Serial.getDeviceList());

        var serialObj = new hxSerial.Serial(port, speed);
        serialObj.setup();

        while (true) {
            var i = serialObj.available();
            var s = serialObj.readBytes(i);
            neko.Lib.print(s);
            Sys.sleep(0.01);
        }

        trace("Closing");
        serialObj.close();

        #else

        trace("No hxSerial");

        #end
    }
}