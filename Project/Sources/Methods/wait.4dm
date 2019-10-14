//%attributes = {"invisible":true}
C_BOOLEAN:C305($0)
C_LONGINT:C283($1)
C_LONGINT:C283($2)
C_LONGINT:C283($3)
C_LONGINT:C283($4)

If (False:C215)
	C_BOOLEAN:C305(wait ;$0)
	C_LONGINT:C283(wait ;$1)
	C_LONGINT:C283(wait ;$2)
	C_LONGINT:C283(wait ;$3)
	C_LONGINT:C283(wait ;$4)
End if 

If (OK=1)
	
	While ((Milliseconds:C459-$1)<$2)
		DELAY PROCESS:C323($3;$4)
	End while 
	
End if 

$0:=True:C214