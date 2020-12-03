package helpers;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class FileHelper {
    public static function findFiles(folder:String, extension:String, result:Array<String>) {
        if (FileSystem.exists(folder) == false || FileSystem.isDirectory(folder) == false) {
            return;
        }
        
        var contents = FileSystem.readDirectory(folder);
        for (file in contents) {
            var fullPath = Path.normalize(folder + "/" + file);
            if (FileSystem.isDirectory(fullPath) == false && StringTools.endsWith(fullPath, '.${extension}')) {
                result.push(fullPath);
            }
        }
        
        for (file in contents) {
            var fullPath = Path.normalize(folder + "/" + file);
            if (FileSystem.isDirectory(fullPath) == true) {
                findFiles(fullPath, extension, result);
            }
        }
    }
    
    public static function findDirs(folder:String, result:Array<String>) {
        if (FileSystem.exists(folder) == false || FileSystem.isDirectory(folder) == false) {
            return;
        }
        
        var contents = FileSystem.readDirectory(folder);
        for (file in contents) {
            var fullPath = Path.normalize(folder + "/" + file);
            if (FileSystem.isDirectory(fullPath) == true) {
                result.push(fullPath);
                findDirs(fullPath, result);
            }
        }
    }
    
    public static function copyFiles(src:String, dst:String, extension:String) {
        src = Path.normalize(src);
        var files:Array<String> = [];
        findFiles(src, extension, files);
        for (f in files) {
            var relPath = StringTools.replace(f, src, "");
            var dstPath = Path.normalize(dst + "/" + relPath);
            var p = new Path(dstPath);
            FileSystem.createDirectory(p.dir);
            trace("copying: " + src + relPath + " => " + dstPath);
            File.copy(f, dstPath);
        }
    }
}