package ast2obj.builders;
import ast2obj.OClass;
import ast2obj.OConstant;
import ast2obj.OExpression;
import ast2obj.OMethod;
import haxe.io.Path;
import helpers.FileHelper;
import helpers.HaxeLibHelper;
import sys.FileSystem;
import sys.io.File;

class ArduinoCPPBuilder {
    public static var basePath:String = null;
    public static var srcPath:String = "%BASE%/build/hxArduino/src";
    public static var includePath:String = "%BASE%/build/hxArduino/include";
    public static var outPath:String = "%BASE%/build/hxArduino/out";
    
    public static var classes:Array<OClass> = [];
    
    public static var libraries:Array<String> = [];
    
    public static function build() {
        srcPath = Path.normalize(StringTools.replace(srcPath, "%BASE%", basePath));
        includePath = Path.normalize(StringTools.replace(includePath, "%BASE%", basePath));
        outPath = Path.normalize(StringTools.replace(outPath, "%BASE%", basePath));
        FileSystem.createDirectory(srcPath);
        FileSystem.createDirectory(includePath);
        FileSystem.createDirectory(outPath);
        
        for (c in classes) {
            if (c.isExtern == false) {
                buildClassHeader(c);
                buildClassImpl(c);
            } else {
                addLibraries(c.externIncludes);
                addRefs(c.externIncludes);
            }
        }
        
        // copy support files (not generated)
        var supportPath = Path.normalize(HaxeLibHelper.getLibPath("hxArduino") + "/lib");
        FileHelper.copyFiles(supportPath, includePath, "h");
        FileHelper.copyFiles(supportPath, srcPath, "cpp");
    }
    
    public static function findClass(name:String):OClass {
        var oclass = null;
        
        for (c in classes) {
            if (c.fullName == name || c.safeName.toLowerCase() == name.toLowerCase()) {
                oclass = c;
                break;
            }
            
            if (c.isExtern && c.externName == name) {
                oclass = c;
                break;
            }
        }
        
        return oclass;
    }
    
    private static var _refs:Array<String>;
    private static var _currentClass:OClass;
    private static var _currentMethod:OMethod;
    private static function buildClassHeader(c:OClass){
        _refs = [];
        _currentClass = c;
        if (c.fullName == "Main") {  // TODO: does this make it brittle - dont really want Main to be extended from HxObject
            c.stackOnly = true;
        }
        
        var sb = new StringBuf();
        var filename = Path.normalize(includePath + "/" + c.safeName + ".h");
        
        sb.add("#ifndef " + c.safeName + "_h_\n");
        sb.add("#define " + c.safeName + "_h_ 1\n\n");
        
        sb.add("%INCLUDES%\n");
        
        sb.add("class ");
        sb.add(c.safeName);
        if (c.superClass != null) {
            sb.add(" : public ");
            sb.add(substTypeName(c.superClass.safeName));
        } else if (c.stackOnly == false) {
            sb.add(" : public HxObject");
            addRef("HxObject");
        }
        sb.add(" {\n");

        sb.add("    public:\n");
        
        for (cv in c.classVars) {
            sb.add("        ");
            var oclass = findClass(cv.type.name);
            var varTypeName:String = cv.type.safeName;
            if (oclass != null && oclass.externName != null) {
                varTypeName = oclass.externName;
            }
            if (isInternalType(substTypeName(varTypeName))) {
                sb.add(substTypeName(varTypeName));
            } else if (oclass.stackOnly == true) {
                sb.add(substTypeName(varTypeName));
            } else {
                sb.add("AutoPtr<");
                sb.add(substTypeName(varTypeName));
                sb.add(">");
                addRef("AutoPtr");
            }
            
            if (cv.type.typeParameters.length > 0) {
                sb.add("<");
                for (i in 0...cv.type.typeParameters.length) {
                    var oclass = findClass(cv.type.typeParameters[i].name);
                    var varTypeName = cv.type.typeParameters[i].safeName;
                    if (oclass != null && oclass.externName != null) {
                        varTypeName = oclass.externName;
                    }
                    if (isInternalType(varTypeName)) {
                        sb.add(substTypeName(varTypeName));
                    } else {
                        sb.add("AutoPtr<");
                        sb.add(substTypeName(varTypeName));
                        sb.add(">");
                        addRef("AutoPtr");
                    }
                    if (i < cv.type.typeParameters.length - 1) {
                        sb.add(", ");
                    }
                }
                sb.add(">");
            }
            
            sb.add(" ");
            sb.add(cv.name);
            
            if (cv.expression != null) {
                sb.add(" = ");
                sb.add(buildExpression(cv.expression, "        "));
                sb.add(";");
            } else {
                sb.add(";");
            }
            sb.add("\n");
        }
        sb.add("\n");
        
        for (m in c.methods) {
            _currentMethod = m;
            sb.add(buildMethod(m, "        "));
            sb.add("\n");
        }
        
        sb.add("};\n");

        sb.add("\n#endif");
        
        var includes = "";
        for (ref in _refs) {
            includes += "#include <" + ref + ".h>\n";
        }
        
        var contents = sb.toString();
        contents = StringTools.replace(contents, "%INCLUDES%", includes);
        File.saveContent(filename, contents);
    }
    
    
    private static function buildClassImpl(c:OClass){
        
        _refs = [];
        _currentClass = c;
        var sb = new StringBuf();

        sb.add("#include \"" + c.safeName + ".h\"\n");
        sb.add("%INCLUDES%\n");
        
        var filename = Path.normalize(srcPath + "/" + c.safeName + ".cpp");
        
        for (m in c.methods) {
            _currentMethod = m;
            sb.add(buildMethod(m, "", false));
            sb.add("\n");
        }
        
        var includes = "";
        for (ref in _refs) {
            includes += "#include <" + ref + ".h>\n";
        }
        
        var contents = sb.toString();
        contents = StringTools.replace(contents, "%INCLUDES%", includes);
        File.saveContent(filename, contents);
    }
    
    
    private static function buildMethod(m:OMethod, tabs:String, header:Bool = true) {
        var sb:StringBuf = new StringBuf();
        sb.add(tabs);
        
        var oclass = findClass(m.type.name);
        if (isInternalType(substTypeName(m.type.safeName))) {
            sb.add(substTypeName(m.type.safeName));
        } else if (oclass.stackOnly == true) {
            sb.add(substTypeName(m.type.safeName));
            sb.add("&");
        } else {
            sb.add("AutoPtr<");
            sb.add(substTypeName(m.type.safeName));
            sb.add(">");
            addRef("AutoPtr");
        }
        sb.add(" ");
        if (header == false) {
            sb.add(m.cls.safeName);
            sb.add("::");
        }
        sb.add(m.name);
        sb.add("(");
        for (i in 0... m.args.length) {
            var arg = m.args[i];
            var oclass = findClass(arg.type.name);
            var varTypeName = arg.type.safeName;
            if (oclass != null && oclass.externName != null) {
                varTypeName = oclass.externName;
            }
            if (isInternalType(substTypeName(varTypeName))) {
                sb.add(substTypeName(varTypeName));
            } else if (oclass.stackOnly) {
                sb.add(substTypeName(varTypeName));
                sb.add("&");
            } else {
                sb.add("AutoPtr<");
                sb.add(substTypeName(varTypeName));
                sb.add(">");
                addRef("AutoPtr");
            }
            sb.add(" ");
            sb.add(arg.name);
            if (arg.value != null && header == true) {
                sb.add(" = ");
                sb.add(buildConstant(cast(arg.value, OConstant)));
            }
            if (i < m.args.length - 1) {
                sb.add(", ");
            }
        }
        sb.add(")");
        
        if (header == true) {
            sb.add(";");
        } else {
            sb.add(" ");
            sb.add(buildExpression(m.expression, tabs));
        }
        
        return sb.toString();
    }
    
    private static function buildExpression(e:OExpression, tabs:String) {
        if (e == null) {
            return "";
        }
        
        var sb = new StringBuf();

        if (Std.is(e, OBlock)) {
            var oblock = cast(e, OBlock);
            sb.add("{\n");
            
            for (e in oblock.expressions) {
                sb.add(tabs + "    ");
                var expressionString = buildExpression(e, tabs + "    ");
                sb.add(expressionString);

                // TODO: maybe not the best way to do this?
                if (StringTools.endsWith(StringTools.trim(expressionString), "}") != true
                    && StringTools.endsWith(StringTools.trim(expressionString), ";") != true) {
                    sb.add(";");
                }
                
                sb.add("\n");
            }
            
            sb.add(tabs);
            sb.add("}\n");
        } else if (Std.is(e, OReturn)) {
            sb.add("return ");
            sb.add(buildExpression(e.nextExpression, tabs));
        } else if (Std.is(e, OConstant)) {
            sb.add(buildConstant(cast(e, OConstant)));
            sb.add(buildExpression(e.nextExpression, tabs));
        } else if (Std.is(e, OVar)) {
            var ovar = cast(e, OVar);
            if (isInternalType(substTypeName(ovar.type.safeName))) {
                sb.add(substTypeName(ovar.type.safeName));
            } else {
                var oclass = findClass(ovar.type.name);
                var varTypeName = ovar.type.safeName;
                if (oclass != null && oclass.isExtern == true && oclass.externName != null) {
                    varTypeName = oclass.externName;
                }
                if (oclass.stackOnly == true) {
                    sb.add(substTypeName(varTypeName));
                } else {
                    sb.add("AutoPtr<");
                    sb.add(substTypeName(varTypeName));
                    sb.add(">");
                    addRef("AutoPtr");
                }
            }
            if (ovar.type.typeParameters != null && ovar.type.typeParameters.length > 0) {
                sb.add("<");
                for (i in 0...ovar.type.typeParameters.length) {
                    sb.add(substTypeName(ovar.type.typeParameters[i].safeName));
                    if (i < ovar.type.typeParameters.length - 1) {
                        sb.add(", ");
                    }
                }
                sb.add(">");
            }
            sb.add(" ");
            sb.add(ovar.name);
            if (ovar.nextExpression != null && Std.is(e.nextExpression, OArrayDecl) == false) { // we dont want arraydecl "inline"
                sb.add(" = ");
                sb.add(buildExpression(ovar.nextExpression, tabs));
            } else if (ovar.nextExpression != null) {
                sb.add(";\n");
                sb.add(buildExpression(ovar.nextExpression, tabs));
            }
        } else if (Std.is(e, OBinOp)) {
            var obinop = cast(e, OBinOp);
            sb.add(buildExpression(obinop.expression, tabs));
            sb.add(" ");
            sb.add(obinop.op);
            sb.add(" ");
            sb.add(buildExpression(obinop.nextExpression, tabs));
        } else if (Std.is(e, OLocal)) {
            var olocal = cast(e, OLocal);
            sb.add(olocal.name);
            sb.add(buildExpression(olocal.nextExpression, tabs));
        } else if (Std.is(e, OIf)) {
            var oif = cast(e, OIf);
            //sb.add("\n");
            //sb.add(tabs);
            sb.add("if ");
            sb.add(buildExpression(oif.conditionExpression, tabs));
            sb.add(" ");
            sb.add(buildExpression(oif.ifExpression, tabs));
            if (oif.elseExpression != null) {
                sb.add(tabs);
                sb.add("else ");
                sb.add(buildExpression(oif.elseExpression, tabs));
            }
        } else if (Std.is(e, OParenthesis)) {
            var oparenthesis = cast(e, OParenthesis);
            sb.add("(");
            sb.add(buildExpression(oparenthesis.nextExpression, tabs));
            sb.add(")");
        } else if (Std.is(e, OArrayDecl)) {
            var ovar = cast(e.prevExpression, OVar);
            var oarraydecl = cast(e, OArrayDecl);
            for (e in oarraydecl.expressions) {
                sb.add(tabs);
                sb.add(ovar.name);
                sb.add(".add(");
                sb.add(buildExpression(e, tabs));
                sb.add(");\n");
            }
        } else if (Std.is(e, OWhile)) {
            var owhile = cast(e, OWhile);
            sb.add("\n");
            sb.add(tabs);
            sb.add("while ");
            sb.add(buildExpression(owhile.conditionExpression, tabs));
            sb.add(" ");
            sb.add(buildExpression(owhile.nextExpression, tabs));
        } else if (Std.is(e, OUnOp)) {
            var ounop = cast(e, OUnOp);
            if (ounop.post == true) {
                sb.add(buildExpression(ounop.nextExpression, tabs));
                sb.add(ounop.op);
            } else {
                sb.add(ounop.op);
                sb.add(buildExpression(ounop.nextExpression, tabs));
            }
        } else if (Std.is(e, OArray)) {
            var oarray = cast(e, OArray);
            sb.add(buildExpression(oarray.varExpression, tabs));
            sb.add(".get(");
            sb.add(buildExpression(oarray.nextExpression, tabs));
            sb.add(")");
        } else if (Std.is(e, OFieldInstance)) {
            var ofield = cast(e, OFieldInstance);
            var expressionString = buildExpression(ofield.nextExpression, tabs);
            sb.add(expressionString);
            var oclass = findClass(ofield.cls.fullName);
            var className = ofield.cls.safeName;
            if (oclass != null && oclass.externName != null) {
                className = oclass.externName;
            }
            if (expressionString == "this") {
                sb.add("->");
            } else if (isInternalType(substTypeName(className))) {
                sb.add(".");
            } else if (oclass.stackOnly) {
                sb.add(".");
            } else {
                sb.add(".get()->");
            }
            sb.add(substFieldName(ofield.cls.safeName, ofield.field));
        } else if (Std.is(e, OFieldStatic)) {
            var ofield = cast(e, OFieldStatic);
            var className = buildExpression(ofield.nextExpression, tabs);
            var fieldName = substFieldName(ofield.cls.safeName, ofield.field);
            var substName = substStaticFieldName(className, fieldName); // this will turn things like "Std.is" -> "Std_is" (which is a c++ #define), rather than Std::is
            if (ofield.cls.isExtern == true) {
                if (ofield.cls.externName != null) {
                    sb.add(ofield.cls.externName);
                    sb.add(".");
                }
                sb.add(fieldName);
                if (ofield.cls.externIncludes != null) {
                    addRefs(ofield.cls.externIncludes);
                }
            } else {
                sb.add(substName);
            }
        } else if (Std.is(e, ONew)) {
            var onew = cast(e, ONew);
            var varTypeName = onew.cls.safeName;
            var oclass = findClass(onew.cls.fullName);
            if (oclass != null && oclass.externName != null) {
                varTypeName = oclass.externName;
            }
            
            if (isInternalType(substTypeName(varTypeName))) {
                sb.add(substTypeName(onew.cls.safeName));
            } else {
                if (oclass.stackOnly == false) {
                    sb.add("new ");
                }
                addLibrary(substTypeName(varTypeName));
                sb.add(substTypeName(varTypeName));
            }
            sb.add("(");
            for (i in 0...onew.expressions.length) {
                sb.add(buildExpression(onew.expressions[i], tabs));
                if (i < onew.expressions.length - 1) {
                    sb.add(", ");
                }
            }
            sb.add(")");
        } else if (Std.is(e, OCall)) {
            var ocall = cast(e, OCall);
            sb.add(buildExpression(ocall.nextExpression, tabs));
            sb.add("(");
            for (i in 0...ocall.expressions.length) {
                sb.add(buildExpression(ocall.expressions[i], tabs));
                if (i < ocall.expressions.length - 1) {
                    sb.add(", ");
                }
            }
            sb.add(")");
        } else if (Std.is(e, OTypeExprClass)) {
            var otypeexprclass = cast(e, OTypeExprClass);
            sb.add(substTypeName(otypeexprclass.cls.safeName));
        } else if (Std.is(e, OConstantIdentifier)) {
            var oconstantidentifier = cast(e, OConstantIdentifier);
            sb.add(oconstantidentifier.name);
        } else if (Std.is(e, OSwitch)) {
            var oswitch = cast(e, OSwitch);
            sb.add("switch ");
            sb.add(buildExpression(oswitch.expression, tabs));
            sb.add(" {\n");
            var tabs2 = tabs + tabs;
            for (ocase in oswitch.cases) {
                var ncase = 0;
                for (caseExpression in ocase.caseExpressions) {
                    sb.add(tabs2);
                    sb.add("case ");
                    
                    if (Std.is(caseExpression, OConstant)) {
                        var oconstant = cast(caseExpression, OConstant);
                        sb.add(oconstant.value);
                    } else {
                        sb.add(buildExpression(caseExpression, tabs));
                    }
                    sb.add(": ");
                    if (ncase < ocase.caseExpressions.length - 1) {
                        sb.add("\n");
                    }
                    ncase++;
                }
                
                sb.add(buildExpression(ocase.expression, tabs2));
                
                sb.add(tabs2);
                sb.add("break;\n\n");
            }
            
            if (oswitch.defaultExpression != null) {
                sb.add(tabs2);
                sb.add("default: ");
                sb.add(buildExpression(oswitch.defaultExpression, tabs2));
                sb.add(tabs2);
                sb.add("break;\n\n");
            }
            
            sb.add(tabs);
            sb.add("}");
        } else {
            trace("ArduinoCPPBuilder::buildExpression - " + Type.getClassName(Type.getClass(e)));
        }
        
        return sb.toString();
    }
    
    private static function buildConstant(c:OConstant) {
        var sb = new StringBuf();
        
        switch (c.type) {
            case "Int":
                sb.add(c.value);
            case "String":
                sb.add("String(\"" + c.value + "\")");
                // TODO: always a good idea to "F" (flash mem) ? Not sure...
                //sb.add("F(\"" + c.value + "\")");
            case "this":
                sb.add("this");
            case "null":
                sb.add("NULL");
            case _:
                trace("buildConstant not impl: " + c.type);
        }
        
        return sb;
    }
    
    private static function substTypeName(typeName:String):String {
        switch (typeName) {
            case "Array":
                typeName = "LinkedList";
            case "String":
                typeName = "String";
            case "Int":
                typeName = "int";
            case "Void":
                typeName = "void";
            case _:
        }
        
        //addRef(typeName);
        var oclass = findClass(typeName);
        if (oclass != null) {
            if (oclass.isExtern == true) {
                //addRef(oclass.externName);
                addRefs(oclass.externIncludes);
            } else {
                addRef(oclass.safeName);
            }
        } else {
            addRef(typeName);
        }
        
        return typeName;
    }
    
    private static function substFieldName(className:String, fieldName:String):String {
        if (className == "Array") {
            switch (fieldName) {
                case "length":
                    fieldName = "size()";
                case "push":
                    fieldName = "add";
            }
        }
        return fieldName;
    }
    
    private static function substStaticFieldName(className:String, fieldName:String):String {
        if (className == "Std") {
            switch (fieldName) {
                case "is":
                    return "Std_is";
            }
        }
        return className + "::" + fieldName;
    }

    private static function addRefs(typeNames:Array<String>) {
        if (typeNames != null) {
            for (t in typeNames) {
                addRef(t);
            }
        }
    }
    
    private static function addRef(typeName:String) {
        if (typeName == "int" || typeName == "void") {
            return;
        }

        if (typeName == "Serial") {
            return;
        }
        
        if (_currentClass == null || _currentClass.safeName == typeName || _currentClass.fullName == typeName ) {
            return;
        }

        typeName = StringTools.replace(typeName, ".h", "");
        if (_refs.indexOf(typeName) == -1) {
            _refs.push(typeName);
        }
    }
    
    private static function addLibraries(typeNames:Array<String>) {
        if (typeNames != null) {
            for (t in typeNames) {
                addLibrary(t);
            }
        }
    }
    
    private static function addLibrary(typeName:String) {
        if (typeName == null) {
            return;
        }
        
        typeName = StringTools.replace(typeName, ".h", "");
        
        if (libraries.indexOf(typeName) == -1) {
            libraries.push(typeName);
        }
    }
    
    private static function isInternalType(typeName:String):Bool {
        switch (typeName) {
            case "int" | "LinkedList" | "String" | "void" | "Void":
                return true;
        }
        return false;
    }
}