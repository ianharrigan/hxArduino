package;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr.Binop;
import haxe.macro.Expr.Unop;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

class Generator {
    public static function generate() {
        Context.onGenerate(Generator.onGenerate);
    }
    
    public static function onGenerate(types:Array<Type>):Void {
        FileSystem.createDirectory(Sys.getCwd() + "/bin/generated/include");
        FileSystem.createDirectory(Sys.getCwd() + "/bin/generated/src");
        
        for (t in types) {
            switch(t) {
                case TInst(c, params):
                    generateClass(c, params);
                default:
                    //trace(t);   
            }
        }

        var libPath:String = HaxeLibHelper.getLibPath("hxArduino");
        
        var headerFiles = [];
        FileHelper.findFiles(libPath + "\\lib", "h", headerFiles);
        for (h in headerFiles) {
            var p = new Path(h);
            File.copy(h, Sys.getCwd() + "/bin/generated/include/" + p.file + "." + p.ext);
        }
        
        var cppFiles = [];
        FileHelper.findFiles(libPath + "\\lib", "cpp", cppFiles);
        for (c in cppFiles) {
            var p = new Path(c);
            File.copy(c, Sys.getCwd() + "/bin/generated/src/" + p.file + "." + p.ext);
        }

        Compiler.compile(Sys.getCwd() + "/bin/generated", true, false, false, libraries);
    }
    
    private static var headers:Array<String> = [];
    private static var externs:Array<String> = [];
    private static var libraries:Array<String> = [];
    private static function generateClass(c:Ref<ClassType>, params:Array<Type>) {
        var classType:ClassType = c.get();
        var fullName = classType.name;
        if (classType.pack.length > 0) {
            fullName = classType.pack.join(".") + "." + fullName;
        }
        
        var classPath = c.toString();
        // for now skipping a LOT of classes... will no doubt break things!
        if (StringTools.startsWith(classPath, "neko.") || StringTools.startsWith(classPath, "haxe.") || StringTools.startsWith(classPath, "_Math")
            || classPath == "Array" || classPath == "EReg" || classPath == "IntIterator" || classPath == "Reflect" || classPath == "Std"
            || classPath == "Math" || classPath == "ArrayAccess" || classPath == "String" || classPath == "StringBuff" || classPath == "StringTools"
            || classPath == "StringBuf" || classPath == "Type") {
            return;
        }
        headers = [];
        
        if (classType.isExtern == true) {
            return;
        }

        trace("Generating: " + c.toString());
        
        var fixedName = StringTools.replace(fullName, ".", "_");
        
        var sb:StringBuf = new StringBuf();
        sb.add("#ifndef " + fixedName + "_h_\n");
        sb.add("#define " + fixedName + "_h_ 1\n\n");
        
        sb.add("%INCLUDES%\n");
        
        sb.add("class " + fixedName + "\n");
        sb.add("{\n");
        sb.add("\tpublic:\n");
        
        var fields:Array<ClassField> = classType.fields.get();
        for (f in fields) {
            switch (f.expr().expr) {
                case TFunction(tfunc):
                    addIndent(2, sb);
                    sb.add(generateFunctionArgType(tfunc.t));
                    sb.add(" ");
                    sb.add(f.name);
                    sb.add("(");
                    
                    var argList:Array<String> = [];
                    for (arg in tfunc.args) {
                        var argString = generateFunctionArgType(arg.v.t) + " " + arg.v.name;
                        if (arg.value != null) {
                            argString += " = " + printConstant(arg.value);
                        }
                        argList.push(argString);
                    }
                    sb.add(argList.join(", "));
                    
                    sb.add(")\n");
                    tabs = "\t\t";
                    sb.add(printExpr(tfunc.expr));
                    sb.add("\n");
                    
                default: 
                    //trace("NOT IMPL: " + f.expr());
            }
            
            switch (f.kind) {
                case FVar(read, write):
                    addIndent(2, sb);
                    sb.add(generateFunctionArgType(f.type, true));
                    sb.add(" ");
                    sb.add(f.name);
                    if (f.expr() != null) {
                        sb.add(" = ");
                        sb.add(printExpr(f.expr()));
                    }
                    sb.add(";\n\n");
                default:
                    //trace("NOT IMPLE: " + f);
            }
        }

        var fields:Array<ClassField> = classType.statics.get();
        for (f in fields) {
            if (f.expr() != null) {
                switch (f.expr().expr) {
                    case TFunction(tfunc):
                        addIndent(2, sb);
                        sb.add("static ");
                        sb.add(generateFunctionArgType(tfunc.t));
                        sb.add(" ");
                        sb.add(f.name);
                        sb.add("(");
                        
                        var argList:Array<String> = [];
                        for (arg in tfunc.args) {
                            var argString = generateFunctionArgType(arg.v.t) + " " + arg.v.name;
                            if (arg.value != null) {
                                argString += " = " + printConstant(arg.value);
                            }
                            argList.push(argString);
                        }
                        sb.add(argList.join(", "));
                        
                        sb.add(")\n");
                        tabs = "\t\t";
                        sb.add(printExpr(tfunc.expr));
                        sb.add("\n");
                    default:    
                }
            } else {
                addIndent(2, sb);
                sb.add("static ");
                
                switch(f.type) {
                    case TFun(argString, ret):
                        sb.add(printType(ret, null));
                    default:    
                }
                
                sb.add(" ");
                sb.add(f.name);
                sb.add("(");
                sb.add(");\n");
            }
        }
        
        sb.add("};\n");
        sb.add("\n#endif\n");
        
        //trace("\n\n" + sb.toString());
        var content = sb.toString();
        var headersContent = "";
        for (h in headers) {
            headersContent += '#include "${h}"\n';
        }
        content = StringTools.replace(content, "%INCLUDES%", headersContent);
        trace(Sys.getCwd() + "bin/generated/include/" + fixedName + ".h");
        File.saveContent(Sys.getCwd() + "bin/generated/include/" + fixedName + ".h", content);
    }
    
    private static function generateFunctionArgType(t:Type, isVar:Bool = false):String {
        switch (t) {
            case TAbstract(tt, params):
                return typeToCpp(tt.toString());
            case TInst(t, params):
                if (isVar == false) {
                    return StringTools.replace(t.toString(), ".", "_") + "&";
                } else {
                    return StringTools.replace(t.toString(), ".", "_");
                }
            case TFun(args, ret):
                return "Dynamic? ";
            default:
                trace("NOT IMPL TYPE: " + t.getName());
        }
        return null;
    }
    
    private static function typeToCpp(t:String):String {
        switch (t) {
            case "Int":
                return "int";
            case "Void":
                return "void";
            case "Bool":
                return "bool";
            default: 
                trace("UNKNOWN TYPE: " + t);
        }
        
        return null;
    }
    
    static var tabs:String = "";
    private static function printExpr(e:TypedExpr):String {
        switch (e.expr) {
            case TBlock([]): return '$tabs{\n $tabs}\n';
            case TBlock(el):
                var old = tabs;
                tabs += "\t";
                var s = '$old{\n$tabs' + printExprs(el, ';\n$tabs');
                tabs = old;
                s += ';\n$tabs}\n';
                return s;
            case TVar(v, e):
                return printType(v.t, v.name) + " " + printVar(v, e);
            case TNew(c, params, el):
                if (c.get().isExtern == true) {
                    var libName = c.get().name;
                    if (libraries.indexOf(libName) == -1) {
                        libraries.push(libName);
                    }
                }
                return '${printClassPath(c)}(${printExprs(el,", ")})';
            case TCall(e, el):
                return '${printExpr(e)}(${printExprs(el,", ")})';
            case TConst(c):
                // defo hacky!
                switch (e.expr) {
                    case TConst(TString(s)):
                        switch(e.t) {
                            case TAbstract(x, _):
                                if (x.toString() == "Int") {
                                    return s;   // so basically doing some really hack crap here. If you have an untyped static int like:
                                                // public static inline var LED_BUILTIN:Int = untyped 'LED_BUILTIN';
                                                // Then the type and the expr dont match (one is string, one is int), so we'll make the 
                                                // awful assumption its supposed to be an int constant... will likely go completely wrong
                                                // somewhere
                                }
                            case _:
                        }
                    case _:
                }

                return printConstant(c);
            case TField(e, FStatic(c, cf)):
                if (c.get().isExtern == true) {
                    if (c.get().meta.extract(":include") != null && c.get().meta.extract(":include").length > 0) {
                        var include = ExprTools.toString(c.get().meta.extract(":include")[0].params[0]);
                        include = StringTools.replace(include, "\"", "");
                        if (headers.indexOf(include) == -1) {
                            headers.push(include);
                        }
                    }
                    var nativeName:String = "";
                    if (c.get().meta.extract(":native") != null && c.get().meta.extract(":native").length > 0) {
                        nativeName = ExprTools.toString(c.get().meta.extract(":native")[0].params[0]);
                        nativeName = StringTools.replace(nativeName, "\"", "");
                        nativeName += ".";
                    }
                    return nativeName + cf;
                } else {
                    return printClassPath(c) + "::" + cf;
                }
            case TField(e, FInstance(c, params, cf)):
                if (c.toString() == "Array" && cf.toString() == "length") { // more array hack?
                    return 'array_length(${printExpr(e)})';
                }
                return printExpr(e) + "." + cf;
            case TLocal(v):
                return "" + printVar(v, null);
            case TObjectDecl(fields):
                return "Dynamic()";
            case TTypeExpr(m):
                trace(">>>>>>>>>------------- " + m);
            case TReturn(e):
                if (e != null) {
                    return "return " + printExpr(e);
                } else {
                    return "return";
                }
            case TIf(econd, eif, null):
                return 'if (${printExpr(econd)}) ${printExpr(eif)}';
            case TIf(econd, eif, eelse):
                switch (eif.expr) { // MORE HACK????
                    case TBlock(_):
                        return 'if (${printExpr(econd)}) ${printExpr(eif)} ${tabs}else ${printExpr(eelse)}';
                    case _:
                        return 'if (${printExpr(econd)}) ${printExpr(eif)}; else ${printExpr(eelse)}';
                }
                trace(eif);
            case TBinop(op, e1, e2):
                return '${printExpr(e1)} ${printBinop(op)} ${printExpr(e2)}';
            case TParenthesis(el):
                return '(${printExpr(el)})';
            case TArrayDecl(el):
                return '{ ${printExprs(el, ", ")} }';
            case TArray(e1, e2):
                return '${printExpr(e1)}[${printExpr(e2)}]';
            case TWhile(econd, e, normalWhile): 
                return 'while (${printExpr(econd)}) ${printExpr(e)}';
                trace(econd);
            case TUnop(op, true, e1): return printExpr(e1) + printUnop(op);
            case TUnop(op, false, e1): return printUnop(op) + printExpr(e1);
            default: 
                trace("NOT IMPL: " + e.expr);
        }
        
        return "";
    }
    
	public static function printUnop(op:Unop) return switch(op) {
		case OpIncrement: "++";
		case OpDecrement: "--";
		case OpNot: "!";
		case OpNeg: "-";
		case OpNegBits: "~";
	}
    
	public static function printBinop(op:Binop) return switch(op) {
		case OpAdd: "+";
		case OpMult: "*";
		case OpDiv: "/";
		case OpSub: "-";
		case OpAssign: "=";
		case OpEq: "==";
		case OpNotEq: "!=";
		case OpGt: ">";
		case OpGte: ">=";
		case OpLt: "<";
		case OpLte: "<=";
		case OpAnd: "&";
		case OpOr: "|";
		case OpXor: "^";
		case OpBoolAnd: "&&";
		case OpBoolOr: "||";
		case OpShl: "<<";
		case OpShr: ">>";
		case OpUShr: ">>>";
		case OpMod: "%";
		case OpInterval: "...";
		case OpArrow: "=>";
		case OpAssignOp(op):
			printBinop(op)
			+ "=";
	}
    
    public static function printConstant(c:TConstant):String {
        switch (c) {
            case TInt(n):
                return Std.string(n);
            case TNull:
                return "NULL";
            case TString(s):
                return 'String(\"$s\")';
            case TThis:
                return '(*(this))';
            default:
                trace("printConstant: " + c);
        }
        return "";
    }
    
    public static function printClassPath(c:Ref<ClassType>):String {
        var s = StringTools.replace(Std.string(c), ".", "_");
        if (headers.indexOf(s + ".h") == -1) {
            headers.push(s + ".h");
        }
        return s;
    }
    
    public static function printVar(v, e):String {
        var s:String = "";
        
        var isFn = false;
        var isArray = false;
        if (e != null) { // hack??
            switch (v.t) {
                case TFun(args, ret):
                    isFn = true;
                case TInst(t, params):
                    if (t.toString() == "Array") { // array hack??
                        isArray = true;
                    }
                default:    
            }
        }
        
        if (isFn == false) {
            s += v.name;
        }
        if (isArray == true) {
            s += "[]";
        }
        if (e != null && e.expr != null) {
            s += " = ";
            s += printExpr(e);
        }
        return s;    
    }

    public static function printType(type:Type, name:String):String {
        switch (type) {
            case TAbstract(t, p):
                return typeToCpp(t.toString());
            case TInst(t, params):
                if (t.toString() == "Array") { // array hack???
                    return printType(params[0], null);
                }
                return printClassPath(t);
            case TFun(args, ret):
                return '${printType(ret, null)} (*${name})(${printArgs(args, ", ")})';
            case TDynamic(t):
                return "Dynamic";
            case TType(t, params):
                if (params.length > 0) {
                    return printType(params[0], null);
                } else {
                    return "" + StringTools.replace(Std.string(t), ".", "_") + "";
                }
            default:
                trace("UNKNOWN printType: " + type);
                return "UNKNOWN";
        }
        return "";
    }
    
	public static function printExprs(el:Array<TypedExpr>, sep:String) {
		return el.map(printExpr).join(sep);
	}
    
	public static function printArgs(el:Array<{name:String, opt:Bool, t:Type}>, sep:String) {
		var arr:Array<String> = [];
        
        for (e in el) {
            arr.push(printType(e.t, null));
        }
        
        return arr.join(sep);
	}
    
    private static function addIndent(n:Int, sb:StringBuf) {
        for (i in 0...n) {
            sb.add("\t");
        }
    }
}
