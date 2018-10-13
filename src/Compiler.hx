package;
import haxe.io.Path;
import neko.Lib;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author 
 */
class Compiler {
    // PROGRA~2
    
    private static var CPP_FLAGS:String = "-c -w -Os -Wall -Wextra -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var ASM_FLAGS:String = "-c -x assembler-with-cpp -flto -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var C_FLAGS:String = "-c -Os -Wall -Wextra -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10807 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR";
    private static var LINK_FLAGS:String = "-Wall -Wextra -Os -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p";
    
//    private static var ARDUINO_HOME:String = "C:\\Program Files (x86)\\Arduino";
    private static var ARDUINO_HOME:String = "C:\\PROGRA~2\\Arduino";
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
        /* DONT THINK THIS IS NEEDED
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\main.cpp",
        */
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial0.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\HardwareSerial3.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\WString.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\WMath.cpp",
        "%ARDUINO_HOME%\\hardware\\arduino\\avr\\cores\\arduino\\USBCore.cpp"
    ];
    
    private static var GCC:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-gcc';
    private static var GCCPP:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-g++';
    private static var GCC_AR:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-gcc-ar';
    private static var OBJCOPY:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-objcopy';
    private static var SIZE:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avr-size';
    private static var DUDE:String = '%ARDUINO_HOME%\\hardware\\tools\\avr/bin/avrdude';
    
    private static var NAME:String = "MyTest";
    
	public static function compile(path:String = null, compile:Bool = true, install:Bool = true, run:Bool = true, libraries:Array<String> = null) {
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { 
          Sys.println(v);
        }

        if (libraries == null) {
            libraries = [];
        }
        
        if (Sys.getEnv("ARDUINO_HOME") != null) {
            ARDUINO_HOME = Sys.getEnv("ARDUINO_HOME");
        }

        var rootDir = 'C:\\Temp\\arduino_test2';
        var cwd = Path.normalize(Sys.getCwd());
        trace("WORKING DIR: " + cwd);
        rootDir = cwd;

        rootDir = 'C:/Temp/arduino_test3';
        if (path != null) {
            rootDir = path;
        }
        
        var srcDir = Path.normalize('${rootDir}\\src\\');
        var includeDir = Path.normalize('${rootDir}\\include\\');
        var outputDir = Path.normalize('${rootDir}\\out\\');
        
        STD_INCLUDES.push(includeDir);
        
        
        
        /*
        STD_INCLUDES.push("C:\\Servers\\Haxe\\haxe\\lib\\hxcpp\\git\\include");
        
        STD_INCLUDES.push("C:\\Temp\\a_include\\hardware\\tools\\g++_arm_none_eabi\\arm-none-eabi\\include");
        STD_INCLUDES.push("C:\\Temp\\a_include\\hardware\\tools\\g++_arm_none_eabi\\arm-none-eabi\\include\\c++\\4.4.1\\arm-none-eabi");
        STD_INCLUDES.push("C:\\Temp\\a_include\\hardware\\tools\\g++_arm_none_eabi\\arm-none-eabi\\include\\c++\\4.4.1");
        */
        
        
        expandVars();
        
        trace('ROOT DIR: ${rootDir}');
        trace('SOURCE DIR: ${srcDir}');
        trace('OUTPUT DIR: ${outputDir}');
        FileSystem.createDirectory(outputDir);
        FileSystem.createDirectory(outputDir + "\\core");
        rootDir = Path.normalize(rootDir);
        NAME = rootDir.split("/").pop();
        
        if (compile == true) {
            /////////////////////////////////////////////////////////////////////////////
            // LIBRARIES
            /////////////////////////////////////////////////////////////////////////////
            for (l in libraries) {
                var libCppFiles = [];
                FileHelper.findFiles('${ARDUINO_HOME}/libraries/${l}/src', 'cpp', libCppFiles);
                for (libCppFile in libCppFiles) {
                    var p = new Path(libCppFile);
                    File.copy(libCppFile, '${srcDir}/${p.file}.cpp'); 
                }
                
                var libHeaderFiles = [];
                FileHelper.findFiles('${ARDUINO_HOME}/libraries/${l}/src', 'h', libHeaderFiles);
                for (libHeaderFile in libHeaderFiles) {
                    var p = new Path(libHeaderFile);
                    File.copy(libHeaderFile, '${includeDir}/${p.file}.h'); 
                }
            }
            
            /////////////////////////////////////////////////////////////////////////////
            // COMPILATION
            /////////////////////////////////////////////////////////////////////////////
            var cppFiles = [];
            FileHelper.findFiles(srcDir, "cpp", cppFiles);
            if (cppFiles.length == 0) {
                trace("NOTHING TO COMPILE!");
                return;
            }
            
            var compilationFailed:Bool = false;
            for (cppFile in cppFiles) {
                var params:Array<String> = CPP_FLAGS.split(" ");
                
                for (include in STD_INCLUDES) {
                    params.push('-I${include}');
                }
                
                params.push('${cppFile}');
                params.push('-o');
                params.push('${outputDir}\\${fileName(cppFile)}.o');
                
                var n = new ProcessHelper().run(GCCPP, params);
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
                    params.push('-I${include}');
                }
                
                params.push('${asmFile}');
                params.push('-o');
                params.push('${outputDir}\\core\\${fileName(asmFile)}.o');
                
                var n = new ProcessHelper().run(GCC, params);
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
                    params.push('-I${include}');
                }
                
                params.push('${cFile}');
                params.push('-o');
                params.push('${outputDir}\\core\\${fileName(cFile)}.o');
                
                var n = new ProcessHelper().run(GCC, params);
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
                    params.push('-I${include}');
                }
                
                params.push('${cppFile}');
                params.push('-o');
                params.push('${outputDir}\\core\\${fileName(cppFile)}.o');
                
                var n = new ProcessHelper().run(GCCPP, params);
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
            FileHelper.findFiles(outputDir + "\\core", "o", oFiles);
            for (oFile in oFiles) {
                trace(oFile);
                
                var params:Array<String> = ['rcs', '${outputDir}\\core\\core.a', oFile];
                var n = new ProcessHelper().run(GCC_AR, params);
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
            params.push('${outputDir}\\${NAME}.elf');
            for (cppFile in cppFiles) {
                params.push('${outputDir}\\${fileName(cppFile)}.o');
            }
            params.push('${outputDir}\\core\\core.a');
            var n = new ProcessHelper().run(GCC, params);
            if (n != 0) {
                trace("LINK FAILED!");
                return;
            }

            /////////////////////////////////////////////////////////////////////////////
            // OBJCOPY 1
            /////////////////////////////////////////////////////////////////////////////
            var params:Array<String> = "-O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0".split(" ");
            params.push('${outputDir}\\${NAME}.elf');
            params.push('${outputDir}\\${NAME}.eep');
            var n = new ProcessHelper().run(OBJCOPY, params);
            if (n != 0) {
                trace("OBJCOPY 1 FAILED!");
                return;
            }
            
            /////////////////////////////////////////////////////////////////////////////
            // OBJCOPY 2
            /////////////////////////////////////////////////////////////////////////////
            var params:Array<String> = "-O ihex -R .eeprom".split(" ");
            params.push('${outputDir}\\${NAME}.elf');
            params.push('${outputDir}\\${NAME}.hex');
            var n = new ProcessHelper().run(OBJCOPY, params);
            if (n != 0) {
                trace("OBJCOPY 2 FAILED!");
                return;
            }
        }

        /////////////////////////////////////////////////////////////////////////////
        // SIZE
        /////////////////////////////////////////////////////////////////////////////
        var params:Array<String> = "-A".split(" ");
        params.push('${outputDir}\\${NAME}.elf');
        new ProcessHelper().run(SIZE, params);
        
        var sizeHelper = new SizeHelper(SIZE, params);
        
        /////////////////////////////////////////////////////////////////////////////
        // DUDE
        /////////////////////////////////////////////////////////////////////////////
        if (install == true) {
            var params:Array<String> = '-C${ARDUINO_HOME}\\hardware\\tools\\avr/etc/avrdude.conf -v -patmega328p -carduino -PCOM3 -b115200 -D'.split(" ");
            params.push('-Uflash:w:${outputDir}\\${NAME}.hex:i');
            var n = new ProcessHelper().run(DUDE, params);
            if (n != 0) {
                trace("INSTALL FAILED!");
                Sys.getChar(false);
                return;
            }
        }
            
        sizeHelper.displayStats();
        trace("COMPLETE!!!");
        
        if (run == true) {
            //new ProcessHelper().run("Z:\\arduino\\serial\\bin\\serial");
            
            #if _compile_tool
            
            trace("STARTING");
            
            trace(hxSerial.Serial.getDeviceList());
            var serialObj = new hxSerial.Serial("COM3", 115200);
            
            serialObj.setup();
            
            while (true) {
                var i = serialObj.available();
                var s = serialObj.readBytes(i);
                Lib.print(s);
                Sys.sleep(0.01);
            }
            
            trace("Closing");
            serialObj.close();
            
            #end
            
            
        }
	}
    
    // "C:\\Program Files (x86)\\Arduino\\hardware\\tools\\avr/bin/avr-size" -A "C:\Temp\arduino_test3\out\arduino_test3.elf"
    
    private static function fileName(f:String):String {
        var parts = f.split("\\");
        var fname = parts.pop();
        return fname;
    }
    
    private static function expandVars() {
        GCC = StringTools.replace(GCC, "%ARDUINO_HOME%", ARDUINO_HOME);
        GCCPP = StringTools.replace(GCCPP, "%ARDUINO_HOME%", ARDUINO_HOME);
        GCC_AR = StringTools.replace(GCC_AR, "%ARDUINO_HOME%", ARDUINO_HOME);
        OBJCOPY = StringTools.replace(OBJCOPY, "%ARDUINO_HOME%", ARDUINO_HOME);
        SIZE = StringTools.replace(SIZE, "%ARDUINO_HOME%", ARDUINO_HOME);
        DUDE = StringTools.replace(DUDE, "%ARDUINO_HOME%", ARDUINO_HOME);
        
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
}