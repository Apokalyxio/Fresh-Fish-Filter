#SingleInstance force

#Persistent
ToolTip, Loading configurations..., , , 2
;SplashTextOn, 330, 25, Loading..., Loading Configurations. Please wait...

; Default Button (Button which is selected at first for 'Enter') 	->	Gui, Add, Button, Default, OK
; BackgroundTrans for transparent backgrounds on text, controls, etc. when using Pictures as background.

; FileInstall, Source, Dest [, Flag]
; FileInstall, BACKGROUND_arial.png, %a_temp%\BACKGROUND_arial.png

; Adding the PoE Font
font = Fontin-SmallCaps.ttf ; font in %A_WorkingDir%
DllCall( "GDI32.DLL\AddFontResource", str, font) 		;%A_WorkingDir%\Design\Font\
; send WM_FONTCHANGE to all windows:
SendMessage,  0x1D,,,, ahk_id 0xFFFF ; Broadcast the change

GUI_FontSize_Header1 = 22
GUI_FontSize_Header2 = 14
GUI_FontSize_Normal1 = 12
GUI_FontSize_Normal2 = 11

RegRead, AppliedDPI, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI
if AppliedDPI <> 96
{
	if AppliedDPI = 120
	{
		MsgBox, DPI = 120`n`nFontSize will be changed accordingly.
		GUI_FontSize_Header1 = 17
		GUI_FontSize_Header2 = 11
		GUI_FontSize_Normal1 = 9
		GUI_FontSize_Normal2 = 9
	}
	else if AppliedDPI = 144
	{
		MsgBox, DPI = 144`n`nFontSize will be changed accordingly.
		GUI_FontSize_Header1 = 14
		GUI_FontSize_Header2 = 9
		GUI_FontSize_Normal1 = 8
		GUI_FontSize_Normal2 = 7
	}
	else
		msgbox, Warning!`n`nThis program is designed for 96 DPI. Currently`nonly 96, 120 and 144 DPI are supported.`n`nText and Controls may overlap or look weird`nwith a different DPI value.`n`nYour DPI: %AppliedDPI%`n`nFor now please change your DPI to one`nof those settings to resolve those issues.
}


Config_File = LootFilter_config
; Could use 	Apo_Sieve		Or		FreshFishFilter		for the FilterFileName
FilterFileName = Apo_FishFilter

IfExist, %Config_File%_old.txt
	FileDelete, %Config_File%_old.txt
IfExist, %Config_File%_old.tmp.txt
	FileDelete, %Config_File%_old.tmp.txt
IfExist, %FilterFileName%_old.filter
	FileDelete, %FilterFileName%_old.filter
IfExist, %FilterFileName%_old.tmp.filter
	FileDelete, %FilterFileName%_old.tmp.filter


Loop
{
	FileReadLine, line, %Config_File%.txt, %A_Index%
	if ErrorLevel
	{
		; MsgBox %ErrorLevel%		;	<--- works perfectly
		break
	}
	
	if line contains [
	{
		; FileAppend, %line%`n, %UserInput1%_Theater.txt
		Current_SectionName = %line%
	}
	if line contains #
	{
		Wait_for_next_Item = 0
		Current_Item_ID += 1						; 	alternative for:		Current_Item_Name
		Current_Item_Name = %line%
		Count = 1
		StringTrimLeft, Current_Item_Name, Current_Item_Name, %Count%
		if line contains #edited
		{
			StringTrimRight, Current_Item_Name, Current_Item_Name, 7
		}
		continue
	}
	if line =
	{
		if Wait_for_next_Item = 1
		{
			; MsgBox There have been 2 blank lines in a row!				; <---- Program will now be started !
			Break
		}
		Wait_for_next_Item = 1
		continue
	}
	if Wait_for_next_Item = 1
	{
		continue
	}
	if NextLine_TextColor = 1
	{
		NextLine_TextColor = 0
		Change_Default_Preview_Color = 1
		bad_var_name = Text
	}
	if NextLine_BorderColor = 1
	{
		NextLine_BorderColor = 0
		Change_Default_Preview_Color = 1
		bad_var_name = Border
	}
	if NextLine_BackgroundColor = 1
	{
		NextLine_BackgroundColor = 0
		Change_Default_Preview_Color = 1
		bad_var_name = Background
	}
	if NextLine_FontSize = 1
	{
		NextLine_FontSize = 0
		; FontSize = %line%
		FontSize_%Current_Item_Name%_Startup_Value = %line%
		FontSize_%Current_Item_Name%_Startup_Value -= 19
		continue
	}
	if NextLine_AlertSound = 1
	{
		NextLine_AlertSound = 0
		AlertSound_%Current_Item_Name%_Startup_Value = %line%
		continue
	}
	if NextLine_DropLevel = 1
	{
		NextLine_DropLevel = 0
		DropLevel_%Current_Item_Name%_Startup_Value = %line%
		continue
	}
	if NextLine_CheckBox_DH = 1
	{
		NextLine_CheckBox_DH = 0
		if line = 1
		{
			CheckBox_%Current_Item_Name%_Startup_Value = %line%
			CheckBox2_%Current_Item_Name%_Startup_Value = 0
			continue
		}
		if line = 2
		{
			CheckBox2_%Current_Item_Name%_Startup_Value = %line%
			CheckBox_%Current_Item_Name%_Startup_Value = 0
			continue
		}
		CheckBox_%Current_Item_Name%_Startup_Value = 0
		CheckBox2_%Current_Item_Name%_Startup_Value = 0
		continue
	}
	if NextLine_SelectedBuild = 1
	{
		NextLine_SelectedBuild = 0
		DDL_Build_Startup_Value = %line%
		continue
	}
	if NextLine_SelectedDefence = 1
	{
		NextLine_SelectedDefence = 0
		DDL_Defence_Startup_Value = %line%
		continue
	}
	if NextLine_CheckBoxValue = 1
	{
		NextLine_CheckBoxValue = 0
		CheckBox_Startup_Value_animate_weapon = %line%
		continue
	}
	
	if Change_Default_Preview_Color = 1
	{
		Change_Default_Preview_Color = 0
		
		StringSplit, split_line, line, %A_Space%
		Red_Value = %split_line1%
		Green_Value = %split_line2%
		Blue_Value = %split_line3%
		Trans_Value = %split_line4%				; Transparency is not yet supported !
		
		; MsgBox, RGB Values: %Red_Value% %Green_Value% %Blue_Value%

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


		New_Color_Value =%Red_Value%%Green_Value%%Blue_Value%
		; MsgBox, debug 2: %New_Color_Value%
		
		; ColorStartup_RGB_fishing_rod_Text
		; %Current_Item_Name%
		ColorStartup_RGB_%Current_Item_Name%_%bad_var_name% = %New_Color_Value%
		if bad_var_name = Text
			StartupRemember_TextColor_%Current_Item_Name% = %New_Color_Value%
		; MsgBox ColorValue: %New_Color_Value%
		continue
	}
	
	if line contains SetTextColor
	{
		NextLine_TextColor = 1
		continue
	}
	if line contains SetBorderColor
	{
		NextLine_BorderColor = 1
		continue
	}
	if line contains SetBackgroundColor
	{
		NextLine_BackgroundColor = 1
		continue
	}
	if line contains SetFontSize
	{
		NextLine_FontSize = 1
		continue
	}
	if line contains PlayAlertSound
	{
		NextLine_AlertSound = 1
		continue
	}
	if line contains CheckBox_DH
	{
		NextLine_CheckBox_DH = 1
		continue
	}
	if line contains DropLevel
	{
		NextLine_DropLevel = 1
		continue
	}
	if line contains SelectedBuild
	{
		NextLine_SelectedBuild = 1
		continue
	}
	if line contains SelectedDefence
	{
		NextLine_SelectedDefence = 1
		continue
	}
}
StringSplit, DDL_Build_Startup_Value_split, DDL_Build_Startup_Value, %A_Space%
DDL_Build_Startup_Value = %DDL_Build_Startup_Value_split1%
Loop, 4
{
	DDL_Build_Startup_Value_split%A_Index% =
}
StringSplit, DDL_Defence_Startup_Value_split, DDL_Defence_Startup_Value, %A_Space%
DDL_Defence_Startup_Value = %DDL_Defence_Startup_Value_split1%
Loop, 4
{
	DDL_Defence_Startup_Value_split%A_Index% =
}

ToolTip, Creating the Graphical User Interface..., , , 2
SplashTextOn, 330, 25, Loading..., Creating the Graphical User Interface. Please wait...


;  ══════════════════════════════════════( Graphical User Interface )════════════════════════════════════════
height_GUI = 600
width_GUI = 800
Calc_GUI_Spawn_Point()
Gui, 1:Default
Gui, Add, Picture, x0 y0 w370 h600 +BackgroundTrans vPic_Background, %A_WorkingDir%\Design\LEFT.png
;Gui, Add, Picture, x50 y50 vPic_tab1, %A_WorkingDir%\Design\Semi_trans.png

; gui, font, s%GUI_FontSize_Header1% w1000 C0000FF
; Gui, Add, Text, x25 y8 w300 h30 , Fresh Fish Filter
; Gui, font,,
; gui, font, s%GUI_FontSize_Normal1%
; Gui, Add, Text, x25 y38 w300 h20 , by Apokalyxio
; Gui, font,,

gui, font, s%GUI_FontSize_Header2% w600 C000000, ;Fontin SmallCaps
;Gui, Add, GroupBox, xm-17 ym+80 Section w352 h100 -E0x200, Standard Filter
Gui, Add, Text, 		x18 		y100 	w352 	h100 Section vMakeTrans1, Standard Filter
; Gui, Add, Text, x12 y55 w340 h40 , Standard Filter
gui, font, s%GUI_FontSize_Normal1% w500
Gui, Add, Text, 		xs+1 	ys+25 	w330 	h70 vMakeTrans2, If you just want to use the normal filter, click the button below!
Gui, font,
gui, font, s%GUI_FontSize_Normal2%
Gui, Add, Button, 		xs+206 	ys+55 	w110 	h30 Default vButton1 gUse_Standard_Filter, Standard Filter
gui, font, s%GUI_FontSize_Header2% w600 CBB7700 underline
Gui, Add, Text, 		xs+316 	ys+58 	w25 	h25 center +BackgroundTrans vButton1_Text gMakeToolTipWork_1, ?
Gui, font,
Button1_Text_TT := "This will put the Standard Filter into your `nDocuments/MyGames/Path of Exile folder.`n`nAfter clicking on this you can directly select`nthe filter ingame."

; vMakeTrans1
gui, font, s%GUI_FontSize_Header2% w600 C000000, ;Fontin SmallCaps
; ym+390 for bottom location
Gui, Add, Text, 		x18 		y277 	w352 	h25 vMakeTrans3 Section, Customized Filter
Gui, font,
Gui, Add, DropDownList, xs+87 	ys+35 	w150 	h146 Choose%DDL_Build_Startup_Value% 	vDDL1_Selected gDDL1_Action, 1  Bow|2  Caster|3  Caster - no shield|4  Melee|5  Melee - 2h|6  Melee - 1h|7  Melee - dual wield|8  Melee - unarmed|0  Reset to Default
	Gui, font, s%GUI_FontSize_Header2% w600 CBB7700 underline
	Gui, Add, Text, 	xs+237 	ys+32 	w25 	h25 center +BackgroundTrans vHeader5_Text gMakeToolTipWork_7 , ?
	Header5_Text_TT := "This will additionally hide items (weapons,`nquivers, shields) which would be useless`nfor your selected build.`n`nFor example, when you select Bow it will`nhide melee weapons, wands and shields.`n`nThis won't hide any chance bases  or good`nitems like Ambushers!"
	Gui, font,
Gui, Add, DropDownList, xs+87 	ys+75 	w150 	h146 Choose%DDL_Defence_Startup_Value% 	vDDL2_Selected gDDL2_Action, 1  Armour|2  Evasion|3  Engery Shield|4  Armour - Evasion|5  Armour - Energy Shield|6  Evasion - Energy Shield|0  Reset to Default
	Gui, font, s%GUI_FontSize_Header2% w600 CBB7700 underline
	Gui, Add, Text, 	xs+237 	ys+72 	w25 	h25 center +BackgroundTrans vHeader6_Text gMakeToolTipWork_7 , ?
	Header6_Text_TT := "This will additionally hide items, which`nare useless for you.`n`nFor example, when you select Armour`nit will hide Evasion and Energy Shield`nitems.`n`nCurrently only works with high level`nBody Armours!`n`nThis won't hide any chance bases!"
	Gui, font,
Gui, font, s%GUI_FontSize_Normal1% w560
Gui, Add, Text, 		xs+2 	ys+35 	w80 	h20 	vMakeTrans4 Right , Build:
Gui, Add, Text, 		xs+2 	ys+75	w80 	h20 	vMakeTrans5 Right , Defence:
Gui, font,
Gui, font, s%GUI_FontSize_Normal1% w500
Gui, Add, Text, 		xs+2 	ys+110 	w340 	h70 vMakeTrans6 , For using the customized filter, please click the button below!
Gui, font, 
Gui, font, s%GUI_FontSize_Normal2%
Gui, Add, Button, 		xs+207 	ys+140 	w110 	h30 Default vButton2 gButton_Customized_Filter, Customize Filter
Gui, font, s%GUI_FontSize_Header2% w600 CBB7700 underline
Gui, Add, Text, 		xs+316 	ys+143 	w25 	h25 center +BackgroundTrans vButton2_Text gMakeToolTipWork_2, ?
Gui, font,
Button2_Text_TT := "This will put your Customized Filter into your`nDocuments/MyGames/Path of Exile folder.`n`nAfter clicking on this you can directly select `nthe filter ingame."

gui, font, s%GUI_FontSize_Header2% w600 C000000
Gui, Add, Text, 		x18 		y524 	w220 	h30 Section vMakeTrans7 , Select Filter ingame
gui, font, s%GUI_FontSize_Normal1% w500
Gui, Add, Text, 		xs+18 	ys+32 	w120 	h30 vMakeTrans8, HowTo Guide:
Gui, font,
Gui, Add, Button, 		xs+164 	ys+30 	w110 	h25 vSetup_Guide_Button0 gAction_Setup_Guide_all, Open full Guide		; This starts my custom ImageViewer

Gui, Show, x%x_custom% y%y_custom% h%height_GUI% w%width_GUI%, FreshFishFilter

; Sub-tabs for the Currency Main-tab
Gui, Add, Tab, x371 y30 w425 h599 hwndHwndTabCurrency vSubTab_3 gGoSubTab3, Normal|Sockets && Links
GuiControl, Hide, SubTab_3
Gui, Tab, 1
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_3a, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 3
	
	GroupName = mirror_of_kalandra
	GroupHeader = Mirror of Kalandra
	GroupPosition = 1
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = exalted_orb
	GroupHeader = Ex, Et, Divine
	GroupPosition = 2
	GroupTooltip := " Eternal Orb `nExalted Orb `nDivine Orb"
	Create_GUI_GroupBox()
	
	GroupName = high_value_currency
	GroupHeader = High Value Currency
	GroupPosition = 3
	GroupTooltip := "Gemcutter's Prism `nRegal Orb `nChaos Orb `nOrb of Regret `nVaal Orb `nBlessed Orb `nOrb of Fusing `nOrb of Scouring `nOrb of Alchemy `nGlassblower's Bauble `nCartographer's Chisel"
	Create_GUI_GroupBox()
	
	GroupName = remaining_worthwhile_currency
	GroupHeader = Low Value Currency
	GroupPosition = 4
	GroupTooltip := "Orb of Chance `nJeweller's Orb `nOrb of Alteration `nChromatic Orb `nBlacksmith's Whetstone `nArmourer's Scrap"
	Create_GUI_GroupBox()
	
	GroupName = rest_of_currency
	GroupHeader = Rest of Currency
	GroupPosition = 5
	GroupTooltip =
	Create_GUI_GroupBox()

Gui, Tab, 2
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_3b, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 3
	
	GroupName = 6_sockets
	GroupHeader = 6 Sockets
	GroupPosition = 1
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = chromatic_items
	GroupHeader = Chromatic Items
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()


; Sub-tabs for the Map Main-tab
Gui, Add, Tab, x371 y30 w425 h599 hwndHwndTabMaps vSubTab_4 gGoSubTab4, High Maps|Low Maps|Fragments
GuiControl, Hide, SubTab_4
Gui, Tab, 1
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_4a, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 4
	
	GroupName = lvl_80_maps
	GroupHeader = 80+ Maps
	GroupPosition = 1
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = lvl_78_maps
	GroupHeader = 79 && 78 Maps
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = lvl_76_maps
	GroupHeader = 77 && 76 Maps
	GroupPosition = 3
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = lvl_74_maps
	GroupHeader = 75 && 74 Maps
	GroupPosition = 4
	GroupTooltip =
	Create_GUI_GroupBox()

Gui, Tab, 2
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_4b, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 4
	
	GroupName = lvl_72_maps
	GroupHeader = 73 && 72 Maps
	GroupPosition = 1
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = lvl_70_maps
	GroupHeader = 71 && 70 Maps
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = rest_of_maps
	GroupHeader = Rest of Maps
	GroupPosition = 3
	GroupTooltip := "This doesn't include Unique maps!`n`nWill only apply to normal, magic`nand rare maps!"
	Create_GUI_GroupBox()

Gui, Tab, 3
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_4c, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 4
	
	GroupName = midnight_and_hope
	GroupHeader = Midnight and Hope
	GroupPosition = 1
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = rest_of_fragments
	GroupHeader = Rest of Fragments
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()
	


; Sub-tabs for the Rares Main-tab
Gui, Add, Tab, x371 y30 w425 h599 hwndHwndTabRares vSubTab_6 gGoSubTab6, Jewellry|Rest of Rares|Uniques
GuiControl, Hide, SubTab_6
Gui, Tab, 1
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_6a, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 6
	
	GroupName = ilvl_75_jewellry
	GroupHeader = ilvl 75+ Jewellry
	GroupPosition = 1
	GroupTooltip := ""
	Create_GUI_GroupBox()
	
	GroupName = ilvl_60_jewellry
	GroupHeader = ilvl 60+ Jewellry
	GroupPosition = 2
	GroupTooltip := ""
	Create_GUI_GroupBox()
	
	GroupName = rest_of_jewellry
	GroupHeader = Rest of Jewellry
	GroupPosition = 3
	GroupTooltip := ""
	Create_GUI_GroupBox()

Gui, Tab, 2
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_6b, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 6
	
	GroupName = ilvl_75_rest_of_rares
	GroupHeader = ilvl 75+ Rares
	GroupPosition = 1
	GroupTooltip := ""
	Create_GUI_GroupBox()
	
	GroupName = ilvl_60_rest_of_rares
	GroupHeader = ilvl 60+ Rares
	GroupPosition = 2
	GroupTooltip := ""
	Create_GUI_GroupBox()

Gui, Tab, 3
	Gui, Add, Picture, x370 y52 w430 h548 +BackgroundTrans vPic_Right_6c, %A_WorkingDir%\Design\RIGHT_trans_SUB.png
	Overlay_ID = 6
	
	GroupName = valuable_uniqs
	GroupHeader = Valuable Uniques
	GroupPosition = 1
	GroupTooltip := "Changeable:`nVoidBattery, Mjolner, Kaom's Heart, Shavronne's Wrappings, Soul Taker,`nWindripper, Voltaxic Rift, Thunderfist, Atziri's Splendour, Atziri's Acuity,`nAtziri's Disfavour, Hegemony's Era, Pledge of Hands, Taste of Hate`n`nAlso highlighted (not changeable atm):`nHeadhunter, Auxium, Death Rush, Gifts from Above, Shavronne's Revelation,`nVictario's Acuity, Valako's Sign, Daresso's Salute, The Dark Seer, The Harvest,`nEdge of Madness, Null and Void, Shadows and Dust, Voll's Devotion`n`nRace Rewards (not changeable atm):`nDemigod's Stride, Demigod's Triumph, Demigod's Touch, Demigod's Eye`n`nTroll Highlights (for the greater good):`nTroll Mantle(can't highlight only Shavs)"
	Create_GUI_GroupBox()
	
	GroupName = rest_of_uniqs
	GroupHeader = Rest of Uniques
	GroupPosition = 2
	GroupTooltip := ""
	Create_GUI_GroupBox()


Gui, Add, Tab2, x370 y0 w429 h599 hwndHwndTabMain vTab_1 gGoTab1, Main|RNG|Currency|Maps|Gems|Rares|Flasks|General|fix_later
Gui, font,

Gui, Tab, Main
	Gui, Add, Picture, x370 y23 vPic_RIGHT_Main, %A_WorkingDir%\Design\RIGHT_Main.png
	; Introduction, This program will make it easier to use and customize a filter! :D
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y40 w340 h25 vMakeTrans9 Section, Tabs
	gui, font, s%GUI_FontSize_Normal1% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w380 h70 vMakeTrans10 , Click the buttons on the top side of this window to cycle through the different available tabs and customize everything as you like!
	Gui, font, 
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y127 w340 h25 vMakeTrans11 Section, Item Preview
	gui, font, s%GUI_FontSize_Normal1% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w380 h70 vMakeTrans12 , If the default text color is grey/white, then it can't be changed. For example Chromatic Items, as they can have different rarity. This might be changed later!
	Gui, font, 
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y215 w340 h25 vMakeTrans13 Section, Customized Filter
	gui, font, s%GUI_FontSize_Normal2% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w380 h70 vMakeTrans14 , All changes will be saved right away. When you are happy with your adjustments you can then use and your customized Filter ingame by clicking the 'Customize Filter' button. Generating the custom filter might take a few seconds!
	Gui, font, 
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y305 w340 h25 vMakeTrans15 Section, Build and Defence
	gui, font, s%GUI_FontSize_Normal2% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w390 h70 vMakeTrans16 , You can choose a build and defence with the dropdownlists on the left. Depending on what you choose it will then hide items that are useless for your build. Build-specific highlighting for interesting items will be added soon!
	Gui, font, 
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y400 w340 h25 vMakeTrans17 Section, Animate Weapon
	gui, font, s%GUI_FontSize_Normal2% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w380 h70 vMakeTrans18 , Activate and customize specific filtering for Animate Weapon in the 'General' tab at the top!
	Gui, font,
	gui, font, s%GUI_FontSize_Header2% w600 C364649
	Gui, Add, Text, x386 y465 w340 h25 vMakeTrans19 Section, Feedback
	gui, font, s%GUI_FontSize_Normal1% w500 C000000
	Gui, Add, Text, xs+10 ys+22 w380 h70 vMakeTrans20 , If you have any feedback, then please contact me at:
	Gui, font,
	gui, font, s%GUI_FontSize_Header2% w600
	; Gui, Add, Text, x437 y558 w110 h30 , My Email:
	Gui, Add, Edit, xs+2 ys+42 w255 -E0x200 +center vEmail_Copy_Field ReadOnly, filterfeedback@gmail.com
	GuiControl +BackgroundECDE9B, Email_Copy_Field
	Gui, font, 
	
	gui, font, s%GUI_FontSize_Normal2%
	Gui, Add, Text, x397 y558 w376 h33 center +BackgroundTrans, This program is fan-made and not affiliated with Grinding Gear Games in any way.
	Gui, font,
	
	; Gui, Add, DropDownList, x492 y70 w100 h20 , DropDownList


Gui, Tab, RNG
	Gui, Add, Picture, x370 y23 w430 h600 +BackgroundTrans vPic_Right_2, %A_WorkingDir%\Design\RIGHT_trans.png
	Overlay_ID = 2
	
	GroupName = fishing_rod
	GroupHeader = Fishing Rod
	GroupPosition = 1
	GroupTooltip := "Don't forget to use your`nFairgrave's Tricorne!"
	Create_GUI_GroupBox()
	
	GroupName = albino_rhoa_feather
	GroupHeader = Albino Rhoa Feather
	GroupPosition = 2
	GroupTooltip := ""
	Create_GUI_GroupBox()
	
	GroupName = 6_linked_items
	GroupHeader = 6-linked Items
	GroupPosition = 3
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = 5_links
	GroupHeader = 5-linked Items
	GroupPosition = 4
	GroupTooltip =
	Create_GUI_GroupBox()
	

Gui, Tab, Currency
	; This Tab has SubTabs and hence all of it's contents are in those other tabs, which are only shown while the rare-tab is active.


Gui, Tab, Maps
	; This Tab has SubTabs and hence all of it's contents are in those other tabs, which are only shown while the rare-tab is active.


Gui, Tab, Gems
	Gui, Add, Picture, x370 y23 w430 h577 +BackgroundTrans vPic_Right_5, %A_WorkingDir%\Design\RIGHT_trans.png
	Overlay_ID = 5
	
	GroupName = valuable_gems
	GroupHeader = Valuable Gems
	GroupPosition = 1
	GroupTooltip = Empower `nEnhance `nEnlighten `nPortal `nDetonate Mines `nItem Quantity
	Create_GUI_GroupBox()
	
	GroupName = vaal_gems
	GroupHeader = Vaal Gems
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = quality_14_gems
	GroupHeader = 14+ Quality Gems
	GroupPosition = 3
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = quality_gems
	GroupHeader = Rest of Quality Gems
	GroupPosition = 4
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = jewels_all
	GroupHeader = Jewels
	GroupPosition = 5
	GroupTooltip =
	Create_GUI_GroupBox()


Gui, Tab, Rares
	; This Tab has SubTabs and hence all of it's contents are in those other tabs, which are only shown while the rare-tab is active.


Gui, Tab, Flasks
	Gui, Add, Picture, x370 y23 w430 h577 +BackgroundTrans vPic_Right_7, %A_WorkingDir%\Design\RIGHT_trans.png
	Overlay_ID = 7
	
	GroupName = utility_flasks
	GroupHeader = Utility Flasks
	GroupPosition = 1
	GroupTooltip = Diamond `nGranite `nJade `nQuicksilver `nRuby `nSapphire `nTopaz
	Create_GUI_GroupBox()
	
	GroupName = max_qual_flasks
	GroupHeader = Max qual Flasks
	GroupPosition = 2
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = quality_flasks_leveling
	GroupHeader = qual Flasks ilvl 1-59
	GroupPosition = 3
	GroupTooltip =
	Create_GUI_GroupBox()
	
	GroupName = quality_flasks_normal
	GroupHeader = Quality Flasks Rest
	GroupPosition = 4
	GroupTooltip =
	Create_GUI_GroupBox()


Gui, Tab, General
	Gui, Add, Picture, x370 y23 w430 h577 +BackgroundTrans vPic_Right, %A_WorkingDir%\Design\RIGHT_trans.png
	Overlay_ID = 8
	
	GroupName = group_animate_weapon_name
	GroupHeader = Animate Weapon
	GroupPosition = 1
	GroupTooltip := "If you want to use Animate Weapon then`nchange  the DropLevel value to 0.`n`nThis will affect all normal rarity`nmelee weapons."
	Create_GUI_GroupBox()
	
	; GroupName = general_show
	gui, font, s%GUI_FontSize_Normal1% w600 C0000FF
	Gui, Add, GroupBox, 	x380 	y210 	w412 	h100 	Section, Show - normal and magic
	Gui, font,
	gui, font, s%GUI_FontSize_Header1% w1000 CFF0000
	Gui, Add, Text, 		xs+7 	ys-25 	w280 	h30 Left, 	Work in progress!
	Gui, font,
	gui, font, s%GUI_FontSize_Normal2% w550
	Gui, Add, CheckBox, 	xs+20 	ys+25 	w120 	h20 		vCheckBoxValue_7 	, %A_Space%Helmets
	Gui, Add, CheckBox, 	xs+150 	ys+25 	w120 	h20 		vCheckBoxValue_8	, %A_Space%Gloves
	Gui, Add, CheckBox, 	xs+280	ys+25 	w120 	h20 		vCheckBoxValue_9 	, %A_Space%Boots
	Gui, Add, CheckBox, 	xs+20 	ys+50 	w120 	h20 		vCheckBoxValue_10 , %A_Space%Amulets
	Gui, Add, CheckBox, 	xs+150 	ys+50 	w120 	h20 		vCheckBoxValue_11	, %A_Space%Rings
	Gui, Add, CheckBox, 	xs+280	ys+50 	w120 	h20 		vCheckBoxValue_12 , %A_Space%Belts
	Gui, Add, CheckBox, 	xs+20 	ys+75 	w120 	h20 		vCheckBoxValue_13 , %A_Space%Two Hand
	Gui, Add, CheckBox, 	xs+150 	ys+75 	w120 	h20 		vCheckBoxValue_14	, %A_Space%One Hand
	Gui, Add, CheckBox, 	xs+280	ys+75 	w120 	h20 		vCheckBoxValue_15 , %A_Space%Bows
	Gui, font,
	
	; GroupName = general_hide
	gui, font, s%GUI_FontSize_Normal1% w600 C0000FF
	Gui, Add, GroupBox, 	x380 	y420 	w412 	h100 	Section, Hide - normal and magic
	Gui, font,
	gui, font, s%GUI_FontSize_Header1% w1000 CFF0000
	Gui, Add, Text, 		xs+7 	ys-25 	w280 	h30 Left, 	Work in progress!
	Gui, font,
	gui, font, s%GUI_FontSize_Normal2% w550
	Gui, Add, CheckBox, 	xs+150 	ys+25 	w125 	h20 		vCheckBox2 , %A_Space%20`%Ele Sceptres
	Gui, Add, CheckBox, 	xs+280 	ys+25 	w125 	h20 		vCheckBox3 , %A_Space%80`%Crit Daggers
	Gui, Add, CheckBox, 	xs+20 	ys+25 	w125 	h20 		vCheckBox4 , %A_Space%Hammers
	Gui, Add, CheckBox, 	xs+150 	ys+50 	w125 	h20 		vCheckBox5 , %A_Space%ALL Bows
	Gui, Add, CheckBox, 	xs+20 	ys+50 	w125 	h20 		vCheckBox6 , %A_Space%ALL Two Hand
	Gui, Add, CheckBox, 	xs+20 	ys+75 	w125 	h20 		vCheckBox1 gCheckBox1_Action, %A_Space%On/Off_MsgBox
	CheckBox1_TT := "This is just for testing Tooltips!"
	Gui, font,
	
	gui, font, s%GUI_FontSize_Normal1% w560 underline
	Gui, Add, Text, x652 y318 w100 h20 , Alpha only!
	Gui, font,
	gui, font, s%GUI_FontSize_Normal2%
	Gui, Add, Button, x452 y340 w100 h30 vButton4 gDoSomething, RNG Booster
	Gui, Add, Button, x652 y340 w100 h30 vButton3 gGuiClose, Exit
	Gui, font,


Gui, Tab, fix_later
	Gui, Add, Picture, x370 y23 w430 h577 +BackgroundTrans vPic_Right_9, %A_WorkingDir%\Design\RIGHT_trans.png
	Overlay_ID = 9
	
	gui, font, s%GUI_FontSize_Header1% w1000 CFF0000
	Gui, Add, Text, 		x380 	y30 	w410 	h30 center, 	Placeholder!
	Gui, font,
	


; Gosub Show_New_Color
ToolTip, , , , 2
SplashTextOff

; Apo's Loot Filter
;Gui -DPIScale
Loop, 20
{
	GuiControl +BackgroundTrans, MakeTrans%A_Index%
}
;Gui +LastFound  ; Make the GUI window the last found window for use by the line below.
;WinSet, TransColor, EEEEEE		; Would make almost everything completely transparent (could even click through the window... lol)


Gui, Color, DDDDDD
GuiControl, Show, Pic_Background
Gui, Show, x%x_custom% y%y_custom% h%height_GUI% w%width_GUI%, FreshFishFilter


OnMessage(0x200, "WM_MOUSEMOVE")
SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 0, 1, , ahk_id %HwndTabMain%
SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 0, 1, , ahk_id %HwndTabCurrency%
SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 0, 1, , ahk_id %HwndTabMaps%
SendMessage, TCM_HIGHLIGHTITEM := 0x1333, 0, 1, , ahk_id %HwndTabRares%

; SetupGuideStart
Build_SetupGuide_GUI()


Return

GuiClose:
	ExitApp


;══════════════════════════════════════( Build GUI GroupBox  )════════════════════════════════════════
Create_GUI_GroupBox()
{
	global
	
	GroupPosition *= 110
	GroupPosition -= 55
	Gui, Add, Picture, 	x380 	y%GroupPosition% 	w412 	h100 +BackgroundTrans vPic_Box_%GroupName%, %A_WorkingDir%\Design\BOX.png
	Gui, font,
	Gui, font, s%GUI_FontSize_Normal1% w600 C364649
	Gui, Add, Text, 	x389 	y%GroupPosition% 	w220 	h22  +BackgroundTrans 	Section, %GroupHeader%
	;Gui, Add, GroupBox, 	x380 	y%GroupPosition% 	w412 	h100 	Section, %GroupHeader%
	Gui, font,
	if GroupTooltip <>
	{
		;GroupTooltip = Empower `nEnlighten `nPortal `nItem Quantity `nMultistrike `nSpell Echo
		gui, font, s%GUI_FontSize_Normal1% w600 CBB7700 underline
		Gui, Add, Text, xs+165 	ys+0 			w25 	h25 vShowTooltip_%GroupName% gMakeToolTipWork_1 +BackgroundTrans center, ?
		Gui, font,
		ShowTooltip_%GroupName%_TT = %GroupTooltip%
	}
	ColorPreview_Text_DoubleRef = % ColorStartup_RGB_%GroupName%_Text
	if ColorPreview_Text_DoubleRef =
		ColorPreview_Text_DoubleRef = EEEEEE
	ColorPreview_Border_DoubleRef = % ColorStartup_RGB_%GroupName%_Border
	if ColorPreview_Border_DoubleRef =
		ColorPreview_Border_DoubleRef = EEEEEE
	ColorPreview_Background_DoubleRef = % ColorStartup_RGB_%GroupName%_Background
	if ColorPreview_Background_DoubleRef =
		ColorPreview_Background_DoubleRef = EEEEEE
	
	CheckBox_DoubleRef = % CheckBox_%GroupName%_Startup_Value
	if CheckBox_DoubleRef =
		CheckBox_DoubleRef = 0
	CheckBox2_DoubleRef = % CheckBox2_%GroupName%_Startup_Value
	if CheckBox2_DoubleRef =
		CheckBox2_DoubleRef = 0
	
	FontSize_DoubleRef = % FontSize_%GroupName%_Startup_Value
	if FontSize_DoubleRef =
		FontSize_DoubleRef = 13
	AlertSound_DoubleRef = % AlertSound_%GroupName%_Startup_Value
	if AlertSound_DoubleRef =
		AlertSound_DoubleRef = 0
	
	Preview_Text_Size = %FontSize_DoubleRef%
	Preview_Text_Size += 19
	Preview_Text_Size /= 3.2						; Will use this value for the font size of Preview Text itself and also for calculating the Preview_Field_Factor
	
	Preview_Field_Factor = %Preview_Text_Size%
	Preview_Field_Factor /= 10.0					; to get a float (1.1 instead of 1) output you have to use 10.0 instead of 10 
	
	Border_Preview_W = % Preview_Field_Factor *156 +4
	Border_Preview_H = % Preview_Field_Factor *18 +4
	Background_Preview_W = % Preview_Field_Factor *156
	Background_Preview_H = % Preview_Field_Factor *18
	Text_Preview_Field_W = % Preview_Field_Factor *156 -2
	; MsgBox, Border_W: %Border_Preview_W%`n`nBorder_H: %Border_Preview_H%`n`nBackground_W: %Background_Preview_W%`n`nBackground_H: %Background_Preview_H%
	
	Gui, Add, Text, 		xs+0 	ys+22 	w45 	h15 		Left +BackgroundTrans, Preview:
	Gui, Add, Text, 		xs-4 	ys+76 	w45 	h15 		Left +BackgroundTrans, Change
	Gui, Add, Button, 		xs+35 	ys+73 	w40 	h20 		gRunColorPicker_%GroupName%_Text vChangeColorButton_%GroupName%_Text, Text
	
	Gui, Add, ListView, 	xs+0 	ys+38 	w%Border_Preview_W% 	h%Border_Preview_H% 		ReadOnly -E0x200 0x4000 +Background%ColorPreview_Border_DoubleRef% VColorPreview_%GroupName%_Border
	Gui, Add, Button, 		xs+80 	ys+73 	w50 	h20 		gRunColorPicker_%GroupName%_Border vChangeColorButton_%GroupName%_Border, Border
	
	Gui, Add, ListView, 	xs+2 	ys+40 	w%Background_Preview_W% 	h%Background_Preview_H% 		ReadOnly -E0x200 0x4000 +Background%ColorPreview_Background_DoubleRef% VColorPreview_%GroupName%_Background
	Gui, Add, Button, 		xs+135 	ys+73 	w80 	h20 		gRunColorPicker_%GroupName%_Background vChangeColorButton_%GroupName%_Background, Background
	
	RefreshTextColor%GroupName% = %ColorPreview_Text_DoubleRef%
	RefreshBackgroundColor%GroupName% = %ColorPreview_Background_DoubleRef%
	;MsgBox, % RefreshTextColor%GroupName%
	
	; MsgBox, Groupname: %GroupName%`n`nTextSize: %Preview_Text_Size%`n`nPreview_Field_Factor: %Preview_Field_Factor%`n`nChooseDDL: %FontSize_DoubleRef%`n(starts with 20, so +19 for every value)
	Item_Preview_Example = %GroupHeader%
	Check_for_better_Item_Preview_Example()
	Gui, font, s%Preview_Text_Size% w560, Fontin SmallCaps
	Gui, Add, Text, 		xs+4 	ys+40 	w%Text_Preview_Field_W% 	h40 		Center +BackgroundTrans c%ColorPreview_Text_DoubleRef% VColorPreview_%GroupName%_Text, %Item_Preview_Example%
	Gui, font,
	
	Gui, Add, CheckBox, 	xs+215 	ys+15 	w112 	h20 		gCheckBox_Action_%GroupName% vCheckBox_Selected_%GroupName% Right +BackgroundTrans Checked%CheckBox_DoubleRef% , %A_Space%Disable Highlighting
	CheckBox_Selected_%GroupName%_TT := "This will change the appearance for items`nfrom this section back to vanilla."
	Gui, Add, CheckBox, 	xs+350 	ys+15 	w47 	h20 		gCheckBox_Action_%GroupName% vCheckBox2_Selected_%GroupName% Right +BackgroundTrans Checked%CheckBox2_DoubleRef% , %A_Space%Hide
	CheckBox2_Selected_%GroupName%_TT := "This will COMPLETELY HIDE items`nfrom this section!`n`nOnly use this, if you DON'T want to`nsee items from this section"
	Gui, Add, Text, 		xs+223 	ys+45 	w65 	h15 		Right +BackgroundTrans, Font Size:
	Gui, Add, DropDownList, xs+292 	ys+40 	w60 	h126 	gDDL_Action_Font_Size_%GroupName% vDDL_Selected_Font_Size_%GroupName% Choose%FontSize_DoubleRef%, 20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44
	if GroupName = group_animate_weapon_name
	{
		DropLevel_DoubleRef = % DropLevel_%GroupName%_Startup_Value
		Gui, Add, Text, 		xs+225 	ys+75 	w65 	h15 		Right +BackgroundTrans, Drop Level:
		; fixthis maybe - Using the AlertSound for DropLevel as currently the DropLevel Edit always replaces the AlertSound DropDownList
		Gui, Add, Edit, 		xs+300 	ys+70 	w60 	h20	 	Number Limit3 gDDL_Action_Alert_Sound_%GroupName% vDDL_Selected_Alert_Sound_%GroupName%, %DropLevel_DoubleRef%
			gui, font, s%GUI_FontSize_Header2% w600 CBB7700 underline
			Gui, Add, Text, 	xs+360 	ys+65 	w25 	h25  center +BackgroundTrans vHeader7_Text gMakeToolTipWork_1, ?
			Header7_Text_TT := "Only change this if you want to use`nAnimate Weapon!`n`nIf you use Animate Weapon change this`nvalue to 0.`n`nAs long as the value for DropLevel is 80 or`nhigher this section won't do anything!`n`nIf you want to only animate lvl 40+ items`nthen change the value to 40, etc."
			Gui, font,
		
		Gui, Add, Picture, 	x380 	y%GroupPosition%	w412 	h100 +BackgroundTrans vPic_Box_overlay_%GroupName%, %A_WorkingDir%\Design\BOX_overlay.png
		if CheckBox_DoubleRef = 0
			if CheckBox2_DoubleRef = 0
				GuiControl, Hide, Pic_Box_overlay_%GroupName%
		
		Return
	}
	Gui, Add, Text, 		xs+223 	ys+75 	w65 	h15 		Right +BackgroundTrans, Alert Sound:
	Gui, Add, DropDownList, xs+292 	ys+70 	w60 	h126 	gDDL_Action_Alert_Sound_%GroupName% vDDL_Selected_Alert_Sound_%GroupName% Choose%AlertSound_DoubleRef%, 1|2|3|4|5|6|7|8|9
	Gui, Add, Button, 		xs+362 	ys+70 	w35 	h20 		gPlay_Alert_Sound_%GroupName% vAlert_Sound_Button_%GroupName%, Play
	Alert_Sound_Button_%GroupName%_TT := "This is a Sound Preview.`n`nIt will play the currently`nselected Alert Sound."
	
	Gui, Add, Picture, 	x380 	y%GroupPosition%	w412 	h100 +BackgroundTrans vPic_Box_overlay_%GroupName%, %A_WorkingDir%\Design\BOX_overlay.png
	if CheckBox_DoubleRef = 0
		if CheckBox2_DoubleRef = 0
			GuiControl, Hide, Pic_Box_overlay_%GroupName%
	
	Return
}


;══════════════════════════════════════( Tab within a Tab - also includes highlighting for Maintabs  )════════════════════════════════════════
GoTab1:
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, % ThisTab -1, 0, , ahk_id %HwndTabMain%
	
	GuiControlGet, ThisTab,, Tab_1
	
	if ThisTab = Main
		ThisTab = 1
	if ThisTab = RNG
		ThisTab = 2
	if ThisTab = Currency
		ThisTab = 3
	if ThisTab = Maps
		ThisTab = 4
	if ThisTab = Gems
		ThisTab = 5
	if ThisTab = Rares
		ThisTab = 6
	if ThisTab = Flasks
		ThisTab = 7
	if ThisTab = General
		ThisTab = 8
	if ThisTab = fix_later
		ThisTab = 9
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, % ThisTab -1, 1, , ahk_id %HwndTabMain%
	
	Gui, Submit, NoHide
	if Tab_1 = Currency
		GuiControl, Show, SubTab_3
	else
		GuiControl, Hide, SubTab_3
	WinSet, Redraw, , A
	
	Gui, Submit, NoHide
	if Tab_1 = Maps
		GuiControl, Show, SubTab_4
	else
		GuiControl, Hide, SubTab_4
	WinSet, Redraw, , A
	
	Gui, Submit, NoHide
	if Tab_1 = Rares
		GuiControl, Show, SubTab_6
	else
		GuiControl, Hide, SubTab_6
	WinSet, Redraw, , A
	return

;══════════════════════════════════════( Highlighting for sub-Tabs  )════════════════════════════════════════
GoSubTab3:
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_3%, 0, , ahk_id %HwndTabCurrency%
	GuiControlGet, thistab_3,, SubTab_3
	
	if thistab_3 = Normal
		thistab_3 = 0
	if thistab_3 = Sockets && Links
		thistab_3 = 1
	if thistab_3 = placeholder_3
		thistab_3 = 2
	if thistab_3 = placeholder_3
		thistab_3 = 3
	if thistab_3 = placeholder_3
		thistab_3 = 4
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_3%, 1, , ahk_id %HwndTabCurrency%
	return

GoSubTab4:
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_4%, 0, , ahk_id %HwndTabMaps%
	GuiControlGet, thistab_4,, SubTab_4
	
	if thistab_4 = High Maps
		thistab_4 = 0
	if thistab_4 = Low Maps
		thistab_4 = 1
	if thistab_4 = Fragments
		thistab_4 = 2
	if thistab_4 = placeholder_4
		thistab_4 = 3
	if thistab_4 = placeholder_4
		thistab_4 = 4
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_4%, 1, , ahk_id %HwndTabMaps%
	return

GoSubTab6:
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_6%, 0, , ahk_id %HwndTabRares%
	GuiControlGet, thistab_6,, SubTab_6
	
	if thistab_6 = Jewellry
		thistab_6 = 0
	if thistab_6 = Rest of Rares
		thistab_6 = 1
	if thistab_6 = Uniques
		thistab_6 = 2
	if thistab_6 = placeholder_6
		thistab_6 = 3
	if thistab_6 = placeholder_6
		thistab_6 = 4
	SendMessage, TCM_HIGHLIGHTITEM := 0x1333, %thistab_6%, 1, , ahk_id %HwndTabRares%
	return

;══════════════════════════════════════( Updates the .filter  )════════════════════════════════════════
Update_Filter()
{
	global
	;MsgBox, 4, , Do you want to update the filter? ; Yes/No - MsgBox
	;IfMsgBox, Yes
	UrlDownloadToFile, http://pastebin.com/raw.php?i=DgCKpKae, %FilterFileName%.filter
	return
}

;══════════════════════════════════════( Tooltip thing )════════════════════════════════════════
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
	
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 600
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
    SetTimer, RemoveToolTip, 12000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

/*
WM_MOUSEMOVE(){
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl){
			SetTimer, DisplayToolTip, -300 	; shorter wait, shows the tooltip quicker
			PrevControl := CurrControl
	}
	return
	
	DisplayToolTip:
	;try
	;		ToolTip % %CurrControl%_TT
	; catch
	; 		ToolTip
	SetTimer, RemoveToolTip, -2000
	return
	
	RemoveToolTip:
	ToolTip
	return
}
*/


;══════════════════════════════════════( Use Standard Filter )════════════════════════════════════════
Use_Standard_Filter:
	Gui, Submit, NoHide
	
	Update_Filter()
	
	IfExist, C:\Users\%A_UserName%\Documents\My Games\Path of Exile\%FilterFileName%.filter
	{
		MsgBox, 4, , %FilterFileName%.filter already exists. `nDo you want to replace it? ; Yes/No - MsgBox
		IfMsgBox, No
			return
	}
	FileCopy, %FilterFileName%.filter, C:\Users\%A_UserName%\Documents\My Games\Path of Exile\%FilterFileName%.filter , 1
	MsgBox, The filter has been successfully updated!
	return
	

;══════════════════════════════════════( Use Customized Filter )════════════════════════════════════════
Button_Customized_Filter:
	Gui, Submit, NoHide
	
	SplashTextOn, 330, 25, Working..., Creating your Custom Filter. Please wait...
	
	Update_Filter()
	
	FileCopy, %Config_File%.txt, %Config_File%_old.txt , 1
	
	FileCopy, %FilterFileName%.filter, %FilterFileName%_old.filter , 1
	FileDelete, %FilterFileName%.filter
	
	skip_it_first_time = 1
	skip_it_first_time_2 = 1
	lets_finish_the_file = 0
	filter_file_completely_done = 0
	
	Use_Custom_Build = 1
	Selected_Build_OutoutVar =
	Use_Custom_Defence = 1
	Selected_Defence_OutoutVar =
	
	Loop
	{
		SourceFile = %Config_File%_old.txt
		if skip_it_first_time = 0
		{
			FileDelete, %Config_File%_old.txt
			FileCopy, %Config_File%_old.tmp.txt, %Config_File%_old.txt , 1
			FileDelete, %Config_File%_old.tmp.txt
		}
		skip_it_first_time = 0
		
		placeholder_check_part_1 = 0
		go_to_2nd_part = 0
		
		NextLine_TextColor = 0
		change_text_color = 0
		
		NextLine_BorderColor = 0
		change_border_color = 0
		
		NextLine_BackgroundColor = 0
		change_background_color = 0
		
		NextLine_FontSize = 0
		change_font_size = 0
		
		NextLine_AlertSound = 0
		change_alert_sound = 0
		
		NextLine_CheckBox_DH = 0
		disable_current_item = 0
		hide_current_item = 0
		
		item_is_unchanged = 0
		
		Loop
		{
			FileReadLine, line, %SourceFile%, %A_Index%
			if ErrorLevel
			{
				; MsgBox The end of the ConfigFile has been reached.		;	<--- works perfectly
				break
			}
			
			if go_to_2nd_part = 1
			{
				FileAppend, %line%`n, %Config_File%_old.tmp.txt
				continue
			}
			if line contains #end_of_file
			{
				lets_finish_the_file = 1
				Current_Item_Name = %line%
				Count = 1
				StringTrimLeft, Current_Item_Name, Current_Item_Name, %Count%
				
				; MsgBox, debug 8								; <----- This initiates the end of the loop
				break
			}
			if line !=
			{
				; MsgBox, This line is not empty!`n`nlast_line_blank = 0
				last_line_blank = 0
			}
			; MsgBox, line = %line%
			if line contains [			; this if-query is not really neccessary ---- mabye fixthis
			{
				; Current_Section_Name = %line%
				; Count = 1
				; StringTrimLeft, Current_Section_Name, Current_Section_Name, %Count%
				; StringTrimRight, Current_Section_Name, Current_Section_Name, %Count%
				; MsgBox, continue cause [
				continue
			}
			if line contains #
			{
				if line not contains #edited
				{
					item_is_unchanged = 1
					continue
				}
				if Use_Custom_Build = 1
				{
					if line contains insert_build_here
					{
						go_to_2nd_part = 1
					}
				}
				if Use_Custom_Defence = 1
				{
					if line contains insert_defence_here
					{
						go_to_2nd_part = 1
					}
				}
				item_is_unchanged = 0
				placeholder_check_part_1 = %A_Index%
				Current_Item_Name = %line%
				Count = 1
				StringTrimLeft, Current_Item_Name, Current_Item_Name, %Count%
				StringTrimRight, Current_Item_Name, Current_Item_Name, 7
				continue
			}
			if line =
			{
				placeholder_check_part_2 = %A_Index%
				placeholder_check_part_2 -= 1
				; MsgBox, Current_Item_Name cause line is blank: %Current_Item_Name%
				if placeholder_check_part_1 = %placeholder_check_part_2%
				{
					; MsgBox, The current Item name, was just a placeholder!`n`nplaceholder_check_part_1: %placeholder_check_part_1%`nplaceholder_check_part_2: %placeholder_check_part_2%
					continue
				}
				if item_is_unchanged = 1
				{
					continue
				}
				if last_line_blank = 1
				{
					filter_file_completely_done = 1
					
					MsgBox There have been 2 blank lines in a row!`nThe config file has (probably) been completely processed!
					Break
				}
				last_line_blank = 1
				
				go_to_2nd_part = 1
			}
			if disable_current_item = 1
			{
				continue
			}
			if item_is_unchanged = 0
			{
				if NextLine_CheckBox_DH = 1
				{
					NextLine_CheckBox_DH = 0
					if line = 0
						continue
					if line = 1
						disable_current_item = 1
					if line = 2
						hide_current_item = 1
					continue
				}
				if NextLine_TextColor = 1
				{
					NextLine_TextColor = 0
					change_text_color = 1
					new_text_color = %line%
					continue
				}
				if NextLine_BorderColor = 1
				{
					NextLine_BorderColor = 0
					change_border_color = 1
					new_border_color = %line%
					continue
				}
				if NextLine_BackgroundColor = 1
				{
					NextLine_BackgroundColor = 0
					change_background_color = 1
					new_background_color = %line%
					continue
				}
				if NextLine_FontSize = 1
				{
					NextLine_FontSize = 0
					change_font_size = 1
					new_font_size = %line%
					continue
				}
				if NextLine_AlertSound = 1
				{
					NextLine_AlertSound = 0
					if line = 0
						continue
					change_alert_sound = 1
					new_alert_sound = %line%
					continue
				}
				if line contains CheckBox_DH
				{
					NextLine_CheckBox_DH = 1
					continue
				}
				if line contains SetTextColor
				{
					NextLine_TextColor = 1
					continue
				}
				if line contains SetBorderColor
				{
					NextLine_BorderColor = 1
					continue
				}
				if line contains SetBackgroundColor
				{
					NextLine_BackgroundColor = 1
					continue
				}
				if line contains SetFontSize
				{
					NextLine_FontSize = 1
					continue
				}
				if line contains PlayAlertSound
				{
					NextLine_AlertSound = 1
					continue
				}
			}
		}
		
		
		if filter_file_completely_done = 1
		{
			; MsgBox, DONE! :O
			
			MsgBox, debug 4
			break
		}
		
		
		
		
		
		SourceFile = %FilterFileName%_old.filter
		if skip_it_first_time_2 = 0
		{
			FileDelete, %FilterFileName%_old.filter
			FileCopy, %FilterFileName%_old.tmp.filter, %FilterFileName%_old.filter , 1
			FileDelete, %FilterFileName%_old.tmp.filter
		}
		skip_it_first_time_2 = 0
		target_item_found = 0
		go_to_4th_part = 0

		Loop
		{
			FileReadLine, line, %Sourcefile%, %A_Index%
			
			if lets_finish_the_file = 1
			{
				if line contains end_of_file
				{
					filter_file_completely_done = 1
					; MsgBox, debug 1					; <---- This initiates the very end of this loop
					break
				}
			}
			; MsgBox, Current Item Name: %Current_Item_Name%`n`nLine: %line% 
			
			if ErrorLevel
			{
				; MsgBox %ErrorLevel%		;	<--- works perfectly
				break
			}
			
			if go_to_4th_part = 1
			{
				FileAppend, %line%`n, %FilterFileName%_old.tmp.filter
				continue
			}
			
			if line contains %Current_Item_Name%
			{
				target_item_found = 1
				check_for_next_block = 0
				if line not contains #edited
					FileAppend, %line%#edited`n, %FilterFileName%.filter
				if line contains #edited
					FileAppend, %line%*`n, %FilterFileName%.filter
				continue
			}
			if target_item_found = 1
			{
				if Use_Custom_Build = 1
				{
					Use_Custom_Build = 0
					; MsgBox, DDL1_Selected: _%DDL1_Selected%_
					FileRead, Selected_Build_OutputVar, %A_WorkingDir%\Builds\%DDL1_Selected%.txt
					FileAppend, %Selected_Build_OutputVar%`n, %FilterFileName%.filter
					continue
				}
				if Use_Custom_Defence = 1
				{
					Use_Custom_Defence = 0
					; MsgBox, DDL2_Selected: _%DDL2_Selected%_
					FileRead, Selected_Defence_OutputVar, %A_WorkingDir%\Defences\%DDL2_Selected%.txt
					FileAppend, %Selected_Defence_OutputVar%`n, %FilterFileName%.filter
					continue
				}
				if line =
				{
					; maybe_change_later = 1		; <--- fixthis (not too important)
					go_to_4th_part = 1
				}
				if line contains #
				{
					; maybe_change_later = 1		; <--- fixthis (not too important)
					go_to_4th_part = 1
				}
				if line = Show
				{
					if check_for_next_block = 1
					{
						go_to_4th_part = 1
					}
					check_for_next_block = 1
					
					if hide_current_item = 1
					{
						hide_current_item = 0
						FileAppend, Hide`n, %FilterFileName%.filter
						continue
					}
				}
				if line = Hide
				{
					if check_for_next_block = 1
					{
						go_to_4th_part = 1
					}
					check_for_next_block = 1
					
					if hide_current_item = 1
					{
						hide_current_item = 0
						FileAppend, Show`n, %FilterFileName%.filter
						continue
					}
				}
				if disable_current_item = 1
				{
					continue
				}
				if change_text_color = 1
				{
					if line contains SetTextColor
					{
						change_text_color = 0
						FileAppend, %A_Tab%SetTextColor %new_text_color%`n, %FilterFileName%.filter
						continue
					}
				}
				if change_border_color = 1
				{
					if line contains SetBorderColor
					{
						change_border_color = 0
						FileAppend, %A_Tab%SetBorderColor %new_border_color%`n, %FilterFileName%.filter
						continue
					}
				}
				if change_background_color = 1
				{
					if line contains SetBackgroundColor
					{
						change_background_color = 0
						FileAppend, %A_Tab%SetBackgroundColor %new_background_color%`n, %FilterFileName%.filter
						continue
					}
				}
				if change_font_size = 1
				{
					if line contains SetFontSize
					{
						change_font_size = 0
						FileAppend, %A_Tab%SetFontSize %new_font_size%`n, %FilterFileName%.filter
						continue
					}
				}
				if change_alert_sound = 1
				{
					if line contains PlayAlertSound
					{
						change_alert_sound = 0
						FileAppend, %A_Tab%PlayAlertSound %new_alert_sound% 100`n, %FilterFileName%.filter
						continue
					}
				}
				
				if line contains end_of_file
				{
					filter_file_completely_done = 1
					MsgBox, debug 2
					break
				}
				; FileAppend, DEBUGGER_22222__22222`n, %FilterFileName%.filter
				FileAppend, %line%`n, %FilterFileName%.filter
				continue
			}
			
			if line contains end_of_file
			{
				filter_file_completely_done = 1
				MsgBox, debug 3
				break
			}
			if line not contains %Current_Item_Name%
			{
				; FileAppend, DEBUGGER_11111_11111`n, %FilterFileName%.filter
				FileAppend, %line%`n, %FilterFileName%.filter
				continue
			}
		}
		
		if filter_file_completely_done = 1
		{
			; MsgBox, DONE! :O
			SplashTextOff
			break
		}
	
	}
	
	FileDelete, %Config_File%_old.txt
	FileDelete, %Config_File%_old.tmp.txt
	FileDelete, %FilterFileName%_old.filter
	FileDelete, %FilterFileName%_old.tmp.filter
	
	;									Maybe fixthis MsgBox, seems to only appear on the first time (?)	---	Probably fine now, but didn't change anything lol
	IfExist, C:\Users\%A_UserName%\Documents\My Games\Path of Exile\%FilterFileName%.filter
	{
		MsgBox, 4, , %FilterFileName%.filter already exists. `nDo you want to replace it? ; Yes/No - MsgBox
		IfMsgBox, No
			return
	}
	FileCopy, %FilterFileName%.filter, C:\Users\%A_UserName%\Documents\My Games\Path of Exile\%FilterFileName%.filter , 1
	MsgBox, The filter has been successfully updated!
	return


;══════════════════════════════════════( DropDownLists )═══════════════════════════════════════════════════════════════════
DDL1_Action:
	Gui, Submit, NoHide
	current_affiliation_group = insert_build_here
	current_affiliation_type = SelectedBuild
	New_Value_for_Config = %DDL1_Selected%
	Gosub Edit_Config_File
	return

DDL2_Action:
	Gui, Submit, NoHide
	current_affiliation_group = insert_defence_here
	current_affiliation_type = SelectedDefence
	New_Value_for_Config = %DDL2_Selected%
	Gosub Edit_Config_File
	return

CheckBox1_Action:
	Gui, Submit, NoHide
	If CheckBox1 = 1
		MsgBox, On
	If CheckBox1 = 0
		MsgBox, Off
	return

CheckBoxAction_animate_weapon:
	Gui, Submit, NoHide
	current_affiliation_group = insert_animate_weapon_here
	current_affiliation_type = CheckBoxValue
	New_Value_for_Config = %CheckBoxValue_animate_weapon%
	Gosub Edit_Config_File
	return


Text1:
	return
Text2:
	return
Text3:
	return
MakeToolTipWork_1:
	return
MakeToolTipWork_2:
	return
MakeToolTipWork_3:
	return
MakeToolTipWork_4:
	return
MakeToolTipWork_5:
	return
MakeToolTipWork_6:
	return
MakeToolTipWork_7:
	return
MakeToolTipWork_8:
	return
MakeToolTipWork_9:
	return
;══════════════════════════════════════( Handle GroupBox User Input )═══════════════════════════════════════════════════════════════════
;══════════════════════════════════════( WALL OF TEXT )═══════════════════════════════════════════════════════════════════
;══════════════════════════════════════( WALL OF TEXT )═══════════════════════════════════════════════════════════════════
RunColorPicker_fishing_rod_Text:
	button_affiliation_group = fishing_rod
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_fishing_rod_Border:
	button_affiliation_group = fishing_rod
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_fishing_rod_Background:
	button_affiliation_group = fishing_rod
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_fishing_rod:
	Gui, Submit, NoHide
	current_affiliation_group = fishing_rod
	current_affiliation_type = CheckBox_DH
	; MsgBox, %A_GuiControl%
	if A_GuiControl = CheckBox_Selected_fishing_rod
	{
		New_Value_for_Config = %CheckBox_Selected_fishing_rod%
		GuiControl,,CheckBox2_Selected_fishing_rod,0
	}
	if A_GuiControl = CheckBox2_Selected_fishing_rod
	{
		New_Value_for_Config = %CheckBox2_Selected_fishing_rod%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_fishing_rod,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
CheckBox2_Action_fishing_rod:
	Gui, Submit, NoHide
	current_affiliation_group = fishing_rod
	current_affiliation_type = CheckBox_DH
	New_Value_for_Config = %CheckBox2_Selected_fishing_rod%
	if New_Value_for_Config = 1
		New_Value_for_Config = 2
	GuiControl,,CheckBox_Selected_fishing_rod,0
	Gosub Edit_Config_File
	return
DDL_Action_Font_Size_fishing_rod:
	Gui, Submit, NoHide
	current_affiliation_group = fishing_rod
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_fishing_rod%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_fishing_rod:
	Gui, Submit, NoHide
	current_affiliation_group = fishing_rod
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_fishing_rod%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_fishing_rod:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_fishing_rod%.wav
	return

RunColorPicker_albino_rhoa_feather_Text:
	button_affiliation_group = albino_rhoa_feather
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_albino_rhoa_feather_Border:
	button_affiliation_group = albino_rhoa_feather
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_albino_rhoa_feather_Background:
	button_affiliation_group = albino_rhoa_feather
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_albino_rhoa_feather:
	Gui, Submit, NoHide
	current_affiliation_group = albino_rhoa_feather
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_albino_rhoa_feather
	{
		New_Value_for_Config = %CheckBox_Selected_albino_rhoa_feather%
		GuiControl,,CheckBox2_Selected_albino_rhoa_feather,0
	}
	if A_GuiControl = CheckBox2_Selected_albino_rhoa_feather
	{
		New_Value_for_Config = %CheckBox2_Selected_albino_rhoa_feather%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_albino_rhoa_feather,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_albino_rhoa_feather:
	Gui, Submit, NoHide
	current_affiliation_group = albino_rhoa_feather
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_albino_rhoa_feather%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_albino_rhoa_feather:
	Gui, Submit, NoHide
	current_affiliation_group = albino_rhoa_feather
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_albino_rhoa_feather%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_albino_rhoa_feather:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_albino_rhoa_feather%.wav
	return

RunColorPicker_mirror_of_kalandra_Text:
	button_affiliation_group = mirror_of_kalandra
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_mirror_of_kalandra_Border:
	button_affiliation_group = mirror_of_kalandra
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_mirror_of_kalandra_Background:
	button_affiliation_group = mirror_of_kalandra
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_mirror_of_kalandra:
	Gui, Submit, NoHide
	current_affiliation_group = mirror_of_kalandra
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_mirror_of_kalandra
	{
		New_Value_for_Config = %CheckBox_Selected_mirror_of_kalandra%
		GuiControl,,CheckBox2_Selected_mirror_of_kalandra,0
	}
	if A_GuiControl = CheckBox2_Selected_mirror_of_kalandra
	{
		New_Value_for_Config = %CheckBox2_Selected_mirror_of_kalandra%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_mirror_of_kalandra,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_mirror_of_kalandra:
	Gui, Submit, NoHide
	current_affiliation_group = mirror_of_kalandra
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_mirror_of_kalandra%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_mirror_of_kalandra:
	Gui, Submit, NoHide
	current_affiliation_group = mirror_of_kalandra
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_mirror_of_kalandra%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_mirror_of_kalandra:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_mirror_of_kalandra%.wav
	return

RunColorPicker_6_linked_items_Text:
	button_affiliation_group = 6_linked_items
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_6_linked_items_Border:
	button_affiliation_group = 6_linked_items
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_6_linked_items_Background:
	button_affiliation_group = 6_linked_items
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_6_linked_items:
	Gui, Submit, NoHide
	current_affiliation_group = 6_linked_items
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_6_linked_items
	{
		New_Value_for_Config = %CheckBox_Selected_6_linked_items%
		GuiControl,,CheckBox2_Selected_6_linked_items,0
	}
	if A_GuiControl = CheckBox2_Selected_6_linked_items
	{
		New_Value_for_Config = %CheckBox2_Selected_6_linked_items%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_6_linked_items,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_6_linked_items:
	Gui, Submit, NoHide
	current_affiliation_group = 6_linked_items
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_6_linked_items%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_6_linked_items:
	Gui, Submit, NoHide
	current_affiliation_group = 6_linked_items
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_6_linked_items%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_6_linked_items:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_6_linked_items%.wav
	return

RunColorPicker_exalted_orb_Text:
	button_affiliation_group = exalted_orb
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_exalted_orb_Border:
	button_affiliation_group = exalted_orb
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_exalted_orb_Background:
	button_affiliation_group = exalted_orb
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_exalted_orb:
	Gui, Submit, NoHide
	current_affiliation_group = exalted_orb
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_exalted_orb
	{
		New_Value_for_Config = %CheckBox_Selected_exalted_orb%
		GuiControl,,CheckBox2_Selected_exalted_orb,0
	}
	if A_GuiControl = CheckBox2_Selected_exalted_orb
	{
		New_Value_for_Config = %CheckBox2_Selected_exalted_orb%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_exalted_orb,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_exalted_orb:
	Gui, Submit, NoHide
	current_affiliation_group = exalted_orb
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_exalted_orb%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_exalted_orb:
	Gui, Submit, NoHide
	current_affiliation_group = exalted_orb
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_exalted_orb%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_exalted_orb:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_exalted_orb%.wav
	return

RunColorPicker_high_value_currency_Text:
	button_affiliation_group = high_value_currency
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_high_value_currency_Border:
	button_affiliation_group = high_value_currency
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_high_value_currency_Background:
	button_affiliation_group = high_value_currency
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_high_value_currency:
	Gui, Submit, NoHide
	current_affiliation_group = high_value_currency
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_high_value_currency
	{
		New_Value_for_Config = %CheckBox_Selected_high_value_currency%
		GuiControl,,CheckBox2_Selected_high_value_currency,0
	}
	if A_GuiControl = CheckBox2_Selected_high_value_currency
	{
		New_Value_for_Config = %CheckBox2_Selected_high_value_currency%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_high_value_currency,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_high_value_currency:
	Gui, Submit, NoHide
	current_affiliation_group = high_value_currency
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_high_value_currency%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_high_value_currency:
	Gui, Submit, NoHide
	current_affiliation_group = high_value_currency
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_high_value_currency%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_high_value_currency:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_high_value_currency%.wav
	return

RunColorPicker_remaining_worthwhile_currency_Text:
	button_affiliation_group = remaining_worthwhile_currency
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_remaining_worthwhile_currency_Border:
	button_affiliation_group = remaining_worthwhile_currency
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_remaining_worthwhile_currency_Background:
	button_affiliation_group = remaining_worthwhile_currency
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_remaining_worthwhile_currency:
	Gui, Submit, NoHide
	current_affiliation_group = remaining_worthwhile_currency
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_remaining_worthwhile_currency
	{
		New_Value_for_Config = %CheckBox_Selected_remaining_worthwhile_currency%
		GuiControl,,CheckBox2_Selected_remaining_worthwhile_currency,0
	}
	if A_GuiControl = CheckBox2_Selected_remaining_worthwhile_currency
	{
		New_Value_for_Config = %CheckBox2_Selected_remaining_worthwhile_currency%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_remaining_worthwhile_currency,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_remaining_worthwhile_currency:
	Gui, Submit, NoHide
	current_affiliation_group = remaining_worthwhile_currency
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_remaining_worthwhile_currency%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_remaining_worthwhile_currency:
	Gui, Submit, NoHide
	current_affiliation_group = remaining_worthwhile_currency
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_remaining_worthwhile_currency%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_remaining_worthwhile_currency:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_remaining_worthwhile_currency%.wav
	return

RunColorPicker_rest_of_currency_Text:
	button_affiliation_group = rest_of_currency
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_currency_Border:
	button_affiliation_group = rest_of_currency
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_currency_Background:
	button_affiliation_group = rest_of_currency
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_rest_of_currency:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_currency
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_rest_of_currency
	{
		New_Value_for_Config = %CheckBox_Selected_rest_of_currency%
		GuiControl,,CheckBox2_Selected_rest_of_currency,0
	}
	if A_GuiControl = CheckBox2_Selected_rest_of_currency
	{
		New_Value_for_Config = %CheckBox2_Selected_rest_of_currency%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_rest_of_currency,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_rest_of_currency:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_currency
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_rest_of_currency%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_rest_of_currency:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_currency
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_rest_of_currency%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_rest_of_currency:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_rest_of_currency%.wav
	return

RunColorPicker_5_links_Text:
	button_affiliation_group = 5_links
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_5_links_Border:
	button_affiliation_group = 5_links
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_5_links_Background:
	button_affiliation_group = 5_links
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_5_links:
	Gui, Submit, NoHide
	current_affiliation_group = 5_links
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_5_links
	{
		New_Value_for_Config = %CheckBox_Selected_5_links%
		GuiControl,,CheckBox2_Selected_5_links,0
	}
	if A_GuiControl = CheckBox2_Selected_5_links
	{
		New_Value_for_Config = %CheckBox2_Selected_5_links%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_5_links,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_5_links:
	Gui, Submit, NoHide
	current_affiliation_group = 5_links
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_5_links%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_5_links:
	Gui, Submit, NoHide
	current_affiliation_group = 5_links
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_5_links%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_5_links:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_5_links%.wav
	return

RunColorPicker_6_sockets_Text:
	button_affiliation_group = 6_sockets
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_6_sockets_Border:
	button_affiliation_group = 6_sockets
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_6_sockets_Background:
	button_affiliation_group = 6_sockets
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_6_sockets:
	Gui, Submit, NoHide
	current_affiliation_group = 6_sockets
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_6_sockets
	{
		New_Value_for_Config = %CheckBox_Selected_6_sockets%
		GuiControl,,CheckBox2_Selected_6_sockets,0
	}
	if A_GuiControl = CheckBox2_Selected_6_sockets
	{
		New_Value_for_Config = %CheckBox2_Selected_6_sockets%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_6_sockets,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_6_sockets:
	Gui, Submit, NoHide
	current_affiliation_group = 6_sockets
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_6_sockets%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_6_sockets:
	Gui, Submit, NoHide
	current_affiliation_group = 6_sockets
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_6_sockets%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_6_sockets:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_6_sockets%.wav
	return

RunColorPicker_chromatic_items_Text:
	button_affiliation_group = chromatic_items
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_chromatic_items_Border:
	button_affiliation_group = chromatic_items
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_chromatic_items_Background:
	button_affiliation_group = chromatic_items
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_chromatic_items:
	Gui, Submit, NoHide
	current_affiliation_group = chromatic_items
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_chromatic_items
	{
		New_Value_for_Config = %CheckBox_Selected_chromatic_items%
		GuiControl,,CheckBox2_Selected_chromatic_items,0
	}
	if A_GuiControl = CheckBox2_Selected_chromatic_items
	{
		New_Value_for_Config = %CheckBox2_Selected_chromatic_items%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_chromatic_items,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_chromatic_items:
	Gui, Submit, NoHide
	current_affiliation_group = chromatic_items
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_chromatic_items%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_chromatic_items:
	Gui, Submit, NoHide
	current_affiliation_group = chromatic_items
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_chromatic_items%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_chromatic_items:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_chromatic_items%.wav
	return

RunColorPicker_lvl_80_maps_Text:
	button_affiliation_group = lvl_80_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_80_maps_Border:
	button_affiliation_group = lvl_80_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_80_maps_Background:
	button_affiliation_group = lvl_80_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_80_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_80_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_80_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_80_maps%
		GuiControl,,CheckBox2_Selected_lvl_80_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_80_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_80_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_80_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_80_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_80_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_80_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_80_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_80_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_80_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_80_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_80_maps%.wav
	return

RunColorPicker_lvl_78_maps_Text:
	button_affiliation_group = lvl_78_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_78_maps_Border:
	button_affiliation_group = lvl_78_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_78_maps_Background:
	button_affiliation_group = lvl_78_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_78_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_78_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_78_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_78_maps%
		GuiControl,,CheckBox2_Selected_lvl_78_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_78_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_78_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_78_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_78_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_78_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_78_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_78_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_78_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_78_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_78_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_78_maps%.wav
	return

RunColorPicker_lvl_76_maps_Text:
	button_affiliation_group = lvl_76_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_76_maps_Border:
	button_affiliation_group = lvl_76_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_76_maps_Background:
	button_affiliation_group = lvl_76_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_76_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_76_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_76_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_76_maps%
		GuiControl,,CheckBox2_Selected_lvl_76_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_76_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_76_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_76_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_76_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_76_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_76_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_76_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_76_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_76_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_76_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_76_maps%.wav
	return

RunColorPicker_lvl_74_maps_Text:
	button_affiliation_group = lvl_74_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_74_maps_Border:
	button_affiliation_group = lvl_74_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_74_maps_Background:
	button_affiliation_group = lvl_74_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_74_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_74_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_74_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_74_maps%
		GuiControl,,CheckBox2_Selected_lvl_74_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_74_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_74_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_74_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_74_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_74_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_74_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_74_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_74_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_74_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_74_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_74_maps%.wav
	return

RunColorPicker_lvl_72_maps_Text:
	button_affiliation_group = lvl_72_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_72_maps_Border:
	button_affiliation_group = lvl_72_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_72_maps_Background:
	button_affiliation_group = lvl_72_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_72_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_72_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_72_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_72_maps%
		GuiControl,,CheckBox2_Selected_lvl_72_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_72_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_72_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_72_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_72_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_72_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_72_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_72_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_72_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_72_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_72_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_72_maps%.wav
	return

RunColorPicker_lvl_70_maps_Text:
	button_affiliation_group = lvl_70_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_lvl_70_maps_Border:
	button_affiliation_group = lvl_70_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_lvl_70_maps_Background:
	button_affiliation_group = lvl_70_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_lvl_70_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_70_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_lvl_70_maps
	{
		New_Value_for_Config = %CheckBox_Selected_lvl_70_maps%
		GuiControl,,CheckBox2_Selected_lvl_70_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_lvl_70_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_lvl_70_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_lvl_70_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_lvl_70_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_70_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_lvl_70_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_lvl_70_maps:
	Gui, Submit, NoHide
	current_affiliation_group = lvl_70_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_lvl_70_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_lvl_70_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_lvl_70_maps%.wav
	return

RunColorPicker_rest_of_maps_Text:
	button_affiliation_group = rest_of_maps
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_maps_Border:
	button_affiliation_group = rest_of_maps
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_maps_Background:
	button_affiliation_group = rest_of_maps
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_rest_of_maps:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_maps
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_rest_of_maps
	{
		New_Value_for_Config = %CheckBox_Selected_rest_of_maps%
		GuiControl,,CheckBox2_Selected_rest_of_maps,0
	}
	if A_GuiControl = CheckBox2_Selected_rest_of_maps
	{
		New_Value_for_Config = %CheckBox2_Selected_rest_of_maps%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_rest_of_maps,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_rest_of_maps:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_maps
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_rest_of_maps%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_rest_of_maps:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_maps
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_rest_of_maps%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_rest_of_maps:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_rest_of_maps%.wav
	return

RunColorPicker_midnight_and_hope_Text:
	button_affiliation_group = midnight_and_hope
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_midnight_and_hope_Border:
	button_affiliation_group = midnight_and_hope
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_midnight_and_hope_Background:
	button_affiliation_group = midnight_and_hope
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_midnight_and_hope:
	Gui, Submit, NoHide
	current_affiliation_group = midnight_and_hope
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_midnight_and_hope
	{
		New_Value_for_Config = %CheckBox_Selected_midnight_and_hope%
		GuiControl,,CheckBox2_Selected_midnight_and_hope,0
	}
	if A_GuiControl = CheckBox2_Selected_midnight_and_hope
	{
		New_Value_for_Config = %CheckBox2_Selected_midnight_and_hope%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_midnight_and_hope,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_midnight_and_hope:
	Gui, Submit, NoHide
	current_affiliation_group = midnight_and_hope
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_midnight_and_hope%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_midnight_and_hope:
	Gui, Submit, NoHide
	current_affiliation_group = midnight_and_hope
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_midnight_and_hope%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_midnight_and_hope:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_midnight_and_hope%.wav
	return

RunColorPicker_rest_of_fragments_Text:
	button_affiliation_group = rest_of_fragments
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_fragments_Border:
	button_affiliation_group = rest_of_fragments
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_fragments_Background:
	button_affiliation_group = rest_of_fragments
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_rest_of_fragments:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_fragments
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_rest_of_fragments
	{
		New_Value_for_Config = %CheckBox_Selected_rest_of_fragments%
		GuiControl,,CheckBox2_Selected_rest_of_fragments,0
	}
	if A_GuiControl = CheckBox2_Selected_rest_of_fragments
	{
		New_Value_for_Config = %CheckBox2_Selected_rest_of_fragments%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_rest_of_fragments,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_rest_of_fragments:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_fragments
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_rest_of_fragments%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_rest_of_fragments:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_fragments
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_rest_of_fragments%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_rest_of_fragments:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_rest_of_fragments%.wav
	return

RunColorPicker_valuable_gems_Text:
	button_affiliation_group = valuable_gems
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_valuable_gems_Border:
	button_affiliation_group = valuable_gems
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_valuable_gems_Background:
	button_affiliation_group = valuable_gems
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_valuable_gems:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_gems
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_valuable_gems
	{
		New_Value_for_Config = %CheckBox_Selected_valuable_gems%
		GuiControl,,CheckBox2_Selected_valuable_gems,0
	}
	if A_GuiControl = CheckBox2_Selected_valuable_gems
	{
		New_Value_for_Config = %CheckBox2_Selected_valuable_gems%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_valuable_gems,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_valuable_gems:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_gems
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_valuable_gems%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_valuable_gems:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_gems
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_valuable_gems%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_valuable_gems:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_valuable_gems%.wav
	return

RunColorPicker_vaal_gems_Text:
	button_affiliation_group = vaal_gems
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_vaal_gems_Border:
	button_affiliation_group = vaal_gems
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_vaal_gems_Background:
	button_affiliation_group = vaal_gems
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_vaal_gems:
	Gui, Submit, NoHide
	current_affiliation_group = vaal_gems
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_vaal_gems
	{
		New_Value_for_Config = %CheckBox_Selected_vaal_gems%
		GuiControl,,CheckBox2_Selected_vaal_gems,0
	}
	if A_GuiControl = CheckBox2_Selected_vaal_gems
	{
		New_Value_for_Config = %CheckBox2_Selected_vaal_gems%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_vaal_gems,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_vaal_gems:
	Gui, Submit, NoHide
	current_affiliation_group = vaal_gems
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_vaal_gems%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_vaal_gems:
	Gui, Submit, NoHide
	current_affiliation_group = vaal_gems
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_vaal_gems%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_vaal_gems:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_vaal_gems%.wav
	return

RunColorPicker_quality_14_gems_Text:
	button_affiliation_group = quality_14_gems
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_quality_14_gems_Border:
	button_affiliation_group = quality_14_gems
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_quality_14_gems_Background:
	button_affiliation_group = quality_14_gems
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_quality_14_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_14_gems
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_quality_14_gems
	{
		New_Value_for_Config = %CheckBox_Selected_quality_14_gems%
		GuiControl,,CheckBox2_Selected_quality_14_gems,0
	}
	if A_GuiControl = CheckBox2_Selected_quality_14_gems
	{
		New_Value_for_Config = %CheckBox2_Selected_quality_14_gems%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_quality_14_gems,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_quality_14_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_14_gems
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_quality_14_gems%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_quality_14_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_14_gems
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_quality_14_gems%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_quality_14_gems:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_quality_14_gems%.wav
	return

RunColorPicker_quality_gems_Text:
	button_affiliation_group = quality_gems
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_quality_gems_Border:
	button_affiliation_group = quality_gems
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_quality_gems_Background:
	button_affiliation_group = quality_gems
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_quality_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_gems
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_quality_gems
	{
		New_Value_for_Config = %CheckBox_Selected_quality_gems%
		GuiControl,,CheckBox2_Selected_quality_gems,0
	}
	if A_GuiControl = CheckBox2_Selected_quality_gems
	{
		New_Value_for_Config = %CheckBox2_Selected_quality_gems%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_quality_gems,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_quality_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_gems
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_quality_gems%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_quality_gems:
	Gui, Submit, NoHide
	current_affiliation_group = quality_gems
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_quality_gems%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_quality_gems:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_quality_gems%.wav
	return

RunColorPicker_jewels_all_Text:
	button_affiliation_group = jewels_all
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_jewels_all_Border:
	button_affiliation_group = jewels_all
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_jewels_all_Background:
	button_affiliation_group = jewels_all
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_jewels_all:
	Gui, Submit, NoHide
	current_affiliation_group = jewels_all
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_jewels_all
	{
		New_Value_for_Config = %CheckBox_Selected_jewels_all%
		GuiControl,,CheckBox2_Selected_jewels_all,0
	}
	if A_GuiControl = CheckBox2_Selected_jewels_all
	{
		New_Value_for_Config = %CheckBox2_Selected_jewels_all%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_jewels_all,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_jewels_all:
	Gui, Submit, NoHide
	current_affiliation_group = jewels_all
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_jewels_all%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_jewels_all:
	Gui, Submit, NoHide
	current_affiliation_group = jewels_all
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_jewels_all%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_jewels_all:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_jewels_all%.wav
	return

RunColorPicker_ilvl_75_jewellry_Text:
	button_affiliation_group = ilvl_75_jewellry
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_75_jewellry_Border:
	button_affiliation_group = ilvl_75_jewellry
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_75_jewellry_Background:
	button_affiliation_group = ilvl_75_jewellry
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_ilvl_75_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_jewellry
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_ilvl_75_jewellry
	{
		New_Value_for_Config = %CheckBox_Selected_ilvl_75_jewellry%
		GuiControl,,CheckBox2_Selected_ilvl_75_jewellry,0
	}
	if A_GuiControl = CheckBox2_Selected_ilvl_75_jewellry
	{
		New_Value_for_Config = %CheckBox2_Selected_ilvl_75_jewellry%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_ilvl_75_jewellry,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_ilvl_75_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_jewellry
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_ilvl_75_jewellry%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_ilvl_75_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_jewellry
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_ilvl_75_jewellry%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_ilvl_75_jewellry:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_ilvl_75_jewellry%.wav
	return

RunColorPicker_ilvl_60_jewellry_Text:
	button_affiliation_group = ilvl_60_jewellry
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_60_jewellry_Border:
	button_affiliation_group = ilvl_60_jewellry
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_60_jewellry_Background:
	button_affiliation_group = ilvl_60_jewellry
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_ilvl_60_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_jewellry
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_ilvl_60_jewellry
	{
		New_Value_for_Config = %CheckBox_Selected_ilvl_60_jewellry%
		GuiControl,,CheckBox2_Selected_ilvl_60_jewellry,0
	}
	if A_GuiControl = CheckBox2_Selected_ilvl_60_jewellry
	{
		New_Value_for_Config = %CheckBox2_Selected_ilvl_60_jewellry%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_ilvl_60_jewellry,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_ilvl_60_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_jewellry
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_ilvl_60_jewellry%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_ilvl_60_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_jewellry
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_ilvl_60_jewellry%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_ilvl_60_jewellry:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_ilvl_60_jewellry%.wav
	return

RunColorPicker_rest_of_jewellry_Text:
	button_affiliation_group = rest_of_jewellry
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_jewellry_Border:
	button_affiliation_group = rest_of_jewellry
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_jewellry_Background:
	button_affiliation_group = rest_of_jewellry
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_rest_of_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_jewellry
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_rest_of_jewellry
	{
		New_Value_for_Config = %CheckBox_Selected_rest_of_jewellry%
		GuiControl,,CheckBox2_Selected_rest_of_jewellry,0
	}
	if A_GuiControl = CheckBox2_Selected_rest_of_jewellry
	{
		New_Value_for_Config = %CheckBox2_Selected_rest_of_jewellry%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_rest_of_jewellry,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_rest_of_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_jewellry
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_rest_of_jewellry%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_rest_of_jewellry:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_jewellry
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_rest_of_jewellry%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_rest_of_jewellry:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_rest_of_jewellry%.wav
	return

RunColorPicker_ilvl_75_rest_of_rares_Text:
	button_affiliation_group = ilvl_75_rest_of_rares
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_75_rest_of_rares_Border:
	button_affiliation_group = ilvl_75_rest_of_rares
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_75_rest_of_rares_Background:
	button_affiliation_group = ilvl_75_rest_of_rares
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_ilvl_75_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_rest_of_rares
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_ilvl75_rest_of_rares
	{
		New_Value_for_Config = %CheckBox_Selected_ilvl75_rest_of_rares%
		GuiControl,,CheckBox2_Selected_ilvl75_rest_of_rares,0
	}
	if A_GuiControl = CheckBox2_Selected_ilvl75_rest_of_rares
	{
		New_Value_for_Config = %CheckBox2_Selected_ilvl_75_rest_of_rares%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_ilvl_75_rest_of_rares,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_ilvl_75_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_rest_of_rares
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_ilvl_75_rest_of_rares%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_ilvl_75_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_75_rest_of_rares
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_ilvl_75_rest_of_rares%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_ilvl_75_rest_of_rares:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_ilvl_75_rest_of_rares%.wav
	return

RunColorPicker_ilvl_60_rest_of_rares_Text:
	button_affiliation_group = ilvl_60_rest_of_rares
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_60_rest_of_rares_Border:
	button_affiliation_group = ilvl_60_rest_of_rares
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_ilvl_60_rest_of_rares_Background:
	button_affiliation_group = ilvl_60_rest_of_rares
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_ilvl_60_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_rest_of_rares
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_ilvl60_rest_of_rares
	{
		New_Value_for_Config = %CheckBox_Selected_ilvl60_rest_of_rares%
		GuiControl,,CheckBox2_Selected_ilvl60_rest_of_rares,0
	}
	if A_GuiControl = CheckBox2_Selected_ilvl60_rest_of_rares
	{
		New_Value_for_Config = %CheckBox2_Selected_ilvl_60_rest_of_rares%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_ilvl_60_rest_of_rares,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_ilvl_60_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_rest_of_rares
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_ilvl_60_rest_of_rares%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_ilvl_60_rest_of_rares:
	Gui, Submit, NoHide
	current_affiliation_group = ilvl_60_rest_of_rares
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_ilvl_60_rest_of_rares%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_ilvl_60_rest_of_rares:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_ilvl_60_rest_of_rares%.wav
	return

RunColorPicker_valuable_uniqs_Text:
	button_affiliation_group = valuable_uniqs
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_valuable_uniqs_Border:
	button_affiliation_group = valuable_uniqs
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_valuable_uniqs_Background:
	button_affiliation_group = valuable_uniqs
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_valuable_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_uniqs
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_valuable_uniqs
	{
		New_Value_for_Config = %CheckBox_Selected_valuable_uniqs%
		GuiControl,,CheckBox2_Selected_valuable_uniqs,0
	}
	if A_GuiControl = CheckBox2_Selected_valuable_uniqs
	{
		New_Value_for_Config = %CheckBox2_Selected_valuable_uniqs%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_valuable_uniqs,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_valuable_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_uniqs
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_valuable_uniqs%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_valuable_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = valuable_uniqs
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_valuable_uniqs%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_valuable_uniqs:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_valuable_uniqs%.wav
	return

RunColorPicker_rest_of_uniqs_Text:
	button_affiliation_group = rest_of_uniqs
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_uniqs_Border:
	button_affiliation_group = rest_of_uniqs
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_rest_of_uniqs_Background:
	button_affiliation_group = rest_of_uniqs
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_rest_of_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_uniqs
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_rest_of_uniqs
	{
		New_Value_for_Config = %CheckBox_Selected_rest_of_uniqs%
		GuiControl,,CheckBox2_Selected_rest_of_uniqs,0
	}
	if A_GuiControl = CheckBox2_Selected_rest_of_uniqs
	{
		New_Value_for_Config = %CheckBox2_Selected_rest_of_uniqs%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_rest_of_uniqs,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_rest_of_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_uniqs
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_rest_of_uniqs%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_rest_of_uniqs:
	Gui, Submit, NoHide
	current_affiliation_group = rest_of_uniqs
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_rest_of_uniqs%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_rest_of_uniqs:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_rest_of_uniqs%.wav
	return

RunColorPicker_utility_flasks_Text:
	button_affiliation_group = utility_flasks
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_utility_flasks_Border:
	button_affiliation_group = utility_flasks
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_utility_flasks_Background:
	button_affiliation_group = utility_flasks
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_utility_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = utility_flasks
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_utility_flasks
	{
		New_Value_for_Config = %CheckBox_Selected_utility_flasks%
		GuiControl,,CheckBox2_Selected_utility_flasks,0
	}
	if A_GuiControl = CheckBox2_Selected_utility_flasks
	{
		New_Value_for_Config = %CheckBox2_Selected_utility_flasks%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_utility_flasks,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_utility_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = utility_flasks
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_utility_flasks%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_utility_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = utility_flasks
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_utility_flasks%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_utility_flasks:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_utility_flasks%.wav
	return

RunColorPicker_max_qual_flasks_Text:
	button_affiliation_group = max_qual_flasks
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_max_qual_flasks_Border:
	button_affiliation_group = max_qual_flasks
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_max_qual_flasks_Background:
	button_affiliation_group = max_qual_flasks
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_max_qual_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = max_qual_flasks
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_max_qual_flasks
	{
		New_Value_for_Config = %CheckBox_Selected_max_qual_flasks%
		GuiControl,,CheckBox2_Selected_max_qual_flasks,0
	}
	if A_GuiControl = CheckBox2_Selected_max_qual_flasks
	{
		New_Value_for_Config = %CheckBox2_Selected_max_qual_flasks%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_max_qual_flasks,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_max_qual_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = max_qual_flasks
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_max_qual_flasks%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_max_qual_flasks:
	Gui, Submit, NoHide
	current_affiliation_group = max_qual_flasks
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_max_qual_flasks%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_max_qual_flasks:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_max_qual_flasks%.wav
	return

RunColorPicker_quality_flasks_leveling_Text:
	button_affiliation_group = quality_flasks_leveling
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_quality_flasks_leveling_Border:
	button_affiliation_group = quality_flasks_leveling
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_quality_flasks_leveling_Background:
	button_affiliation_group = quality_flasks_leveling
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_quality_flasks_leveling:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_leveling
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_quality_flasks_leveling
	{
		New_Value_for_Config = %CheckBox_Selected_quality_flasks_leveling%
		GuiControl,,CheckBox2_Selected_quality_flasks_leveling,0
	}
	if A_GuiControl = CheckBox2_Selected_quality_flasks_leveling
	{
		New_Value_for_Config = %CheckBox2_Selected_quality_flasks_leveling%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_quality_flasks_leveling,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_quality_flasks_leveling:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_leveling
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_quality_flasks_leveling%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_quality_flasks_leveling:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_leveling
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_quality_flasks_leveling%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_quality_flasks_leveling:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_quality_flasks_leveling%.wav
	return

RunColorPicker_quality_flasks_normal_Text:
	button_affiliation_group = quality_flasks_normal
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_quality_flasks_normal_Border:
	button_affiliation_group = quality_flasks_normal
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_quality_flasks_normal_Background:
	button_affiliation_group = quality_flasks_normal
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_quality_flasks_normal:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_normal
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_quality_flasks_normal
	{
		New_Value_for_Config = %CheckBox_Selected_quality_flasks_normal%
		GuiControl,,CheckBox2_Selected_quality_flasks_normal,0
	}
	if A_GuiControl = CheckBox2_Selected_quality_flasks_normal
	{
		New_Value_for_Config = %CheckBox2_Selected_quality_flasks_normal%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_quality_flasks_normal,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_quality_flasks_normal:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_normal
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_quality_flasks_normal%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_quality_flasks_normal:
	Gui, Submit, NoHide
	current_affiliation_group = quality_flasks_normal
	current_affiliation_type = AlertSound
	New_Value_for_Config = %DDL_Selected_Alert_Sound_quality_flasks_normal%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_quality_flasks_normal:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_quality_flasks_normal%.wav
	return

RunColorPicker_group_animate_weapon_name_Text:
	button_affiliation_group = group_animate_weapon_name
	button_affiliation_type = Text
	Gosub RunColorPicker
	return
RunColorPicker_group_animate_weapon_name_Border:
	button_affiliation_group = group_animate_weapon_name
	button_affiliation_type = Border
	Gosub RunColorPicker
	return
RunColorPicker_group_animate_weapon_name_Background:
	button_affiliation_group = group_animate_weapon_name
	button_affiliation_type = Background
	Gosub RunColorPicker
	return
CheckBox_Action_group_animate_weapon_name:
	Gui, Submit, NoHide
	current_affiliation_group = group_animate_weapon_name
	current_affiliation_type = CheckBox_DH
	if A_GuiControl = CheckBox_Selected_group_animate_weapon_name
	{
		New_Value_for_Config = %CheckBox_Selected_group_animate_weapon_name%
		GuiControl,,CheckBox2_Selected_group_animate_weapon_name,0
	}
	if A_GuiControl = CheckBox2_Selected_group_animate_weapon_name
	{
		New_Value_for_Config = %CheckBox2_Selected_group_animate_weapon_name%
		if New_Value_for_Config = 1
			New_Value_for_Config = 2
		GuiControl,,CheckBox_Selected_group_animate_weapon_name,0
	}
	Gosub Edit_Config_File
	if CheckBox_Selected_%current_affiliation_group% = 0
	{
		if CheckBox2_Selected_%current_affiliation_group% = 0
		{
			GuiControl, Hide, Pic_Box_overlay_%current_affiliation_group%
			return
		}
	}
	GuiControl, Show, Pic_Box_overlay_%current_affiliation_group%
	return
DDL_Action_Font_Size_group_animate_weapon_name:
	Gui, Submit, NoHide
	current_affiliation_group = group_animate_weapon_name
	current_affiliation_type = FontSize
	New_Value_for_Config = %DDL_Selected_Font_Size_group_animate_weapon_name%
	Gosub Edit_Config_File
	return
DDL_Action_Alert_Sound_group_animate_weapon_name:
	Gui, Submit, NoHide
	if DDL_Selected_Alert_Sound_group_animate_weapon_name > 100
		DDL_Selected_Alert_Sound_group_animate_weapon_name = 100
	if DDL_Selected_Alert_Sound_group_animate_weapon_name < 0
		DDL_Selected_Alert_Sound_group_animate_weapon_name = 0
	; GuiControl,, DDL_Selected_Alert_Sound_group_animate_weapon_name, %DDL_Selected_Alert_Sound_group_animate_weapon_name%	; Fcks up the Carret and makes you write 001 instead of 100 if you first type 1, then 0, and then 0 again
	current_affiliation_group = group_animate_weapon_name
	current_affiliation_type = DropLevel
	New_Value_for_Config = %DDL_Selected_Alert_Sound_group_animate_weapon_name%
	Gosub Edit_Config_File
	return
Play_Alert_Sound_group_animate_weapon_name:
	SoundPlay, %A_ScriptDir%\AlertSounds\AlertSound_%DDL_Selected_Alert_Sound_group_animate_weapon_name%.wav
	return




RunColorPicker:
	Gui submit, nohide
	
	; FileDelete, OldColor.txt			; That was an attempt to make the ColorPicker start with the previously selected Color, instead of always starting with 0 0 0 - (black)
	; GuiControlGet, ColorPreview_%button_affiliation_group%_%button_affiliation_type%
	; WhyNotEasy_DoubleRef = % ColorPreview_%button_affiliation_group%_%button_affiliation_type%
	; FileAppend, %ColorPreview_%button_affiliation_group%_%button_affiliation_type%%, OldColor.txt
	
	Run, ColorPicker.exe
	FileDelete, ColorPick_Done.txt
	FileAppend, 0, ColorPick_Done.txt
	
	Loop
	{
		FileRead, Check_ColorPick_Done, ColorPick_Done.txt
		if Check_ColorPick_Done = 2
		{
			; MsgBox, Color Picking has been canceled.`n`nPreview_Field and Config_file have not been changed!
			break
		}
		if Check_ColorPick_Done = 1
		{
			; MsgBox, Color Pick Done!						; kinda debug  --- unnecessary
			
			FileRead, RGB_Value, ColorPick.txt
			StringSplit, splitRGB_Value, RGB_Value, %A_Space%
			Red_Value = %splitRGB_Value1%
			Green_Value = %splitRGB_Value2%
			Blue_Value = %splitRGB_Value3%
			
			; MsgBox, RGB Value: %Red_Value% %Green_Value% %Blue_Value%
			
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
			
			
			New_Color_Value =%Red_Value%%Green_Value%%Blue_Value%
			; MsgBox, debug 2: %New_Color_Value%
			if button_affiliation_type = Text
			{
				StartupRemember_TextColor_%button_affiliation_group% = %New_Color_Value%
				Current_Preview_Text_Size = % Mem_Preview_Text_Size%button_affiliation_group%
				if Current_Preview_Text_Size =
				{
					temporary_DoubleRef_var = % DDL_Selected_Font_Size_%current_affiliation_group%
					MsgBox, 1: %temporary_DoubleRef_var%
					GuiControlGet, temporary_DoubleRef_var
					MsgBox, 2: %temporary_DoubleRef_var%
					Preview_Text_Size = %temporary_DoubleRef_var%
					MsgBox, 3: %Preview_Text_Size%
					Preview_Text_Size = % DDL_Selected_Font_Size_%current_affiliation_group%
					MsgBox, 4: %Preview_Text_Size%
					Preview_Text_Size += 19
					Preview_Text_Size /= 3.2					; Will use this value for the font size of Preview Text itself and also for calculating the Preview_Field_Factor
					Mem_Preview_Text_Size%current_affiliation_group% = %Preview_Text_Size%
					Current_Preview_Text_Size = % Mem_Preview_Text_Size%current_affiliation_group%
				}
				MsgBox, Current Text Size: %Current_Preview_Text_Size%
				Gui, font, s%Current_Preview_Text_Size% w560 c%New_Color_Value%, Fontin SmallCaps
				GuiControl, Font, ColorPreview_%button_affiliation_group%_%button_affiliation_type%
				Gui, font,
				
				;alternative block preview thing
				;GuiControl, +Background%New_Color_Value%, ColorPreview_%button_affiliation_group%_Text_tmp
				
				/*
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Text
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Border
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Background
				
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Border
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Background
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Text
				*/
			}
			else
			{
				GuiControl, +Background%New_Color_Value%, ColorPreview_%button_affiliation_group%_%button_affiliation_type%
				
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Text
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Border
				GuiControl, Hide, ColorPreview_%button_affiliation_group%_Background
				
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Border
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Background
				GuiControl, Show, ColorPreview_%button_affiliation_group%_Text
			}
			
			;══════════════════════════════════════( Edit Config File - Part of ColorPicker )════════════════════════════════════════
			FileCopy, %Config_File%.txt, %Config_File%_old.txt , 1
			FileDelete, %Config_File%.txt
			
			; button_affiliation_group = fishing_rod
			; button_affiliation_type = Text
			
			SourceFile = %Config_File%_old.txt
			target_item_found = 0
			edit_next_line = 0

			Loop
			{
				FileReadLine, line, %Config_File%_old.txt, %A_Index%
				if ErrorLevel
				{
					FileDelete, %Config_File%_old.txt
					FileDelete, ColorPick.txt
					FileDelete, ColorPick_Done.txt
					; MsgBox %ErrorLevel%		;	<--- works perfectly
					break
				}
				
				if target_item_found = 1
				{
					if line contains %button_affiliation_type%
					{
						target_item_found = 0
						edit_next_line = 1
					}
					FileAppend, %line%`n, %Config_File%.txt
					continue
				}
				if edit_next_line = 1
				{
					edit_next_line = 0
					FileAppend, %RGB_Value%`n, %Config_File%.txt
					continue
				}
				if line not contains %button_affiliation_group%
				{
					FileAppend, %line%`n, %Config_File%.txt
					continue
				}
				if line contains %button_affiliation_group%
				{
					target_item_found = 1
					if line not contains #edited
						FileAppend, %line%#edited`n, %Config_File%.txt
					if line contains #edited
						FileAppend, %line%`n, %Config_File%.txt
				}
			}
			
			break
		}
	}
	return

;══════════════════════════════════════( Edit Config File - Standalone )════════════════════════════════════════
Edit_Config_File:
	if current_affiliation_type = FontSize
	{
		Preview_Text_Size = %New_Value_for_Config%
		Preview_Text_Size += 0
		Preview_Text_Size /= 3.2					; Will use this value for the font size of Preview Text itself and also for calculating the Preview_Field_Factor
		Mem_Preview_Text_Size%current_affiliation_group% = %Preview_Text_Size%
		
		Preview_Field_Factor = %Preview_Text_Size%
		Preview_Field_Factor /= 10.0					; to get a float (1.1 instead of 1) output you have to use 10.0 instead of 10 
		
		Border_Preview_W = % Preview_Field_Factor *156 +4
		Border_Preview_H = % Preview_Field_Factor *18 +4
		Background_Preview_W = % Preview_Field_Factor *156
		Background_Preview_H = % Preview_Field_Factor *18
		Text_Preview_Field_W = % Preview_Field_Factor *156 -2
		
		; Could use MoveDraw instead of Move if there is a need for solving painting artifacts (for example from GroupBoxes)
		GuiControl, Move, ColorPreview_%current_affiliation_group%_Border, w%Border_Preview_W% h%Border_Preview_H%
		GuiControl, Move, ColorPreview_%current_affiliation_group%_Background, w%Background_Preview_W% h%Background_Preview_H%
		GuiControl, Move, ColorPreview_%current_affiliation_group%_Text, w%Text_Preview_Field_W%
		
		Mem_TextC_DoubleRef = % StartupRemember_TextColor_%current_affiliation_group%
		Current_Preview_Text_Size = % Mem_Preview_Text_Size%current_affiliation_group%
		
		Gui, font, s%Current_Preview_Text_Size% w560 c%Mem_TextC_DoubleRef%, Fontin SmallCaps
		GuiControl, Font, ColorPreview_%current_affiliation_group%_Text
		Gui, font,
	}
	
	FileCopy, %Config_File%.txt, %Config_File%_old.txt , 1
	FileDelete, %Config_File%.txt
	
	; current_affiliation_group = fishing_rod
	; current_affiliation_type = Text
	; New_Value_for_Config = 255 0 255
	
	SourceFile = %Config_File%_old.txt
	target_item_found = 0
	edit_next_line = 0

	Loop
	{
		FileReadLine, line, %Config_File%_old.txt, %A_Index%
		if ErrorLevel
		{
			FileDelete, %Config_File%_old.txt
			FileDelete, ColorPick.txt
			FileDelete, ColorPick_Done.txt
			; MsgBox %ErrorLevel%		;	<--- works perfectly
			break
		}
		
		if target_item_found = 1
		{
			if line contains %current_affiliation_type%
			{
				target_item_found = 0
				edit_next_line = 1
			}
			FileAppend, %line%`n, %Config_File%.txt
			continue
		}
		if edit_next_line = 1
		{
			edit_next_line = 0
			FileAppend, %New_Value_for_Config%`n, %Config_File%.txt
			continue
		}
		if line not contains %current_affiliation_group%
		{
			FileAppend, %line%`n, %Config_File%.txt
			continue
		}
		if line contains %current_affiliation_group%
		{
			target_item_found = 1
			
			; Making an exception for the	insert_animate_weapon_here	cause insert_build and insert_defence don't work if insert_animate_weapon_here has an #edited next to it.
			; if line contains #insert_animate_weapon_here
			; {
			; 	FileAppend, %line%`n, %Config_File%.txt
			; 	continue
			; }
			if line not contains #edited
				FileAppend, %line%#edited`n, %Config_File%.txt
			if line contains #edited
				FileAppend, %line%`n, %Config_File%.txt
		}
	}
	return


Check_for_better_Item_Preview_Example()
{
	global
	;MsgBox, %Item_Preview_Example%
	if Item_Preview_Example = Ex, Et, Divine
	{
		Item_Preview_Example = Exalted Orb
		Return
	}
	if Item_Preview_Example = High Value Currency
	{
		Item_Preview_Example = Gemcutter's Prism
		Return
	}
	if Item_Preview_Example = Low Value Currency
	{
		Item_Preview_Example = Orb of Alteration
		Return
	}
	if Item_Preview_Example = Rest of Currency
	{
		Item_Preview_Example = Portal Scroll
		Return
	}
	if Item_Preview_Example = 6 Sockets
	{
		Item_Preview_Example = 6 Socket Item
		Return
	}
	if Item_Preview_Example = Chromatic Items
	{
		Item_Preview_Example = RGB Item
		Return
	}
	if Item_Preview_Example = 80+ Maps
	{
		Item_Preview_Example = Palace Map
		Return
	}
	if Item_Preview_Example = 79 && 78 Maps
	{
		Item_Preview_Example = Shipyard Map
		Return
	}
	if Item_Preview_Example = 77 && 76 Maps
	{
		Item_Preview_Example = Necropolis Map
		Return
	}
	if Item_Preview_Example = 75 && 74 Maps
	{
		Item_Preview_Example = Canyon Map
		Return
	}
	if Item_Preview_Example = 73 && 72 Maps
	{
		Item_Preview_Example = Strand Map
		Return
	}
	if Item_Preview_Example = 71 && 70 Maps
	{
		Item_Preview_Example = Tunnel Map
		Return
	}
	if Item_Preview_Example = Rest of Maps
	{
		Item_Preview_Example = Dungeon Map
		Return
	}
	if Item_Preview_Example = Midnight and Hope
	{
		Item_Preview_Example = Mortal Hope
		Return
	}
	if Item_Preview_Example = Rest of Fragments
	{
		Item_Preview_Example = Sacrifice at Dusk
		Return
	}
	if Item_Preview_Example = Valuable Gems
	{
		Item_Preview_Example = Empower
		Return
	}
	if Item_Preview_Example = Vaal Gems
	{
		Item_Preview_Example = Vaal Spark
		Return
	}
	if Item_Preview_Example = 14+ Quality Gems
	{
		Item_Preview_Example = Superior Arc
		Return
	}
	if Item_Preview_Example = Rest of Quality Gems
	{
		Item_Preview_Example = Superior Spark
		Return
	}
	if Item_Preview_Example = Jewels
	{
		Item_Preview_Example = Crimson Jewel
		Return
	}
	if Item_Preview_Example = Rest of Uniques
	{
		Item_Preview_Example = Plate Vest
		Return
	}
	if Item_Preview_Example = Utility Flasks
	{
		Item_Preview_Example = Quicksilver Flask
		Return
	}
	if Item_Preview_Example = Max qual Flasks
	{
		Item_Preview_Example = 20`% Flask
		Return
	}
	if Item_Preview_Example = qual Flasks ilvl 1-59
	{
		Item_Preview_Example = 6-19`% Flask
		Return
	}
	if Item_Preview_Example = Quality Flasks Rest
	{
		Item_Preview_Example = 10-19`% Flask
		Return
	}
	if Item_Preview_Example = Animate Weapon
	{
		Item_Preview_Example = Melee Weapon
		Return
	}
	Return
}

Action_Setup_Guide_all:
	GUI, SetupGuide:Show
	return

; completely useless fun thing START
DoSomething:
	do_thing()
	return

; completely useless fun thing
do_thing()
{
	global
	
	do_thing_counter += 1
	if do_thing_counter = 1
		Random, rand_too_greedy, 2, 7
	if (do_thing_counter > rand_too_greedy)
		too_greedy = 1
	
	Random, check_rand_luck_number, 1, 4
	if check_rand_luck_number < 4
		Random, rand_luck_number, 1, 12
	if check_rand_luck_number = 4
		Random, rand_luck_number, 8, 26
	if rand_luck_number = old_rand_luck_number
		rand_luck_number += 1
	old_rand_luck_number = %rand_luck_number%
	
	if too_greedy = 1
	{
		Msgbox Your luck has been decreased`nby %rand_luck_number%`%.`n`nYour greed blinds you!
		return
	}
	Random, rand_msg_number, 1, 2
	if rand_msg_number = 1
		Msgbox Your luck has been increased`nby %rand_luck_number%`%.`n`nMay the loot be with you!
	if rand_msg_number = 2
		Msgbox Your luck has been increased`nby %rand_luck_number%`%.`n`nThe loot will be with you, always!
	return
	; useless fun thing END
}

Calc_GUI_Spawn_Point()
{
	global
	; requires you to first define height_GUI and width_GUI
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

; Ctrl + Esc will close the program!
^Esc::ExitApp

Build_SetupGuide_GUI()
{
	global
	SetupGuide_ActiveImage = 1
	Gui, SetupGuide: +ToolWindow
	Gui, SetupGuide:Add, Picture, 	x5 		y5 		w900		vSetupGuide_Pic1, %A_WorkingDir%\SetupGuide\1_Open the Options.png
	Gui, SetupGuide:Add, Picture, 	x5 		y125 	w900 h183	vSetupGuide_Pic2, %A_WorkingDir%\SetupGuide\2_Click on UI tab.png
	GuiControl, SetupGuide: Hide, SetupGuide_Pic2
	Gui, SetupGuide:Add, Picture, 	x120 	y125 				vSetupGuide_Pic3, %A_WorkingDir%\SetupGuide\3_Scroll down and click DDL.png
	GuiControl, SetupGuide: Hide, SetupGuide_Pic3
	Gui, SetupGuide:Add, Picture, 	x185 	y125 				vSetupGuide_Pic4, %A_WorkingDir%\SetupGuide\4_Select and check Chat.png
	GuiControl, SetupGuide: Hide, SetupGuide_Pic4
	Gui, SetupGuide:font, s12 w560
	Gui, SetupGuide:Add, Text,	x15 		y385 	w280 h60 	Left,Arrow Keys:`nRight = Next Image`nLeft = Previous Image
	Gui, SetupGuide:font, s12 w560
	Gui, SetupGuide:Add, Button,	x470 	y400 	w120 h30 Center gSetupGuide_NextPicture,Next
	Gui, SetupGuide:Add, Button,	x330 	y400 	w120 h30 Center gSetupGuide_PreviousPicture,Previous
	Gui, SetupGuide:Add, Button,	x760 	y400 	w120 h30 Center gHideSetupGuide,Close
	Gui, SetupGuide:Show, Hide Center h450 w910,SetupGuide
	Return
}

#IfWinActive SetupGuide
Right::Gosub SetupGuide_NextPicture

#IfWinActive SetupGuide
Left::Gosub SetupGuide_PreviousPicture

SetupGuide_NextPicture:
	GuiControl, SetupGuide: Hide, SetupGuide_Pic%SetupGuide_ActiveImage%
	SetupGuide_ActiveImage += 1
	if SetupGuide_ActiveImage > 4
		SetupGuide_ActiveImage = 4
	GuiControl, SetupGuide: Show, SetupGuide_Pic%SetupGuide_ActiveImage%
	return

SetupGuide_PreviousPicture:
	GuiControl, SetupGuide: Hide, SetupGuide_Pic%SetupGuide_ActiveImage%
	SetupGuide_ActiveImage -= 1
	if SetupGuide_ActiveImage < 1
		SetupGuide_ActiveImage = 1
	GuiControl, SetupGuide: Show, SetupGuide_Pic%SetupGuide_ActiveImage%
	return
HideSetupGuide:
	GUI, SetupGuide:Hide
	return
