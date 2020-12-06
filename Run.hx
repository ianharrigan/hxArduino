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

        switch (command) {
            case 'install', '--install':
                runCommand("install", args);
                Sys.getChar(false);
            case 'monitor', '--monitor':
                runCommand("monitor", args);
            case '-p', 'portlist', '--portlist':
                runCommand("portlist", args);
            case 'test', '--test':
                runCommand("install", args);
                runCommand("monitor", args);
            case '-v', '--version', 'version':
                trace('Something clever, but not functional at this moment');
            case '-h', '--help', 'help':
                trace('');
                trace('[hxArduino] : custom haxe generator to create arduino specific c++');
                trace('');
                trace('Usage: haxelib run hxArduino [--install/--monitor/--test/--portlist/--help/--version] [-file FOO] [-port BAR]');
                trace('');
                trace('Optional arguments:');
                trace('     --install           Install Arduino code on device.');
                trace('     --monitor           Monitor ports.');
                trace('     --test              Install and monitor.');
                trace('     -p, --portlist      Get list of connected ports.');
                trace('     -h, --help          Show this help message and exit.');
                trace('     -v, --version       Show program\'s version number and exit.');
                trace('     -file               Install hexfile (no idea?).');
                trace('     -port               Port to use.');
                trace('     -speed              baudrate (default detecting by board code).');
                trace('     -boardcode          board code (atmega1284, etc).');
            default :
                trace("Unknown command '" + command + "'");
                trace("case '"+command+"': trace ('"+command+"');");
        }

        Sys.setCwd(cwd);
    }

    private static function runCommand(command:String, args:Array<String>) {
        if (command == "install") {
            var hexFile:String = extractArg(args, "-file");
            var port:String = extractArg(args, "-port");
            var speed:String = extractArg(args, "-speed");
            var boardcode:String = extractArg(args, "-boardcode");
            Installer.install(hexFile, port, Std.parseInt(speed), boardcode);
        } else if (command == "monitor") {
            var port:String = extractArg(args, "-port");
            var speed:String = extractArg(args, "-speed");
            var boardcode:String = extractArg(args, "-boardcode");
            Monitor.monitor(port, Std.parseInt(speed), boardcode);
        } else if (command == "portlist") {
            Monitor.portlist();
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