package;
import ast2obj.builders.Installer;
import ast2obj.builders.Monitor;

class Run {
    public static function main() {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { 
          Sys.println(v);
        }
        
        if (Sys.args().length < 2) {
            trace("Not enough args");
            return;
        }
        
        var args = Sys.args();
        var command = args.shift();
        var dir = args.pop();

        var cwd = Sys.getCwd();
        Sys.setCwd(dir);
        
        if (command == "install") {
            runCommand("install", args);
            Sys.getChar(false);
        } else if (command == "monitor") {
            runCommand("monitor", args);
        } else if (command == "run") {
            runCommand("install", args);
            runCommand("monitor", args);
        } else {
            trace("Unknown command '" + command + "'");
        }
        
        Sys.setCwd(cwd);
    }
    
    private static function runCommand(command:String, args:Array<String>) {
        if (command == "install") {
            var hexFile:String = extractArg(args, "-file");
            var port:String = extractArg(args, "-port");
            Installer.install(hexFile, port);
        } else if (command == "monitor") {
            var port:String = extractArg(args, "-port");
            Monitor.monitor(port);
        }
    }
    
    public static function extractArg(args:Array<String>, name:String):String {
        var v = null;
        for (i in 0...args.length) {
            if (args[i] == name) {
                v = args[i + 1];
                break;
            }
        }
        return v;
    }
}