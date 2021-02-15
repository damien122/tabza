#include-once
#include "../app.au3"
#include "ExpGetRunningInst.au3"


Func InitApp()
	;~ Local $aAllWindows = GetExplorerWindows()
	;~ _arraydisplay($aAllWindows)
	;~ For $i = 0 To UBound($aAllWindows, 1) - 1
	;~ 	Local $hWnd = $aAllWindows[$i][1]
	;~ 	Local $title = $aAllWindows[$i][0]
	;~ Next


	CreateExporerTab()
EndFunc


Func ShowTab($selectedTabIndex)
	If ($selectedTabIndex == 0) Then
		CreateExporerTab()
		Return
	EndIf

	GUISetState(@SW_LOCK, $hMainWnd)
	Local $currentSelectedTabIndex = _GUICtrlTab_GetCurSel($TabControl)
	If $currentSelectedTabIndex <> $selectedTabIndex Then _GUICtrlTab_SetCurSel($TabControl, $selectedTabIndex)
	
	For $i = 0 To UBound($allExplorerhWnd, 1) - 1
		If ($allExplorerhWnd[$i][$tabindex] == $selectedTabIndex) Then
			ControlShow($hMainWnd, "", $allExplorerhWnd[$i][$picControlHandle])
		Else
			ControlHide($hMainWnd, "", $allExplorerhWnd[$i][$picControlHandle])
		EndIf
	Next

	GUISetState(@SW_UNLOCK, $hMainWnd)
EndFunc


Func HideAllExplorerControls()
	For $i = 0 To UBound($allExplorerhWnd, 1) - 1
		ControlHide($hMainWnd, "", $allExplorerhWnd[$i][$picControlHandle])
	Next
EndFunc


Func ExitApp()
	For $i = 0 To UBound($allExplorerhWnd, 1) - 1
		ProcessClose($allExplorerhWnd[$i][$pid])
	Next
	Exit
EndFunc


Func CloseCurentTab()
	HideAllExplorerControls()
	Local $nextTab
	Local $countTabs
	Local $currentTab = _GUICtrlTab_GetCurSel($TabControl)

	For $i = 0 To UBound($allExplorerhWnd, 1) - 1
		If ($allExplorerhWnd[$i][$tabindex] == $currentTab) Then
			$nextTab = $currentTab
			ProcessClose($allExplorerhWnd[$i][$pid])
			GUICtrlDelete($allExplorerhWnd[$i][$picControlId])
			_GUICtrlTab_DeleteItem($TabControl, $allExplorerhWnd[$i][$tabindex])

			For $x = $i To UBound($allExplorerhWnd, 1) - 1
				$allExplorerhWnd[$x][$tabindex] -= 1
			Next

			_ArrayDelete($allExplorerhWnd, $i)
			
			$countTabs = _GUICtrlTab_GetItemCount($TabControl) - 1
			
			If $countTabs <= 0 Then
				CreateExporerTab()
				Return
			EndIf

			If $nextTab > $countTabs Then 
				$nextTab -= 1
			EndIf

			ShowTab($nextTab)
			Return
		EndIf
	Next
EndFunc


Func ShowNextTab()
	Local $currentSelectedTabIndex = _GUICtrlTab_GetCurSel($TabControl)
	Local $countTabs = _GUICtrlTab_GetItemCount($TabControl) - 1

	$currentSelectedTabIndex += 1

	If ($currentSelectedTabIndex > $countTabs) Then
		$currentSelectedTabIndex = 1
	EndIf

	ShowTab($currentSelectedTabIndex)
EndFunc


Func ShowPrevTab()
	Local $currentSelectedTabIndex = _GUICtrlTab_GetCurSel($TabControl)
	Local $countTabs = _GUICtrlTab_GetItemCount($TabControl) - 1

	$currentSelectedTabIndex -= 1

	If ($currentSelectedTabIndex <= 0) Then
		$currentSelectedTabIndex = $countTabs
	EndIf

	ShowTab($currentSelectedTabIndex)
EndFunc


Func D_ConsoleWriteArrayEntry($index)
	ConsoleWrite('$pid = ' & $allExplorerhWnd[$index][$pid] & @CRLF)
	ConsoleWrite('$handle = ' & $allExplorerhWnd[$index][$handle] & @CRLF)
	ConsoleWrite('$path = ' & $allExplorerhWnd[$index][$path] & @CRLF)
	ConsoleWrite('$tabindex = ' & $allExplorerhWnd[$index][$tabindex] & @CRLF)
	ConsoleWrite('$picControlId = ' & $allExplorerhWnd[$index][$picControlId] & @CRLF)
	ConsoleWrite('$picControlHandle = ' & $allExplorerhWnd[$index][$picControlHandle] & @CRLF)
EndFunc


Func CreateExporerTab()
	HideAllExplorerControls()

	Local $size = UBound($allExplorerhWnd, 1)
	Redim $allExplorerhWnd[$size+1][6]
		
	Local $clientSize = WinGetClientSize($hMainWnd)
	Local $tabItemCount = _GUICtrlTab_GetItemCount($TabControl)
	_GUICtrlTab_InsertItem ( $TabControl, $tabItemCount+1, $tabCount)

	$tabCount += 1
	

	Local $picCtrlId = GUICtrlCreatePic("", 0, 0+$iTabHeight, $clientSize[0], $clientSize[1]-$iTabHeight)
	GUICtrlSetBkColor($picCtrlId, $COLOR_BLACK)
	Local $picCtrlHwnd = ControlGetHandle($hMainWnd, "", $picCtrlId)
	ControlShow($hMainWnd, "", $picCtrlHwnd)

	Run("explorer.exe /n, C:\")  ; Set it the folder you want as a start point
	WinWait("[CLASS:CabinetWClass]")
	Global $hExplorer = WinGetHandle("[CLASS:CabinetWClass]")
	_WinAPI_SetParent($hExplorer, $picCtrlHwnd)
	Local $iStyle = _WinAPI_GetWindowLong($hExplorer, $GWL_STYLE)
	; Remove from the window style the MAXIMIZEBOX, MINIMIZEBOX and SIZEBOX styles.
	$iStyle = BitXOR($iStyle, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_BORDER, $WS_CLIPSIBLINGS)
	; Set the style of the window.
	_WinAPI_SetWindowLong($hExplorer, $GWL_STYLE, $iStyle)
	Local $clientSizePic = WinGetClientSize($picCtrlHwnd)
	_WinAPI_SetWindowPos($hExplorer, $HWND_TOP, 0, -35, $clientSizePic[0], $clientSizePic[1]+35, $SWP_SHOWWINDOW)

	Local $tabElement = _GUICtrlTab_FindTab ( $TabControl, $tabCount-1) 

	$allExplorerhWnd[$size][$pid] = WinGetProcess($hExplorer)
	$allExplorerhWnd[$size][$picControlId] = $picCtrlId
	$allExplorerhWnd[$size][$picControlHandle] = $picCtrlHwnd
	$allExplorerhWnd[$size][$handle] = $hExplorer
	$allExplorerhWnd[$size][$path] = "C:\\"
	$allExplorerhWnd[$size][$tabindex] = $tabElement
	
	_GUICtrlTab_SetCurSel($TabControl, $tabElement)
EndFunc