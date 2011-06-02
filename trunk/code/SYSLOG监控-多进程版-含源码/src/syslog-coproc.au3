#Region ;**** ���������� ACNWrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include "function.au3"
#include "array.au3"
#include "coproc.au3"
#include <GuiButton.au3>
Opt("TrayIconHide", 1)


If FileExists("dbcon.ini") = 0 Then
	MsgBox(0, "����", "���������ļ��Ƿ����") ;��������ļ�
	Exit
EndIf

TCPStartup()
$temp_ip = IniRead("dbcon.ini", "dbinfo", "ip", "")
$temp_port = IniRead("dbcon.ini", "dbinfo", "port", "")

If TCPConnect($temp_ip, $temp_port) < 1 Then
	MsgBox(0, "�������", "���������ļ���IP���߶˿��Ƿ���ȷ����") ;�ж������ļ��˿�IP�Ƿ���ȷ
	Exit
EndIf
TCPShutdown()

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("SYSLOG-���--VERSION 0.1 BY:foxhack", 1281, 768, 80, 37)
$Label1 = GUICtrlCreateLabel("������Ϣ", 8, 16, 52, 17)
$msg = GUICtrlCreateLabel("", 56, 0, 892, 40)
Global $dev_ListView, $emerg_ListView, $alert_ListView, $crit_ListView, $err_ListView, $war_ListView, $item
$Group1 = GUICtrlCreateGroup("�豸����-DEV", 8, 40, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$dev_ListView = _GUICtrlListView_Create($Form1, "", 10, 52, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($dev_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($dev_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($dev_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($dev_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($dev_ListView, "�澯��Ϣ", 296)

$Group2 = GUICtrlCreateGroup("�������-EMERG", 640, 40, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$emerg_ListView = _GUICtrlListView_Create($Form1, "", 642, 52, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($emerg_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($emerg_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($emerg_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($emerg_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($emerg_ListView, "�澯��Ϣ", 296)

$Group3 = GUICtrlCreateGroup("��ע�����-ALERT", 8, 280, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$alert_ListView = _GUICtrlListView_Create($Form1, "", 10, 292, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($alert_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($alert_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($alert_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($alert_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($alert_ListView, "�澯��Ϣ", 296)

$Group4 = GUICtrlCreateGroup("��Ҫ���-CRIT", 640, 280, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$crit_ListView = _GUICtrlListView_Create($Form1, "", 642, 292, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($crit_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($crit_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($crit_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($crit_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($crit_ListView, "�澯��Ϣ", 296)

$Group5 = GUICtrlCreateGroup("����-ERR", 8, 520, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$err_ListView = _GUICtrlListView_Create($Form1, "", 10, 532, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($err_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($err_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($err_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($err_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($err_ListView, "�澯��Ϣ", 296)

$Group6 = GUICtrlCreateGroup("����-WARNING", 640, 520, 630, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$war_ListView = _GUICtrlListView_Create($Form1, "", 642, 532, 625, 225, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($war_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($war_ListView, "����ʱ��", 125)
_GUICtrlListView_AddColumn($war_ListView, "�豸��", 100)
_GUICtrlListView_AddColumn($war_ListView, "��ԴIP", 80)
_GUICtrlListView_AddColumn($war_ListView, "�澯��Ϣ", 296)

$Button1 = GUICtrlCreateButton("��ʼ", 960, 8, 89, 25)
$Button2 = GUICtrlCreateButton("ֹͣ", 1056, 8, 81, 25)
;$Button3 = GUICtrlCreateButton("��ϸ��ѯ", 1144, 8, 129, 25)

_GUICtrlButton_Enable($Button2, False)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_CoProcReciver("Reciver")



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Button1
			$str = _read_ini()
			$ipid_dev = _CoProc("dev", $str) ;�����ӽ���
			$ipid_emerg = _CoProc("emerg", $str)
			$ipid_alert = _CoProc("alert", $str)
			$ipid_crit = _CoProc("crit", $str)
			$ipid_err = _CoProc("err", $str)
			$ipid_war = _CoProc("war", $str)
			_GUICtrlButton_Enable($Button2, True)
			_GUICtrlButton_Enable($Button1, False)
		Case $Button2
			ProcessClose($ipid_dev) ;�����ӽ���
			ProcessClose($ipid_emerg)
			ProcessClose($ipid_alert)
			ProcessClose($ipid_crit)
			ProcessClose($ipid_err)
			ProcessClose($ipid_war)
			_GUICtrlButton_Enable($Button1, True)
			_GUICtrlButton_Enable($Button2, False)
			;Case $Button3
		Case $GUI_EVENT_CLOSE
			ProcessClose($ipid_dev) ;�����ӽ���
			ProcessClose($ipid_emerg)
			ProcessClose($ipid_alert)
			ProcessClose($ipid_crit)
			ProcessClose($ipid_err)
			ProcessClose($ipid_war)
			Exit
		Case $GUI_EVENT_SECONDARYDOWN
			MsgBox(0, "", _GUICtrlListView_GetItemTextString($dev_ListView, Number(_GUICtrlListView_GetSelectedIndices($dev_ListView))))
	EndSwitch
WEnd


Func _strtoarray($listview, $str) ;�ַ���ת���麯��
	Local $array
	$array = StringSplit($str, "$$", 1)
	Local $row = $array[0] / 4, $n
	$n = 1

	If $row = 0 Then
		$row = 1
	EndIf

	Dim $data[$row][4]
	For $iI = 0 To $row - 1
		For $in = 0 To 3
			$data[$iI][$in] = $array[$n]
			$n += 1
		Next
	Next
	addlist($listview, $data)
EndFunc   ;==>_strtoarray


;~ Func _strtoarray($listview, $str) ;�ַ���ת���麯��
;~ 	Local $array
;~ 	$array = StringSplit($str, "$$", 1)
;~ 	Local $row = $array[0] / 4, $n
;~ 	$n = 1
;~ 	Dim $data[$row][4]
;~ 	For $iI = 0 To $row - 1
;~ 		For $in = 0 To 3
;~ 			$data[$iI][$in] = $array[$n]
;~ 			$n += 1
;~ 		Next
;~ 	Next
;~ 	addlist($listview, $data)
;~ EndFunc   ;==>_strtoarray


Func Reciver($vParameter) ;��������Ϣ���ܺ���
	Local $aParam, $row
	$aParam = StringSplit($vParameter, "|")

	Switch $aParam[1]
		Case "dev"
			_strtoarray($dev_ListView, $aParam[2])
			_ReduceMemory($ipid_dev)
		Case "emerg"
			_strtoarray($emerg_ListView, $aParam[2])
			_ReduceMemory($ipid_emerg)
		Case "alert"
			_strtoarray($alert_ListView, $aParam[2])
			_ReduceMemory($ipid_alert)
		Case "crit"
			_strtoarray($crit_ListView, $aParam[2])
			_ReduceMemory($ipid_crit)
		Case "err"
			_strtoarray($err_ListView, $aParam[2])
			_ReduceMemory($ipid_err)
		Case "war"
			_strtoarray($war_ListView, $aParam[2])
			_ReduceMemory($ipid_war)
	EndSwitch

EndFunc   ;==>Reciver


Func dev($str) ;�ӽ��̺���
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM warning WHERE message LIKE '%dev_log%'  ORDER BY received DESC LIMIT 0,20;"
	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "dev|" & _ArrayToString($array, "$$"))
		EndIf
		Sleep(2000)
	WEnd
EndFunc   ;==>dev

Func emerg($str)
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM emergency ORDER BY received DESC LIMIT 0,20;"
	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "emerg|" & _ArrayToString($array, "$$"))
		EndIf
		Sleep(2000)
	WEnd
EndFunc   ;==>emerg

Func alert($str)
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM alert  ORDER BY received DESC LIMIT 0,20;"
	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "alert|" & _ArrayToString($array, "$$"))
		EndIf
		Sleep(2000)
	WEnd
EndFunc   ;==>alert

Func crit($str)
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM critical   ORDER BY received DESC LIMIT 0,20;"

	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "crit|" & _ArrayToString($array, "$$"))
		EndIf
		Sleep(2000)
	WEnd

EndFunc   ;==>crit

Func err($str)
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM error   ORDER BY received DESC LIMIT 0,20;"

	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "err|" & _ArrayToString($array, "$$"))
		EndIf
		Sleep(2000)
	WEnd

EndFunc   ;==>err

Func war($str)
	Opt("TrayIconHide", 1)
	Local $string, $sqldata
	$string = "SELECT received,origin,source_ip,message FROM warning  ORDER BY received DESC LIMIT 0,20;"

	While 1
		If Not ProcessExists($gi_CoProcParent) Then
			Return 0
			Exit
		EndIf
		$sqldata = _select_syslog($str, $string)
		Sleep(500)
		;MsgBox(0, "", $sqldata)
		If $sqldata < 1 Then
			MsgBox(0, "�ӽ��̴���", "dev�ӽ��̳��ֹ��� PIDΪ:" & @AutoItPID & @CR & "����Ŀ¼��LIBMYSQL�ļ����������ļ��Ƿ���ȷ")
			Exit
		Else
			Local $str_item, $iI, $rows, $n
			$n = 0
			$rows = UBound($sqldata)
			Dim $array[1]
			For $iI = 0 To ($rows - 2) Step 1
				For $in = 0 To 3 Step 1
					_ArrayInsert($array, $n, $sqldata[$iI + 1][$in])
					$n += 1
				Next
			Next
			_ArrayDelete($array, 80)
			_CoProcSend($gi_CoProcParent, "war|" & _ArrayToString($array, "$$"))
			_ReduceMemory($gi_CoProcParent)
		EndIf
		Sleep(2000)
	WEnd

EndFunc   ;==>war

;�����м��뵽ѭ����

Func _ReduceMemory($i_PID = -1);�����ڴ�
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory