//%attributes = {"invisible":true}
C_TEXT:C284($1)

C_LONGINT:C283($Lon_bottom; $Lon_left; $Lon_right; $Lon_top; $Win_hdl)

If (False:C215)
	C_TEXT:C284(BARBER; $1)
End if 

Case of 
		
		//_____________________________
	: ($1="barber.open")
		
		$Win_hdl:=Open form window:C675("Barber"; Controller form window:K39:17+Form has no menu bar:K39:18; Horizontally centered:K39:1; Vertically centered:K39:4; *)
		
		DIALOG:C40("Barber")
		
		//_____________________________
	: ($1="barber.close")
		
		Use (Storage:C1525.progress)
			
			Storage:C1525.progress.barber:=-1
			
		End use 
		
		//_____________________________
	Else 
		
		TRACE:C157
		
		//_____________________________
End case 