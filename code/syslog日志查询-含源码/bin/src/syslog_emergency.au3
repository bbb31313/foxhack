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
#Include <GuiDateTimePicker.au3>
#include <GuiButton.au3>


Global $page_num,$cmd_par


If $CmdLine[0]<1 Then
	MsgBox(0,"运行错误","请在主程序中调用！！！！！！！")
	Exit
Else
	$cmd_par=$CmdLine[1]
EndIf


#Region ### START Koda GUI section ### Form=C:\Documents and Settings\hehao\My Documents\cinda\Form2dddd.kxf
$Form2 = GUICreate("SYSLOG-EMERGENCY-记录查询 BY:foxhack E-mail:foxhack@qq.com QQ:278563291", 1090, 700, 100, 10)
$MenuItem3 = GUICtrlCreateMenu("文件")
$MenuItem15 = GUICtrlCreateMenuItem("退出", $MenuItem3)
$Label1 = GUICtrlCreateLabel("开始时间", 592, 8, 52, 17)

$Date1 = GUICtrlCreateDate("", 648, 8, 121, 18)
$hDTP1 = GUICtrlGetHandle($date1)
 _GUICtrlDTP_SetFormat($hDTP1, "yyyy-MM-dd")

$Label2 = GUICtrlCreateLabel("结束时间", 776, 8, 52, 17)
$Date2 = GUICtrlCreateDate("", 832, 8, 113, 18)
$hDTP2 = GUICtrlGetHandle($date2)
 _GUICtrlDTP_SetFormat($hDTP2, "yyyy-MM-dd")


$Button1 = GUICtrlCreateButton("查询", 976, 8, 97, 18, $BS_CENTER)

$Input1 = GUICtrlCreateInput("", 416, 8, 169, 18)
$Label3 = GUICtrlCreateLabel("过滤条件", 360, 8, 52, 17, $SS_CENTERIMAGE)

$pageup = GUICtrlCreateButton("上一页", 424, 32, 81, 18)
$pagedown = GUICtrlCreateButton("下一页", 520, 32, 81, 18)


$ListView = _GUICtrlListView_Create($Form2, "", 2, 50, 1090, 630, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $LVS_EX_GRIDLINES)
_GUICtrlListView_SetExtendedListViewStyle($ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_AddColumn($ListView, "接收时间", 125)
_GUICtrlListView_AddColumn($ListView, "设备名", 100)
_GUICtrlListView_AddColumn($ListView, "来源IP", 80)
_GUICtrlListView_AddColumn($ListView, "模块", 80)
_GUICtrlListView_AddColumn($ListView, "告警级别", 80)
_GUICtrlListView_AddColumn($ListView, "告警信息", 600)



GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
_GUICtrlButton_Enable($pageup, False)
_GUICtrlButton_Enable($pagedown, False)
_ReduceMemory(@AutoItPID)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $MenuItem15 
			Exit
		Case $Button1
			_GUICtrlButton_Enable($pageup, True)
			_GUICtrlButton_Enable($pagedown, True)
	
			$str_date1=GUICtrlRead($Date1)
			$str_date2=GUICtrlRead($date2)
			$str_text=GUICtrlRead($Input1)
		
			If _DateDiff('s',$str_date1,$str_date2) < 0 Then 
				MsgBox(0,"","开始日期大于结束日期请重新输入")
				ContinueLoop 
			EndIf
			$str_date1=$str_date1&" 00:00:00"
			$str_date2=$str_date2&" 23:59:59"
			If  Not StringLen($str_text)  Then
				$String="select * from emergency where received between '"&$str_date1&"' and '"&$str_date2&"' order by received desc "
				first($string)
			Else
				$string="select * from emergency where message like '%"&$str_text&"%' and received between '"&$str_date1&"' and '"&$str_date2&"' order by received desc "
				;MsgBox(0,"",$string)
				first($string)
			EndIf
			_ReduceMemory(@AutoItPID)
		Case $pageup
			pageup($string)
			_ReduceMemory(@AutoItPID)
		Case $pagedown
			pagedown($string)
			_ReduceMemory(@AutoItPID)
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func first($String) 
	_GUICtrlListView_DeleteAllItems($ListView)
	$str=$cmd_par
	$data=sql_query($str,$string,1)
	addlist($listview,$data)
EndFunc

Func pageup($string)
	_GUICtrlListView_DeleteAllItems($ListView)
	$str=$cmd_par
	If $page_num <=1 Then

			_GUICtrlButton_Enable($pageup, False)
			first($string)
			Return
	Else
		$page_num-=1
		$data=sql_query($str,$string,$page_num)
		_GUICtrlButton_Enable($pagedown, True)
		addlist($listview,$data)
	EndIf
EndFunc

Func pagedown($String)
	_GUICtrlListView_DeleteAllItems($ListView)
	$str=$cmd_par

	$page_num+=1
	$data=sql_query($str,$string,$page_num)
	If UBound($data) >1 Then
		_GUICtrlButton_Enable($pageup, True)
		addlist($listview,$data)
	Else
		_GUICtrlButton_Enable($pagedown, False)
    EndIf
EndFunc