#include-once
#include <Array.au3>

Func GetExplorerWindows()
    ;~ Returns multi level array with each entry Title, Handle, PID, Process
    
        Local $list[300][4]                                                 ; 300 windows max
        Local Enum $title, $handle, $pid, $exe                              ; enumerations for array offsets
    
        ;---------------------------------------------
        ;  get array of windows and populate $list
        ;---------------------------------------------
    
        Local $a1 = WinList("[CLASS:CabinetWClass]")                                               ; get list of windows
    
        For $i = 0 To $a1[0][0]                                             ; and copy title, handle and pid to $list array
            $list[$i][$title] = $a1[$i][$title]                             ; window title
            $list[$i][$handle] = $a1[$i][$handle]                           ; window handle
            $list[$i][$pid] = WinGetProcess($a1[$i][$handle])               ; owning process id
        Next
    
        ;---------------------------------------------
        ;  get array of processes and populate $list
        ;---------------------------------------------
    
        Local $a2 = ProcessList()                                           ; get list of processes
    
        For $i = 0 To $a1[0][0]
            For $j = 0 To $a2[0][0]
                If $list[$i][2] = $a2[$j][1] Then $list[$i][3] = $a2[$j][0] ; and copy process name to $list array
            Next
        Next
    
        ReDim $list[$i][4]
    
        Local $aDeleteIndexes[0]
    
        For $i = 0 To UBound($list, 1) - 1
            If $list[$i][3] <> "explorer.exe" Then
                _ArrayAdd($aDeleteIndexes, $i)
            EndIf
        Next
    
    ;~ Delete all other Windows which are not from explorer.exe
        For $element In $aDeleteIndexes
            _ArrayDelete($list, $element)
        Next
    
    ;~ _arraydisplay($list)
    
        Return $list
    EndFunc   ;==>GetExplorerWindows
    
    
    