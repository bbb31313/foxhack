#Region ;**** ���������� ACNWrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "sqlcon.au3"
#include <date.au3>
#include  <Array.au3>
#include <GuiDateTimePicker.au3>
#include <GuiButton.au3>
#include <WinAPI.au3>
#include <GuiMenu.au3>
Opt("TrayIconHide", 1)

Global $page_num
#Region ### START Koda GUI section ### Form=C:\Documents and Settings\hehao\My Documents\cinda\Form2dddd.kxf

$Form2 = GUICreate("SYSLOG ��ѯ���� BY:foxhack E-mail:foxhack@qq.com QQ:278563291", 1090, 700, 100, 10)
$MenuItem3 = GUICtrlCreateMenu("�ļ�")
$MenuItem15 = GUICtrlCreateMenuItem("�˳�", $MenuItem3)
$MenuItem2 = GUICtrlCreateMenu("���ò�ѯ")
;$MenuItem4 = GUICtrlCreateMenuItem("�豸�澯��ѯ", $MenuItem2)
;$MenuItem5 = GUICtrlCreateMenuItem("�豸ִ�������ѯ", $MenuItem2)
;$MenuItem6 = GUICtrlCreateMenuItem("�豸��¼��ѯ", $MenuItem2)
$MenuItem7 = GUICtrlCreateMenu("�澯�����ѯ", $MenuItem2)
$MenuItem14 = GUICtrlCreateMenuItem("Emergency", $MenuItem7)
$MenuItem13 = GUICtrlCreateMenuItem("Alert", $MenuItem7)
$MenuItem12 = GUICtrlCreateMenuItem("Critical", $MenuItem7)
$MenuItem11 = GUICtrlCreateMenuItem("Error", $MenuItem7)
$MenuItem10 = GUICtrlCreateMenuItem("Warning", $MenuItem7)
$MenuItem1 = GUICtrlCreateMenu("&����")
;Global $data1,$data2
$Label1 = GUICtrlCreateLabel("��ʼʱ��", 592, 8, 52, 17)
;$Date1 = _GUICtrlDTP_Create($Form2, 648, 8, 113, 18)
$Date1 = GUICtrlCreateDate("", 648, 8, 121, 18)
$hDTP1 = GUICtrlGetHandle($Date1)
_GUICtrlDTP_SetFormat($hDTP1, "yyyy-MM-dd")
;$Date1 = GUICtrlCreateDate("", 648, 8, 121, 18,$DTS_SHORTDATEFORMAT)

$Label2 = GUICtrlCreateLabel("����ʱ��", 776, 8, 52, 17)
$Date2 = GUICtrlCreateDate("", 832, 8, 113, 18)
$hDTP2 = GUICtrlGetHandle($Date2)
_GUICtrlDTP_SetFormat($hDTP2, "yyyy-MM-dd")
;$Date2 = GUICtrlCreateDate("", 832, 8, 113, 18,$DTS_SHORTDATEFORMAT)

$Button1 = GUICtrlCreateButton("��ѯ", 976, 8, 97, 18, $BS_CENTER)

$Input1 = GUICtrlCreateInput("", 416, 8, 169, 18)
$Label3 = GUICtrlCreateLabel("��������", 360, 8, 52, 17, $SS_CENTERIMAGE)
;$Label4 = GUICtrlCreateLabel("IP��ַ", 16, 8, 38, 17)
;$IPAddress1 = _GUICtrlIpAddress_Create($Form2, 56, 8, 113, 20)
;_GUICtrlIpAddress_Set($IPAddress1, "0.0.0.0")

;$Label5 = GUICtrlCreateLabel("�豸��", 176, 8, 40, 17)
;$Input2 = GUICtrlCreateInput("", 216, 8, 137, 18)

;$frist = GUICtrlCreateButton("��  ҳ", 336, 32, 81, 18)
$pageup = GUICtrlCreateButton("��һҳ", 424, 32, 81, 18)
$pagedown = GUICtrlCreateButton("��һҳ", 520, 32, 81, 18)
;$end = GUICtrlCreateButton("β  ҳ", 608, 32, 81, 18)

;$ListView = _GUICtrlListView_Create($Form2, "", 2, 50, 1090, 630, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
$listview1 = GUICtrlCreateListView("", 2, 50, 1090, 630, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
$listview = GUICtrlGetHandle($listview1)
_GUICtrlListView_SetExtendedListViewStyle($listview, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($listview, "����ʱ��", 125)
_GUICtrlListView_AddColumn($listview, "�豸��", 100)
_GUICtrlListView_AddColumn($listview, "��ԴIP", 80)
_GUICtrlListView_AddColumn($listview, "ģ��", 80)
_GUICtrlListView_AddColumn($listview, "�澯����", 80)
_GUICtrlListView_AddColumn($listview, "�澯��Ϣ", 600)



$menu1 = GUICtrlCreateContextMenu($listview1)
$dev_log = GUICtrlCreateMenuItem("�����豸����ѯ", $menu1)
$ip_addr = GUICtrlCreateMenuItem("����IP��ַ��ѯ", $menu1)
$servity = GUICtrlCreateMenuItem("���ݸ澯�����ѯ", $menu1)
$ip_ser = GUICtrlCreateMenuItem("��IP&�澯�����ѯ", $menu1)


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
_GUICtrlButton_Enable($pageup, False)
_GUICtrlButton_Enable($pagedown, False)
GUICtrlSetState($dev_log, $GUI_DISABLE)
GUICtrlSetState($ip_addr, $GUI_DISABLE)
_ReduceMemory(@AutoItPID)


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

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $MenuItem15
			Exit
		Case $MenuItem14
			ShellExecute("/bin/syslog_Emergency.exe", _read_ini())
		Case $MenuItem13
			ShellExecute("/bin/syslog_Alert.exe", _read_ini())
		Case $MenuItem12
			ShellExecute("/bin/syslog_Critical.exe", _read_ini())
		Case $MenuItem11
			ShellExecute("/bin/syslog_Error.exe", _read_ini())
		Case $MenuItem10
			ShellExecute("/bin/syslog_war.exe", _read_ini())
		Case $Button1
			_GUICtrlButton_Enable($pageup, True)
			_GUICtrlButton_Enable($pagedown, True)
			GUICtrlSetState($dev_log, $GUI_ENABLE)
			GUICtrlSetState($ip_addr, $GUI_ENABLE)
			;$str_ip=_GUICtrlIpAddress_Get($IPAddress1)
			$str_date1 = GUICtrlRead($Date1)
			$str_date2 = GUICtrlRead($Date2)
			$str_text = GUICtrlRead($Input1)

			;$str_device=GUICtrlRead($Input2)
			If _DateDiff('s', $str_date1, $str_date2) < 0 Then
				MsgBox(0, "", "��ʼ���ڴ��ڽ�����������������")
				ContinueLoop
			EndIf
			$str_date1 = $str_date1 & " 00:00:00"
			$str_date2 = $str_date2 & " 23:59:59"
			If Not StringLen($str_text) Then
				$String = "select * from syslog where received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
				first($String)
			Else
				$String = "select * from syslog where message like '%" & $str_text & "%' and received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
				;MsgBox(0,"",$string)
				first($String)
			EndIf
			_ReduceMemory(@AutoItPID)
		Case $dev_log
			;MsgBox(0,"","ddd")
			;_GUICtrlListView_GetItemTextString($ListView1, Number(_GUICtrlListView_GetSelectedIndices($ListView1)))
			$array = _GUICtrlListView_GetItemTextArray($listview, Number(_GUICtrlListView_GetSelectedIndices($listview)))
			;MsgBox(0,"",$array[2])
			$String = "select * from syslog where origin like '%" & $array[2] & "%' and received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
			;MsgBox(0,"",_GUICtrlListView_GetItem($listview,Number(_GUICtrlListView_GetSelectedIndices($ListView))),0)
			first($String)

		Case $ip_addr
			$array = _GUICtrlListView_GetItemTextArray($listview, Number(_GUICtrlListView_GetSelectedIndices($listview)))

			$String = "select * from syslog where source_ip like '%" & $array[3] & "%' and received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
			first($String)
		Case $servity
			$array = _GUICtrlListView_GetItemTextArray($listview, Number(_GUICtrlListView_GetSelectedIndices($listview)))
			$String = "select * from syslog where severity like '%" & $array[5] & "%' and received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
			first($String)
		Case $ip_ser
			$array = _GUICtrlListView_GetItemTextArray($listview, Number(_GUICtrlListView_GetSelectedIndices($listview)))
			$String = "select * from syslog where source_ip like '%" & $array[3] & "' and severity like '%" & $array[5] & "%' and received between '" & $str_date1 & "' and '" & $str_date2 & "' order by received desc "
			first($String)
			;MsgBox(0,"",$array[3])
		Case $pageup
			pageup($String)
			_ReduceMemory(@AutoItPID)
		Case $pagedown
			pagedown($String)
			_ReduceMemory(@AutoItPID)
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func first($String)
	_GUICtrlListView_DeleteAllItems($listview)
	$str = _read_ini()
	;$string="SELECT * FROM syslog "
	$data = sql_query($str, $String, 1)
	addlist($listview, $data)
EndFunc   ;==>first

Func pageup($String)
	_GUICtrlListView_DeleteAllItems($listview)
	$str = _read_ini()
	;$string="SELECT * FROM syslog "
	If $page_num <= 1 Then
		;MsgBox(0,"","�Ѿ��ǵ�һҳ")
		_GUICtrlButton_Enable($pageup, False)
		first($String)
		Return
	Else
		$page_num -= 1
		$data = sql_query($str, $String, $page_num)
		_GUICtrlButton_Enable($pagedown, True)
		addlist($listview, $data)
	EndIf
EndFunc   ;==>pageup

Func pagedown($String)
	_GUICtrlListView_DeleteAllItems($listview)
	$str = _read_ini()
	;$string="SELECT * FROM syslog "
	$page_num += 1
	$data = sql_query($str, $String, $page_num)
	If UBound($data) > 1 Then
		_GUICtrlButton_Enable($pageup, True)
		addlist($listview, $data)
	Else
		_GUICtrlButton_Enable($pagedown, False)
	EndIf
EndFunc   ;==>pagedown