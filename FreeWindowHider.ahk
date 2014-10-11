#notrayicon
#singleinstance force
gosub iniread
gosub guibuild
tog=1
return


guibuild:
Hotkey, %hide% , hide
Hotkey,%unhide%  , unhide
Hotkey, %options%  , guibuild
Hotkey, %hide% , off
Hotkey,%unhide%  , off
Hotkey, %options%  , off
Gui, Add, Hotkey, x71 y84 w90 h23 vhide, %hide%
Gui, Add, Hotkey, x244 y84 w90 h23 vunhide,%unhide%
Gui, Add, Hotkey, x422 y84 w90 h23 voptions, %options%
Gui, Add, Edit, x22 y165 w230 h57 vhide_title, %hide_title%
Gui, Add, Edit, x287 y165 w225 h57 vclose_title, %close_title%
Gui, Add, Button, x34 y254 w108 h23 gstart, Start
Gui, Add, Button, x169 y254 w102 h23 gstop, Stop
Gui, Add, Button, x416 y244 w107 h24 ghelp, Help
Gui, Add, Button, x416 y272 w107 h24 gabout, About
Gui, Add, Button, x416 y321 w107 h24 giniwrite, Accept
Gui, Add, Text, x169 y88 w72 h13 , Unhide
Gui, Add, Text, x16 y88 w53 h13 , Hide
Gui, Add, Text, x346 y88 w71 h13 , Options
Gui, Add, GroupBox, x10 y236 w279 h52 , Wait for hot keys
Gui, Add, GroupBox, x11 y67 w512 h50 , Hot keys
Gui, Add, GroupBox, x11 y127 w512 h104 , On hotkey "Hide" pressed:
Gui, Add, Text, x23 y147 w228 h13 , Hide windows`, if title containing string:
Gui, Add, Text, x287 y147 w216 h13 , Close windows`, if title containing string:
Gui, Add, Text, x113 y14 w307 h41 ,
Gui, Add, Text, x332 y285 w32 h32 ,
Gui, Add, Picture, x116 y15 w300 h40 ,logo.jpg
Gui, Show, x368 y192 h354 w537, Free Window Hider
Control, disable , , Button1, Free Window Hider
Return



GuiClose:
ExitApp


iniread:
IniRead, hide, settings.ini, Settings, hide , ^f12
IniRead, unhide, settings.ini, Settings, unhide , ^f10
IniRead, options, settings.ini, Settings, options , ^f11
IniRead, hide_title, settings.ini, Settings, hide_title , %A_Space%
IniRead, close_title, settings.ini, Settings, close_title ,  %A_Space%
StringReplace, hide_title,hide_title,+||+,`n , All
StringReplace, close_title,close_title,+||+,`n , All
return


iniwrite:
gui,submit
gui,destroy
StringReplace, hide_title,hide_title,`n, +||+, All
StringReplace, close_title,close_title,`n,+||+ , All
Iniwrite, %hide% , settings.ini, Settings, hide
Iniwrite, %unhide%, settings.ini, Settings, unhide
Iniwrite, %options%, settings.ini, Settings, options
Iniwrite, %hide_title%, settings.ini, Settings, hide_title
Iniwrite, %close_title%, settings.ini, Settings, close_title
gosub action
return

start:
Control, disable , , Button1, Free Window Hider,Free
Control, enable , , Button2, Free Window Hider,Free
tog=1
return

stop:
Control, disable , , Button2, Free Window Hider,Free
Control, enable , , Button1, Free Window Hider,Free
tog=0
return



action:
if tog=0
{
exitapp
}
Hotkey, %hide% , on
Hotkey,%unhide%  , on
Hotkey, %options%  , on
return

hide:
IniRead, value, settings.ini, Settings, hidden , %a_space%
WinGet, id, list, , , Program Manager
Loop, %id%
{
   StringTrimRight, this_id, id%a_index%, 0
   WinGetTitle, this_title, ahk_id %this_id%

Loop, Parse, hide_title , `n
{
	StringGetPos, found, this_title, %A_LoopField%
	if !found
	{
		WinHide , %this_title%
		value=%value%%this_title%+||+
		Iniwrite, %value%, settings.ini, Settings, hidden
	}
}

Loop, Parse, close_title , `n
{
StringGetPos, found, this_title, %A_LoopField%
if !found
{
Winclose , %this_title%
}
}

}
return

about:
msgbox Written By Jason Stallings, please vist jason.stallin.gs
return

help:
run https://github.com/octalmage/FreeWindowHider
return

unhide:
IniRead, value, settings.ini, Settings, hidden , %a_space%
Loop, Parse, value , +||+
{
WinShow,%A_LoopField%
}
Iniwrite, %a_space%, settings.ini, Settings, hidden
return
