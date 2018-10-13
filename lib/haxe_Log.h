#ifndef haxe_Log_h_
#define haxe_Log_h_ 1

#include "Dynamic.h"
#include "haxe_PosInfos.h"

class haxe_Log {
	public:
		static void trace(Dynamic d, haxe_PosInfos pos);
		static void trace(String d, haxe_PosInfos pos);
};

#endif