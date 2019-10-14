C_LONGINT:C283($Lon_size)
C_TEXT:C284($Txt_buffer)

$Txt_buffer:=Get edited text:C655
GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"size";$Lon_size)

If ($Lon_size>0) & (Length:C16($Txt_buffer)>$Lon_size)
	
	BEEP:C151
	ALERT:C41(Get localized string:C991("alphaSize")+String:C10($Lon_size))
	
Else 
	
	buildApp_SET_ELEMENT ($Txt_buffer)
	
End if 