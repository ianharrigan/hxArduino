package;

/*
import haxe.io.Eof;
import haxe.io.Input;
import neko.vm.Thread;
*/
import sys.io.Process;

class ProcessHelper {
    public function new() {
    }
    
    public function run(command:String, args:Array<String> = null):Int {
        if (args == null) {
            args = [];
        }
        
        var p = new Process(command, args);
        
        trace('${command} ${args.join(" ")}');
        
        /*
        var outThread = Thread.create(printStreamThread);
        outThread.sendMessage(p.stdout);
        
        var errThread = Thread.create(printStreamThread);
        errThread.sendMessage(p.stderr);
        */
        
        var n:Int = p.exitCode(true);
        
        
        var so = StringTools.replace(p.stdout.readAll().toString(), "\r\n", "\n");
        if (StringTools.trim(so).length > 0) {
            trace(StringTools.trim(so));
        }
        var se = StringTools.replace(p.stderr.readAll().toString(), "\r\n", "\n");
        if (StringTools.trim(se).length > 0) {
            trace(StringTools.trim(se));
        }
        
        //p.close();
        
        return n;
    }
    
    /*
    private function printStreamThread() {
        var stream:Input = Thread.readMessage(true);
        while (true) {
            try {
                var line = stream.readLine();
                trace(line);
            } catch (e:Eof) {
                break;
            } catch (e:Dynamic) {
                trace(e);
                break;
            }
        }
    }
    */
}