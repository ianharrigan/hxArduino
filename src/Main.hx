package;

class Main {
	static function main() {
        var cmd = Sys.args()[0];
        var dir = Sys.args()[1];
        trace("CWD: " + Sys.getCwd());
        trace("cmd: " + cmd);
        trace("dir: " + dir);
        
        if (cmd == "test") {
            Compiler.compile(dir, false, true, true);
        }
	}
}
