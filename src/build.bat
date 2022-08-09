@echo off
cls

REM compile the icon into a .res file
REM uncomment line below to compile the file
RC -fo ../bin/myres.res ./win32/myres.rc 

IF NOT EXIST ..\bin mkdir ..\bin
pushd ..\bin


set debugCompilerFlags=-nologo -FC -Zi -Gm- -GR- -EHa- -Zo -Oi -Zi 

set releaseCompilerFlags=-nologo 

set commonLinkFlags=user32.lib Comdlg32.lib d3d11.lib d3dcompiler.lib Shell32.lib Ole32.lib Shlwapi.lib


@echo Debug Build
cl /DDEBUG_BUILD=1 %debugCompilerFlags% -Od ..\src\win32\win32_main.cpp -FeFlapBirdFlap /link %commonLinkFlags% ./myres.res


rem rem This is the Release option
rem popd 
rem IF NOT EXIST ..\release mkdir ..\release
rem pushd ..\release

rem IF NOT EXIST .\shaders mkdir .\shaders

rem xcopy /s ..\src\shaders\sdf_font.hlsl .\shaders
rem xcopy /s ..\src\shaders\texture.hlsl .\shaders
rem xcopy /s ..\src\shaders\rect_outline.hlsl .\shaders

rem @echo Release Build
rem cl /DDEBUG_BUILD=0 %releaseCompilerFlags% -O2 ..\src\win32\win32_main.cpp -FeTetris /link %commonLinkFlags% ../bin/myres.res


@echo Done

popd 