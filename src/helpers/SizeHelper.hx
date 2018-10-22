package helpers;

import sys.io.Process;

class SizeHelper {
    private var _out:String;
    public function new(command:String, args:Array<String>) {
        if (args == null) {
            args = [];
        }
        
        trace('${command} ${args.join(" ")}');
        var p = new Process('${command} ${args.join(" ")}');
        p.exitCode(true);
        
        var so = StringTools.replace(p.stdout.readAll().toString(), "\r\n", "\n");
        if (StringTools.trim(so).length > 0) {
            _out = StringTools.trim(so);
        }
    }
    
    public function displayStats() {
        if (_out == null) {
            return;
        }
        
        var lines = _out.split("\n");
        var data:Int = 0;
        var text:Int = 0;
        var bss:Int = 0;
        
        // UNO sizes:
        var program_storage_max:Int = 32256;
        var global_max:Int = 2048;
        // METRO sizes:
        // var program_storage_max:Int = 524288;
        // var global_max:Int = 196608;
        
        for (l in lines) {
            l = StringTools.trim(l);
            if (StringTools.startsWith(l, ".data")) {
                data = extractStat(StringTools.replace(l, ".data", ""));
            } else if (StringTools.startsWith(l, ".text")) {
                text = extractStat(StringTools.replace(l, ".text", ""));
            } else if (StringTools.startsWith(l, ".bss")) {
                bss = extractStat(StringTools.replace(l, ".bss", ""));
            }
        }
        
        trace(_out);
        
        var program_storage_used = (text / program_storage_max) * 100;
        trace("\nProgram storage usage: " + Math.fround(program_storage_used) + "%");
        var global_storage_used = ((data + bss) / global_max) * 100;
        trace("Global variable usage: " + Math.fround(global_storage_used) + "%\n");
    }
    
    private function extractStat(l:String):Int {
        l = StringTools.trim(l);
        var x:String = l.split(" ")[0];
        
        return Std.parseInt(x);
    }
}
