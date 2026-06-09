var $Lon_size : Integer
var $Txt_buffer : Text

$Txt_buffer:=Get edited text:C655
GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "size"; $Lon_size)

If ($Lon_size>0) & (Length:C16($Txt_buffer)>$Lon_size)
	
	BEEP:C151
	ALERT:C41(Localized string:C991("alphaSize")+String:C10($Lon_size))
	
Else 
	
	buildApp_SET_ELEMENT($Txt_buffer)
	
End if 