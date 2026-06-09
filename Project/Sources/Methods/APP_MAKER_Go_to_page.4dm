//%attributes = {"invisible":true}
var $1 : Integer
var $2 : Integer

var $Lon_bottom; $Lon_left; $Lon_page; $Lon_right; $Lon_top : Integer

$Lon_page:=$1

If (FORM Get current page:C276#$Lon_page)\
 | ($Lon_page<0)
	
	$Lon_page:=Abs:C99($Lon_page)
	
	OBJECT GET COORDINATES:C663(*; "page."+String:C10($Lon_page); $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	OBJECT MOVE:C664(*; "page.selected"; $Lon_left-2; $Lon_top-2; $Lon_right+2; $Lon_bottom+2; *)
	
	FORM GOTO PAGE:C247($Lon_page)
	
	If (Count parameters:C259>=2)
		
		SET TIMER:C645($2)
		
	Else 
		
		Form:C1466.refresh()
		
	End if 
End if 