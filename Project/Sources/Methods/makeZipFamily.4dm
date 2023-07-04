//%attributes = {}
//#DECLARE($target : 4D.Folder) : 4D.Folder

//If (False)
//C_OBJECT(makeZipFamily; $1)
//C_OBJECT(makeZipFamily; $0)
//End if 

//var $pathname : Text
//var $progress : Integer
//var $component; $make : Object
//var $makeFile; $src; $tgt : 4D.File
//var $family : 4D.Folder

//If (False)
//End if 

//If (Count parameters=0)

//$pathname:=Select folder("select the component folder"; 8859)

//If (Bool(OK))

//$target:=Folder($pathname; fk platform path)

//End if 
//End if 

//If ($target#Null && $target.exists)

//$makeFile:=$target.file("make.json")

//If ($makeFile.exists)

//$progress:=Progress New

//$make:=JSON Parse($makeFile.getText())
//$family:=$target.folder("4DPop-Family-"+cs.motor.new().branch)

//Progress SET TITLE($progress; "Creating: "+$family.fullName+"…")

//If ($family.exists)

//$family.delete(fk recursive)

//End if 

//$family.create()

//For each ($component; $make.components)

//If (Bool($component.family))

//$src:=$target.folder($component.name).folder("Build/Components").files().query("extension = .zip").pop()

//If ($src#Null)

//$tgt:=$src.copyTo($family)

//End if 
//End if 
//End for each 

//Progress QUIT($progress)

//return $family

//End if 
//End if 