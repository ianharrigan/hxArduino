package ast2obj.builders;

class Monitor {
    public static function monitor(port:String = null) {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { 
          Sys.println(v);
        }
        
        if (Sys.getEnv("ARDUINO_PORT") != null && port == null) {
            port = Sys.getEnv("ARDUINO_PORT");
        }
        if (port == null) {
            port = "COM3";
        }
        
        trace("Starting serial monitor on " + port);
        #if !neko
        
        trace("Cant monitor - not neko");
        
        #else
        
        trace("Port list: " + hxSerial.Serial.getDeviceList());
        var serialObj = new hxSerial.Serial(port, 115200);
        serialObj.setup();
        
        while (true) {
            var i = serialObj.available();
            var s = serialObj.readBytes(i);
            neko.Lib.print(s);
            Sys.sleep(0.01);
        }
        
        trace("Closing");
        serialObj.close();
        
        
        #end
    }
}