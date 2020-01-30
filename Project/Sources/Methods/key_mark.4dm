//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : key_mark
  // Database: 4DPop AppMaker
  // ID[E65F03A808754451B46F0F33F8E0612E]
  // Created #10-7-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($1)
C_LONGINT:C283($2)
C_PICTURE:C286($3)

C_BOOLEAN:C305($Boo_marked)
C_LONGINT:C283($Lon_parameters;$Lon_reference)
C_PICTURE:C286($Pic_buffer)

If (False:C215)
	C_BOOLEAN:C305(key_mark ;$1)
	C_LONGINT:C283(key_mark ;$2)
	C_PICTURE:C286(key_mark ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	$Lon_reference:=Selected list items:C379(Form:C1466.buildApp;*)
	
	If ($Lon_parameters>=1)
		
		$Boo_marked:=$1
		
		If ($Lon_parameters>=2)
			
			$Lon_reference:=$2
			
			If ($Lon_parameters>=3)
				
				$Pic_buffer:=$3
				
			End if 
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Boo_marked)
	
	If (Picture size:C356($Pic_buffer)=0)
		
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"xml_mark.png";$Pic_buffer)
		
	End if 
	
Else 
	
	CREATE THUMBNAIL:C679($Pic_buffer;$Pic_buffer;8;8)
	
End if 

SET LIST ITEM ICON:C950(Form:C1466.buildApp;$Lon_reference;$Pic_buffer)

  // ----------------------------------------------------
  // End 