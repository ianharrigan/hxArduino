@echo off

del hxArduino.zip /q
7za a hxArduino.zip extraParams.hxml haxelib.json run.n lib src

haxelib submit hxArduino.zip ianharrigan
del hxArduino.zip /q
