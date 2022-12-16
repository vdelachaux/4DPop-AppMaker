//%attributes = {}
#DECLARE($target : 4D:C1709.Folder) : 4D:C1709.Folder

If (False:C215)
	C_OBJECT:C1216(makeFamily; $1)
	C_OBJECT:C1216(makeFamily; $0)
End if 

var $pathname : Text
var $progress : Integer
var $component; $make : Object
var $makeFile : 4D:C1709.File
var $family; $src; $tgt : 4D:C1709.Folder

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
		$family:=$target.folder("4DPop Family "+cs:C1710.motor.new().branch)
		
		Progress SET TITLE($progress; "Creating: "+$family.fullName+"…")
		
		If ($family.exists)
			
			$family.delete(fk recursive:K87:7)
			
		End if 
		
		$family.create()
		
		For each ($component; $make.components)
			
			$src:=$target.folder($component.name).folder("Build/Components").folder($component.name+".4dbase")
			
			If ($src.exists)
				
				$tgt:=$src.copyTo($family)
				
				If ($tgt.folder("_gsdata_").exists)
					
					$tgt.folder("_gsdata_").delete(fk recursive:K87:7)
					
				End if 
			End if 
		End for each 
		
		Progress QUIT($progress)
		
		return $family
		
	End if 
End if 