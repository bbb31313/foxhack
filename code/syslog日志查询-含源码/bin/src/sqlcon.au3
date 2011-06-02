#include-once
#include "ezmysql.au3"
#include <GuiListView.au3>

Func _read_ini()                                   
	Local $ip,$user,$pass,$db,$port
	$ip=IniRead("dbcon.ini", "dbinfo", "ip","")
	$user=IniRead("dbcon.ini", "dbinfo", "user","")
    $pass=IniRead("dbcon.ini", "dbinfo", "pass","")
	$db=IniRead("dbcon.ini", "dbinfo", "db","")
	$port=IniRead("dbcon.ini", "dbinfo", "port","")
	Return $ip&"|"&$user&"|"&$pass&"|"&$db&"|"&$port
EndFunc


Func addlist($listview,$aOk)
 Local $aItems
 Local $rows,$cols
$rows = UBound($aOk)
$cols = UBound($aOk, 2)
If $rows > 1 Then
	 Dim $aItems[$rows-1][$cols]
	_GUICtrlListView_DeleteAllItems ($listview)
	For $iI = 0 To $rows - 2
		For $nI=0 To $cols-1
			$aItems[$iI][$nI] = $aOk[$iI+1][$nI]
		Next
	Next
	_GUICtrlListView_AddArray($listview, $aItems)
Else
	_GUICtrlListView_DeleteAllItems ($listview)
EndIf
EndFunc

Func sql_query($sqlstr,$sql_string,$pn)     
Local $sql,$aOk,$error

$sql=StringSplit($sqlstr,"|")

_EzMySql_Startup() 
_EzMySql_Open($sql[1], $sql[2], $sql[3], "", $sql[5]) 
_EzMySql_SelectDB($sql[4])

$sql_quer=$sql_string&" limit "&($pn-1)*50&",50"
;MsgBox(0,"",$sql_quer)
$aOk=_EzMySql_GetTable2d($sql_quer)

$error = @error

;If Not IsArray($aOk) Then 
;MsgBox(0,   "错误信息", "错误号："&$error&" "&"数据库无此表，请检查数据库配置文件！！")
;Return -1
;EndIf
;_ArrayDisplay($aOk)
_EzMySql_Close()          ;关闭MYSQL连接
_EzMySql_ShutDown()       
Return $aOk
EndFunc


Func _ReduceMemory($i_PID = -1);整理内存
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc 




