//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : DELETE_MAC_CONTENT
  // Created 11/06/08 by vdl
  // ----------------------------------------------------
  // Description
  // Deleting invisible files like the Icon files, the temporary documents created by 4D
  // for all the file on $1 folder path and all folder included
  // ----------------------------------------------------
  // 12-9-2019 - vdl
  // v18 - Code rewriting
  // ----------------------------------------------------
C_TEXT:C284($1)

C_TEXT:C284($t)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(DELETE_MAC_CONTENT ;$1)
End if 

If (Count parameters:C259=0)
	
	$t:=Select folder:C670
	
	If (OK=1)
		
		DELETE_MAC_CONTENT ($t)
		
	End if 
	
Else 
	
	$o:=Folder:C1567($1;fk platform path:K87:2)
	
	If ($o.exists)
		
		$c:=$o.files(fk recursive:K87:7).query("name = '.@'")
		
		For each ($oo;$c)
			
			$oo.delete()
			
		End for each 
		
		$c:=$o.folders(fk recursive:K87:7).query("name = 'tempo'")
		
		For each ($oo;$c)
			
			$oo.delete(Delete with contents:K24:24)
			
		End for each 
	End if 
End if 