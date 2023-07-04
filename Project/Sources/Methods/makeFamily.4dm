//%attributes = {}
//#DECLARE($target : 4D.Folder) : 4D.Folder

//If (False)
//C_OBJECT(makeFamily; $1)
//C_OBJECT(makeFamily; $0)
//End if 

//var $pathname : Text
//var $progress : Integer
//var $component; $make : Object
//var $makeFile : 4D.File
//var $family; $src; $tgt : 4D.Folder

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

//$src:=$target.folder($component.name).folder("Build/Components").folder($component.name+".4dbase")

//If ($src.exists)

//$tgt:=$src.copyTo($family)

//If ($tgt.folder("_gsdata_").exists)

//$tgt.folder("_gsdata_").delete(fk recursive)

//End if 
//End if 
//End for each 

//Progress QUIT($progress)

//return $family

//End if 
//End if 