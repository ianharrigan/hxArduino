package ast2obj.builders;
import haxe.io.Path;
import helpers.FileHelper;
import helpers.ProcessHelper;
import helpers.SizeHelper;
import sys.FileSystem;

class Compiler {
    private static var ARDUINO_HOME:String = "C:\\PROGRA~2\\Arduino";
    private static var ARDUINO_HOME_OSX:String = "/Applications/Arduino.app/Contents/Java";
    
    private static var GCC:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-gcc';
    private static var GCCPP:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-g++';
    private static var GCC_AR:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-gcc-ar';
    private static var OBJCOPY:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-objcopy';
    private static var SIZE:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-size';
    
    private static var STD_INCLUDES:Array<String> = [
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\variants\\standard"
    ];
    
    private static var ASM_CORE:Array<String> = [
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring_pulse.S"
    ];

    private static var C_CORE:Array<String> = [
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring_shift.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring_pulse.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring_digital.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\WInterrupts.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring_analog.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\wiring.c",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\hooks.c"
    ];

    private static var CPP_CORE:Array<String> = [
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\CDC.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\new.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\Tone.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\PluggableUSB.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\IPAddress.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\Print.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial2.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\abi.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial1.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\Stream.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial0.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial3.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\WString.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\WMath.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\USBCore.cpp"
    ];
    
    private static var CPP_FLAGS:String = "-c -w -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var ASM_FLAGS:String = "-c -x assembler-with-cpp -flto -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var C_FLAGS:String = "-c -Os -Wall -Wextra -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var LINK_FLAGS:String = "-Wall -Wextra -Os -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p";
    
    private static var NAME:String = "MyApp";
    
    public static function compile(srcPath:String, includePath:String, outPath:String, libraries:Array<String> = null) {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { 
          Sys.println(v);
        }
        
        if (libraries == null) {
            libraries = [];
        }
        
        if (Sys.getEnv("ARDUINO_HOME") != null) {
            ARDUINO_HOME = Sys.getEnv("ARDUINO_HOME");
        } else if (Sys.systemName() == "Mac") {
            ARDUINO_HOME = ARDUINO_HOME_OSX;
        }
        
        STD_INCLUDES.push(includePath);
        
        FileSystem.createDirectory(outPath);
        FileSystem.createDirectory(Path.normalize(outPath + "/core"));
        NAME = "MyApp"; // TODO: better way / name / does it matter?
        
        expandVars();
        
        /////////////////////////////////////////////////////////////////////////////
        // LIBRARIES
        /////////////////////////////////////////////////////////////////////////////
        for (l in libraries) {
            if (FileSystem.exists(Path.normalize('${ARDUINO_HOME}/libraries/${l}/src'))) {
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}/src', srcPath, "cpp");
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}/src', includePath, "h");
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}/src', includePath, "c");
            } else if (FileSystem.exists(Path.normalize('${ARDUINO_HOME}/libraries/${l}'))) {
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}', srcPath, "cpp");
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}', includePath, "h");
                FileHelper.copyFiles('${ARDUINO_HOME}/libraries/${l}', includePath, "c");
            } else if (FileSystem.exists(Path.normalize('${ARDUINO_HOME}/hardware/arduino/avr/libraries/${l}/src'))) {
                FileHelper.copyFiles('${ARDUINO_HOME}/hardware/arduino/avr/libraries/${l}/src', srcPath, "cpp");
                FileHelper.copyFiles('${ARDUINO_HOME}/hardware/arduino/avr/libraries/${l}/src', includePath, "h");
                FileHelper.copyFiles('${ARDUINO_HOME}/hardware/arduino/avr/libraries/${l}/src', includePath, "c");
            }
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // COMPILATION
        /////////////////////////////////////////////////////////////////////////////
        var cppFiles = [];
        FileHelper.findFiles(srcPath, "cpp", cppFiles);
        if (cppFiles.length == 0) {
            trace("NOTHING TO COMPILE!");
            return;
        }
        
        var compilationFailed:Bool = false;
        for (cppFile in cppFiles) {
            var params:Array<String> = CPP_FLAGS.split(" ");
            
            for (include in STD_INCLUDES) {
                params.push(Path.normalize('-I${include}'));
            }
            
            params.push(Path.normalize('${cppFile}'));
            params.push('-o');
            params.push(Path.normalize('${outPath}/${fileName(cppFile)}.o'));
            var n = new ProcessHelper().run(Path.normalize(GCCPP), params);
            if (n != 0) {
                compilationFailed = true;
                break;
            }
        }
        
        if (compilationFailed == true) {
            trace("COMPILATION FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // ASM CORE
        /////////////////////////////////////////////////////////////////////////////
        compilationFailed = false;
        for (asmFile in ASM_CORE) {
            var params:Array<String> = ASM_FLAGS.split(" ");
            
            for (include in STD_INCLUDES) {
                params.push(Path.normalize('-I${include}'));
            }
            
            params.push(Path.normalize('${asmFile}'));
            params.push('-o');
            params.push(Path.normalize('${outPath}/core/${fileName(asmFile)}.o'));
            
            var n = new ProcessHelper().run(Path.normalize(GCC), params);
            if (n != 0) {
                compilationFailed = true;
                break;
            }
        }

        if (compilationFailed == true) {
            trace("ASM CORE COMPILATION FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // C CORE
        /////////////////////////////////////////////////////////////////////////////
        compilationFailed = false;
        for (cFile in C_CORE) {
            var params:Array<String> = C_FLAGS.split(" ");
            
            for (include in STD_INCLUDES) {
                params.push(Path.normalize('-I${include}'));
            }
            
            params.push(Path.normalize('${cFile}'));
            params.push('-o');
            params.push(Path.normalize('${outPath}/core/${fileName(cFile)}.o'));
            
            var n = new ProcessHelper().run(Path.normalize(GCC), params);
            if (n != 0) {
                compilationFailed = true;
                break;
            }
        }
        
        if (compilationFailed == true) {
            trace("C CORE COMPILATION FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // CPP CORE
        /////////////////////////////////////////////////////////////////////////////
        compilationFailed = false;
        for (cppFile in CPP_CORE) {
            var params:Array<String> = CPP_FLAGS.split(" ");
            
            for (include in STD_INCLUDES) {
                params.push(Path.normalize('-I${include}'));
            }
            
            params.push(Path.normalize('${cppFile}'));
            params.push('-o');
            params.push(Path.normalize('${outPath}/core/${fileName(cppFile)}.o'));
            
            var n = new ProcessHelper().run(Path.normalize(GCCPP), params);
            if (n != 0) {
                compilationFailed = true;
                break;
            }
        }
        
        if (compilationFailed == true) {
            trace("CPP CORE COMPILATION FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // ARCHIVE
        /////////////////////////////////////////////////////////////////////////////
        var oFiles = [];
        FileHelper.findFiles(Path.normalize('${outPath}/core'), "o", oFiles);
        for (oFile in oFiles) {
            var params:Array<String> = ['rcs', Path.normalize('${outPath}/core/core.a'), oFile];
            var n = new ProcessHelper().run(Path.normalize(GCC_AR), params);
            if (n != 0) {
                compilationFailed = true;
                break;
            }
        }
        
        if (compilationFailed == true) {
            trace("ARCHIVE FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // LINK
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = LINK_FLAGS.split(" ");
        params.push('-o');
        params.push(Path.normalize('${outPath}/${NAME}.elf'));
        for (cppFile in cppFiles) {
            params.push(Path.normalize('${outPath}/${fileName(cppFile)}.o'));
        }
        params.push(Path.normalize('${outPath}/core/core.a'));
        var n = new ProcessHelper().run(Path.normalize(GCC), params);
        if (n != 0) {
            trace("LINK FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // OBJCOPY 1
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = "-O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0".split(" ");
        params.push(Path.normalize('${outPath}/${NAME}.elf'));
        params.push(Path.normalize('${outPath}/${NAME}.eep'));
        var n = new ProcessHelper().run(Path.normalize(OBJCOPY), params);
        if (n != 0) {
            trace("OBJCOPY 1 FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // OBJCOPY 2
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = "-O ihex -R .eeprom".split(" ");
        params.push(Path.normalize('${outPath}/${NAME}.elf'));
        params.push(Path.normalize('${outPath}/${NAME}.hex'));
        var n = new ProcessHelper().run(Path.normalize(OBJCOPY), params);
        if (n != 0) {
            trace("OBJCOPY 2 FAILED!");
            return;
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // SIZE
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = "-A".split(" ");
        params.push(Path.normalize('${outPath}/${NAME}.elf'));
        var sizeHelper = new SizeHelper(Path.normalize(SIZE), params);
        sizeHelper.displayStats();
    }
    
    private static function expandVars() {
        GCC = StringTools.replace(GCC, "%ARDUINO_HOME%", ARDUINO_HOME);
        GCCPP = StringTools.replace(GCCPP, "%ARDUINO_HOME%", ARDUINO_HOME);
        GCC_AR = StringTools.replace(GCC_AR, "%ARDUINO_HOME%", ARDUINO_HOME);
        OBJCOPY = StringTools.replace(OBJCOPY, "%ARDUINO_HOME%", ARDUINO_HOME);
        SIZE = StringTools.replace(SIZE, "%ARDUINO_HOME%", ARDUINO_HOME);
        
        for (a in 0...STD_INCLUDES.length) {
            STD_INCLUDES[a] = StringTools.replace(STD_INCLUDES[a], "%ARDUINO_HOME%", ARDUINO_HOME);
        }
        
        for (a in 0...ASM_CORE.length) {
            ASM_CORE[a] = StringTools.replace(ASM_CORE[a], "%ARDUINO_HOME%", ARDUINO_HOME);
        }
        
        for (a in 0...C_CORE.length) {
            C_CORE[a] = StringTools.replace(C_CORE[a], "%ARDUINO_HOME%", ARDUINO_HOME);
        }
        
        for (a in 0...CPP_CORE.length) {
            CPP_CORE[a] = StringTools.replace(CPP_CORE[a], "%ARDUINO_HOME%", ARDUINO_HOME);
        }
    }
    
    private static function fileName(f:String):String {
        var p = new Path(f);
        return p.file + "." + p.ext;
    }
}
