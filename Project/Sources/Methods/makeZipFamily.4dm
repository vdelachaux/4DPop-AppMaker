//%attributes = {}
#DECLARE($target : 4D:C1709.Folder) : 4D:C1709.Folder

If (False:C215)
	C_OBJECT:C1216(makeZipFamily; $1)
	C_OBJECT:C1216(makeZipFamily; $0)
End if 

var $pathname : Text
var $progress : Integer
var $component; $make : Object
var $makeFile; $src; $tgt : 4D:C1709.File
var $family : 4D:C1709.Folder

If (False:C215)
End if 

If (Count parameters:C259=0)
	
	$pathname:=Select folder:C670("select the component folder"; 8859)
	
	If (Bool:C1537(OK))
		
		$target:=Folder:C1567($pathname; fk platform path:K87:2)
		
	End if 
End if 

If ($target#Null:C1517 && $target.exists)
	
	$makeFile:=$target.file("make.json")
	
	If ($makeFile.exists)
		
		$progress:=Progress New
		
		$make:=JSON Parse:C1218($makeFile.getText())
		$family:=$target.folder("4DPop-Family-"+cs:C1710.motor.new().branch)
		
		Progress SET TITLE($progress; "Creating: "+$family.fullName+"…")
		
		If ($family.exists)
			
			$family.delete(fk recursive:K87:7)
			
		End if 
		
		$family.create()
		
		For each ($component; $make.components)
			
			If (Bool:C1537($component.family))
				
				$src:=$target.folder($component.name).folder("Build/Components").files().query("extension = .zip").pop()
				
				If ($src#Null:C1517)
					
					$tgt:=$src.copyTo($family)
					
				End if 
			End if 
		End for each 
		
		Progress QUIT($progress)
		
		return $family
		
	End if 
End if 