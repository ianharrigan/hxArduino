package;

import sys.FileSystem;

class FileHelper {
    public static function findFiles(folder:String, extension:String, result:Array<String>) {
        if (FileSystem.exists(folder) == false || FileSystem.isDirectory(folder) == false) {
            return;
        }
        
        var contents = FileSystem.readDirectory(folder);
        for (file in contents) {
            var fullPath = folder + "\\" + file;
            if (FileSystem.isDirectory(fullPath) == false && StringTools.endsWith(fullPath, '.${extension}')) {
                result.push(fullPath);
            }
        }
        
        for (file in contents) {
            var fullPath = folder + "\\" + file;
            if (FileSystem.isDirectory(fullPath) == true) {
                findFiles(fullPath, extension, result);
            }
        }
    }
}