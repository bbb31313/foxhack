#include-once
#include "ezmysql.au3"
#include <GuiListView.au3>
;~ #include "coproc.au3"
Func _read_ini()
	Local $ip, $user, $pass, $db, $port
	$ip = IniRead("dbcon.ini", "dbinfo", "ip", "")
	$user = IniRead("dbcon.ini", "dbinfo", "user", "")
	$pass = IniRead("dbcon.ini", "dbinfo", "pass", "")
	$db = IniRead("dbcon.ini", "dbinfo", "db", "")
	$port = IniRead("dbcon.ini", "dbinfo", "port", "")
	Return $ip & "|" & $user & "|" & $pass & "|" & $db & "|" & $port
EndFunc   ;==>_read_ini


Func _select_syslog($sqlstr, $sql_string) ;
	Local $sql, $aOk, $error
	$sql = StringSplit($sqlstr, "|")
	
	If Not _EzMySql_Startup()  Then
		Return 0
	EndIf
	
	
	If Not _EzMySql_Open($sql[1], $sql[2], $sql[3], "", $sql[5]) Then
		Return -1
	EndIf
	
	_EzMySql_SelectDB($sql[4])
	
	$aOk = _EzMySql_GetTable2d($sql_string)
	
    If Not IsArray($aOk) Then
		Return -2
	EndIf
	
	_EzMySql_Close() ;¹Ø±ÕMYSQLÁ¬½Ó
	_EzMySql_ShutDown()
	Return $aOk
EndFunc   ;==>_select_syslog

Func addlist($listview, $aOk)
	Local $aItems
	Local $rows, $cols
	$rows = UBound($aOk)
	$cols = UBound($aOk, 2)
	If $rows > 1 Then
		Dim $aItems[$rows - 1][$cols]
		_GUICtrlListView_DeleteAllItems($listview)
		For $iI = 0 To $rows - 2
			For $nI = 0 To $cols - 1
				$aItems[$iI][$nI] = $aOk[$iI + 1][$nI]
			Next
		Next
		_GUICtrlListView_AddArray($listview, $aItems)
	Else
		_GUICtrlListView_DeleteAllItems($listview)
	EndIf
EndFunc   ;==>addlist



