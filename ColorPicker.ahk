#SingleInstance force

;══════════════════════════════════════════════════════════════════════════════
; Create GUI
   gui, font,s14 w1000 cFF0000, Verdana
   Gui, Add, Text, 	x20 	y20, R
   gui, font,s10 c000000 w400
   Gui, Add, Edit, 	x45 	y20 w60 +right vRed_Value gChange_Red_Value,0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, 	x10 	y50 w110 Range0-255 vRed_Slider gChange_Red_Slider ALtSubmit, 0
   
   gui, font,s14 w1000 C00CC00
   Gui, Add, Text, 	x20 	y90, G
   gui, font,s10 c000000 w400
   Gui, Add, Edit, 	x45 	y90 w60 +right vGreen_Value gChange_Green_Value, 0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, 	x10 	y120 w110 Range0-255 vGreen_Slider gChange_Green_Slider ALtSubmit, 0
   
   gui, font,s14 w1000 C0000FF
   Gui, Add, Text, 	x20 	y160, B
   gui, font,s10 c000000 w400
   Gui, Add, Edit, 	x45 	y160 w60 +right vBlue_Value gChange_Blue_Value, 0
   Gui, Add, UpDown, Range0-255 Wrap, 0
   Gui, Add, Slider, 	x10 	y190 w110 Range0-255 vBlue_Slider gChange_Blue_Slider ALtSubmit, 0
   
   Gui, Add, ListView, x124 y20 h120 w120 ReadOnly 0x4000 +Background000000 VColor_Block
   
   gui, font,s10 c000000 w400,
   Gui, Add, text, x140 y150 +right, Color:
   Gui, Add, Edit, x135 y165 w100 +right VColor_Value ReadOnly
   
   gui, font,s14 w1000 cFF0000
   Gui, Add, Text, 	x20 	y230, R
   gui, font,s14 w1000 C00CC00
   Gui, Add, Text, 	x35 	y230, G
   gui, font,s14 w1000 C0000FF
   Gui, Add, Text, 	x50 	y230, B
   gui, font,s10 c000000 w400
   Gui, Add, Edit, x20 y260 w101 +right vRGB_Value gChange_RGB_Value, Paste_here
   
   Gui, Add, Button, 	x68 	y230 w55 +center gApplyColor, Apply		; y196 Original
   
   Gui, Add, Button, 	x135 y258 w55 +center gGuiClose, Cancel  
   
   Gui, Add, Button, 	x200 y258 w55 +center gClose_And_Save, Save		;  Original:	y196	gCopy_Hex_To_Clipboard, Copy
   
   Gosub Show_New_Color
   
	height_GUI = 290
	width_GUI = 260
	Calc_GUI_Spawn_Point()
	
	Gui, Color, EEEEEE
	Gui, Show, x%x_custom% y%y_custom% h%height_GUI% w%width_GUI%, Color Picker		; original h240
   
   Return
;══════════════════════════════════════════════════════════════════════════════
; Save selected Color to temporary file and then close program

Close_And_Save:
	FileDelete, ColorPick.txt
	GuiControlGet, Color_Value
	FileAppend, %Color_Value%, ColorPick.txt
	FileDelete, ColorPick_Done.txt
	FileAppend, 1, ColorPick_Done.txt
	ExitApp

;══════════════════════════════════════════════════════════════════════════════
; Close program and don't save the ColorPick
	
GuiClose:
	FileDelete, ColorPick_Done.txt
	FileAppend, 2, ColorPick_Done.txt
	ExitApp

;══════════════════════════════════════════════════════════════════════════════
; Slider Action
   Change_Red_Slider:
      GuiControlGet, Red_Slider
      GuiControl, Text, Red_Value, %Red_Slider%
      gosub Show_New_Color
   Return   
   
   Change_Green_Slider:
      GuiControlGet, Green_Slider
      GuiControl, Text, Green_Value, %Green_Slider%
      Gosub Show_New_Color
   Return   
   
   Change_Blue_Slider:
      GuiControlGet, Blue_Slider
      GuiControl, Text, Blue_Value, %Blue_Slider%
      Gosub Show_New_Color
   Return   

;══════════════════════════════════════════════════════════════════════════════
; Value  Boxes Action
Change_Red_Value:
      GuiControlGet, Red_Value
      GuiControl, Text, Red_Slider, %Red_Value%
      Gosub Show_New_Color
   Return   
   
   Change_Green_Value:
      GuiControlGet, Green_Value
      GuiControl, Text, Green_Slider, %Green_Value%
      Gosub Show_New_Color
   Return   
   
   Change_Blue_Value:
      GuiControlGet, Blue_Value
      GuiControl, Text, Blue_Slider, %Blue_Value%
      Gosub Show_New_Color
   Return
   
   Change_RGB_Value:
      GuiControlGet, RGB_Value
      GuiControl, Text, RGB_Value, %RGB_Value%
   Return

   ApplyColor:
	  StringSplit, splitRGB_Value, RGB_Value, %A_Space%
	  GuiControl, Text, Red_Value, %splitRGB_Value1%
	  GuiControl, Text, Green_Value, %splitRGB_Value2%
	  GuiControl, Text, Blue_Value, %splitRGB_Value3%
	  Gosub Show_New_Color
   Return
   
;	250 150 20

;══════════════════════════════════════════════════════════════════════════════
; Update and show new color   
Show_New_Color:
   
   Gui submit, nohide
   
   ; Go Apo
	if Red_Value =
		Red_Value = 0
	if Red_Value < 0
		Red_Value = 0
	if Red_Value > 255
		Red_Value = 255
	
	if Green_Value =
		Green_Value = 0
	if Green_Value < 0
		Green_Value = 0
	if Green_Value > 255
		Green_Value = 255
	
	if Blue_Value =
		Blue_Value = 0
	if Blue_Value < 0
		Blue_Value = 0
	if Blue_Value > 255
		Blue_Value = 255
   
	New_Color_Value=%Red_Value% %Green_Value% %Blue_Value%
	GuiControl, Text, Color_Value, %New_Color_Value%  
	
	;MsgBox, debug 1: %New_Color_Value%
   
   SetFormat, integer, hex
   Red_Value += 0
   Green_Value += 0
   Blue_Value += 0
   SetFormat, integer, d
   
   Stringright,Red_Value,Red_Value,StrLen(Red_Value)-2
   If (StrLen(Red_Value)=1)
      Red_Value=0%Red_Value%
      
   Stringright,Green_Value,Green_Value,StrLen(Green_Value)-2
   If (StrLen(Green_Value)=1)
      Green_Value=0%Green_Value%
      
   Stringright,Blue_Value,Blue_Value,StrLen(Blue_Value)-2
   If (StrLen(Blue_Value)=1)
      Blue_Value=0%Blue_Value%
   
   New_Color_Value=%Red_Value%%Green_Value%%Blue_Value%
   ;MsgBox, debug 2: %New_Color_Value%
   
;   GuiControl, Text, Color_Value, %New_Color_Value%
   GuiControl, +Background%New_Color_Value%, Color_Block
   
Return

;══════════════════════════════════════════════════════════════════════════════
; Hotkey for submitting the value of the RGB field
#IfWinActive SetupGuide
Enter::
StringSplit, splitRGB_Value, RGB_Value, %A_Space%
GuiControl, Text, Red_Value, %splitRGB_Value1%
GuiControl, Text, Green_Value, %splitRGB_Value2%
GuiControl, Text, Blue_Value, %splitRGB_Value3%
Gosub Show_New_Color
Return

;══════════════════════════════════════════════════════════════════════════════
; GUI Spawn Point
Calc_GUI_Spawn_Point()
{
	; requires 2 variables:	height_GUI and width_GUI
	global
	x_custom = %A_ScreenWidth%
	x_custom /= 2
	half_width_GUI = %width_GUI%
	half_width_GUI /= 2
	x_custom -= %half_width_GUI%

	y_custom = %A_ScreenHeight%
	y_custom /= 2
	half_height_GUI = %height_GUI%
	half_height_GUI /= 2
	y_custom -= %half_height_GUI%
	return
}

^Esc::ExitApp
