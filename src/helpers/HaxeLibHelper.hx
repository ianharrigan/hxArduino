package helpers;

import sys.io.Process;

class HaxeLibHelper {
    public static function getLibPath(lib:String):String { // pretty crappy way to do it i guess
        var path = null;
        
        var p = new Process("haxelib list");
        var output = p.stdout.readAll().toString();
        p.close();
        
        for (line in output.split("\n")) {
            line = StringTools.trim(line);
            if (line.length == 0 || StringTools.startsWith(line, lib) == false) {
                continue;
            }
            
            var versions = line.split(" ");
            versions.shift();
            for (v in versions) {
                if (StringTools.startsWith(v, "[") && StringTools.endsWith(v, "]")) {
                    path = v.substr(1, v.length - 2);
                    if (StringTools.startsWith(path, "dev:")) {
                        path = path.substr(4, path.length);
                    } else {
                        path = getLibPathAlt(lib);
                    }
                    
                    break;
                }
            }
        }
        
        return path;
    }
    
    private static function getLibPathAlt(lib:String):String {
        var path = null;

        var p = new Process("haxelib path " + lib);
        var output = p.stdout.readAll().toString();
        p.close();
        
        for (line in output.split("\n")) {
            line = StringTools.trim(line);
            if (line.length == 0 || StringTools.startsWith(line, "-") || StringTools.startsWith(line, "#")) {
                continue;
            }
            
            path = line;
        }
        
        return path + "..";
    }
    
    public static function hasLib(lib:String):Bool {
        return (getLibPath(lib) != null);
    }
}
