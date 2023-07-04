//%attributes = {}
//var $appName; $cmd; $commitMessage; $err; $in; $out : Text
//var $pathname : Text
//var $isMatrix; $success : Boolean
//var $progress : Integer
//var $component; $make : Object
//var $exe; $makeFile : 4D.File
//var $target : 4D.Folder

//If (Asserted(Is macOS))

//$appName:=Select document(8858; ".app"; "select the 4D Application to use"; 0)

//If (Bool(OK))

//$exe:=Folder(DOCUMENT; fk platform path).file("Contents/MacOS/4D")

//If ($exe.exists)

//// Get the the builder branch
//var $o : Object
//$o:=Folder(DOCUMENT; fk platform path).file("Contents/Info.plist").getAppInfo()

//ARRAY LONGINT($pos; 0x0000)
//ARRAY LONGINT($len; 0x0000)

//var $branch : Text
//If ($o.CFBundleShortVersionString="0.0@")

//$branch:="main"

//Else 

//$branch:=Match regex("(?mi-s)build\\s(.*)\\."; $o.CFBundleShortVersionString; 1; $pos; $len)\
 ? Substring($o.CFBundleShortVersionString; $pos{1}; $len{1})\
 : cs.motor.new().branch

//End if 

//$commitMessage:="Compilation "+$branch

//// Select the target folder
//$pathname:=Select folder("select the component folder"; 8859)

//If (Bool(OK))

//$isMatrix:=Structure file=Structure file(*)

//$progress:=Progress New

//If ($isMatrix)

//// Build me
//Progress SET TITLE($progress; "Build "+Folder(fk database folder).name+"…")
//4DPopAppMakerRun

//End if 

//$target:=Folder($pathname; fk platform path)

//$makeFile:=$target.file("make.json")

//If ($makeFile.exists)

//$make:=JSON Parse($makeFile.getText())

//For each ($component; $make.components)

//$component.folder:=$makeFile.parent.path+$component.name

//If ($isMatrix && ($component.name="4DPop AppMaker"))

//Progress SET TITLE($progress; "Git push "+$component.name+"…")
//gitCommit($component; $commitMessage)
//continue

//End if 

//Progress SET TITLE($progress; "Build "+$component.name+"…")

//$cmd:=Char(Quote)+$exe.path+Char(Quote)
//$cmd+=" --project "+Char(Quote)+$component.folder+"/Project/"+$component.name+".4DProject"+Char(Quote)
//$cmd+=" --opening-mode interpreted"
//$cmd+=" --user-param build"
//$cmd+=" --dataless"
////$cmd+=" --headless"

//LAUNCH EXTERNAL PROCESS($cmd; $in; $out; $err)

//// MARK:Git push
//Progress SET TITLE($progress; "Git push "+$component.name+"…")
//$success:=gitCommit($component; $commitMessage)

//If (Not($success))

//break

//End if 
//End for each 

//If ($success)

//// MARK:Copy to family folder
//Progress SET TITLE($progress; "Make Family folder…")

//var $family; $src; $tgt : 4D.Folder
//$family:=$target.folder("4DPop-Family-"+$branch)

//Progress SET TITLE($progress; "Creating: "+$family.fullName+"…")

//If ($family.exists)

//$family.delete(fk recursive)

//End if 

//$family.create()

//For each ($component; $make.components)

//$src:=$target.folder($component.name).folder("Build/Components").folder($component.name+".4dbase")

//If ($src.exists)

//$tgt:=$src.copyTo($family)

//End if 
//End for each 

//// MARK:Make dmg & push to github
//Progress SET TITLE($progress; "Make Family DMG…")

//$success:=makeDMG($family)

//If (Not($success))

//ALERT("makeDMG failed")

//End if 


//Else 

//ALERT("Faied to commit: "+$component.name)

//End if 

//Else 

//ALERT("Missing file: "+$makeFile.fullName)

//End if 

//Progress QUIT($progress)

//End if 

//End if 
//End if 

//Else 

//// TODO:On windows

//End if 