//%attributes = {}
var $component; $pathname : Text
var $make : Object
var $makeFile : 4D:C1709.File
var $family; $target; $src : 4D:C1709.Folder
var $motor : cs:C1710.motor

$pathname:=Select folder:C670("select the component folder"; 8859)

If (Bool:C1537(OK))
	
	$target:=Folder:C1567($pathname; fk platform path:K87:2)
	$makeFile:=$target.file("make.json")
	
	If ($makeFile.exists)
		
		$make:=JSON Parse:C1218($makeFile.getText())
		$family:=$target.folder("4DPop-Family-"+cs:C1710.motor.new().branch)
		
		If ($family.exists)
			
			$family.delete(fk recursive:K87:7)
			
		End if 
		
		$family.create()
		
		For each ($component; $make.family)
			
			If (Bool:C1537($make.family[$component]))
				
				$src:=$target.folder($component).folder("Build/Components").folder($component+".4dbase")
				
				If ($src.exists)
					
					var $tgt : 4D:C1709.Folder
					$tgt:=$src.copyTo($family)
					
					If ($tgt.folder("_gsdata_").exists)
						
						$tgt.folder("_gsdata_").delete(fk recursive:K87:7)
						
					End if 
				End if 
			End if 
		End for each 
	End if 
End if 

