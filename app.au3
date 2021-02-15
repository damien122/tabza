#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=.\images\tab_new_raised.ico
#AutoIt3Wrapper_Outfile=.\tabza.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Tool to creats tabs for Windows Explorer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=tabza
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=Damien122
#AutoIt3Wrapper_Res_LegalCopyright=Damien122
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.14.5
 Author:         Damien122
 Script Function:
	Creats Tabs for Windows Explorer
#ce ----------------------------------------------------------------------------
#NoTrayIcon
#include-once
#include <MsgBoxConstants.au3>
#include <WinAPIProc.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ColorConstantS.au3>
#include <TabConstants.au3>
#include <GuiTab.au3>
#include <StaticConstants.au3>
#include <StructureConstants.au3>

#include "libs/ExpGetRunningInst.au3"
#include "libs/Common.au3"

Opt("WinTitleMatchMode", 4)

Global Const $iWidth = 900
Global Const $iHeight = 700
Global Const $iTabWidth = $iWidth
Global Const $iTabHeight = 25
Global Enum $pid, $handle, $path, $tabindex, $picControlId, $picControlHandle
Global $allExplorerhWnd[0][6]
Global $tabCount = 1


#Region ### START Koda GUI section ### Form=
$hMainWnd = GUICreate("tabza", $iWidth, $iHeight, Default, Default, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX))
GUISetBkColor($COLOR_BLACK)
GUISetFont(11, 300)
$TabControl = GUICtrlCreateTab(0, 0, $iTabWidth, $iTabHeight)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT)
$plusTab = GUICtrlCreateTabItem("+")
$tabHwnd = ControlGetHandle($hMainWnd, "", $TabControl)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUIRegisterMsg($WM_SIZE, 'WM_SIZE')

HotKeySet("^w", "CloseCurentTab")
HotKeySet("^t", "CreateExporerTab")
HotKeySet("^{TAB}", "ShowNextTab")
HotKeySet("^+{TAB}", "ShowPrevTab")

InitApp()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitApp()
		Case $TabControl
			ShowTab(_GUICtrlTab_GetCurSel($TabControl))
	EndSwitch
WEnd

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	Local $clientSize = WinGetClientSize($hMainWnd)
	
	For $i = 0 To UBound($allExplorerhWnd, 1) - 1
		
		GUICtrlSetPos($allExplorerhWnd[$i][$picControlId], 0, 0 + $iTabHeight, $clientSize[0], $clientSize[1] - $iTabHeight)

		Local $clientSizePic = WinGetClientSize($allExplorerhWnd[$i][$picControlHandle])
		_WinAPI_SetWindowPos($allExplorerhWnd[$i][$handle], $HWND_TOP, 0, -35, $clientSizePic[0], $clientSizePic[1] + 35, $SWP_SHOWWINDOW)

		_WinAPI_RedrawWindow($allExplorerhWnd[$i][$picControlHandle])
		_WinAPI_RedrawWindow($allExplorerhWnd[$i][$handle])
	Next
EndFunc   ;==>WM_SIZE
