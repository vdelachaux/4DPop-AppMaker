//%attributes = {}
//#DECLARE($target : 4D.Folder) : Boolean

//If (False)
//C_OBJECT(makeDMG; $1)
//C_BOOLEAN(makeDMG; $0)
//End if 

//var $pathname : Text
//var $progress : Integer
//var $credentials : Object
//var $dmg; $file : 4D.File
//var $codesign : cs.codesign
//var $hdutil : cs.hdutil
//var $notarytool : cs.notarytool

//If (Count parameters=0)

//$pathname:=Select folder("select the component folder"; 8859)

//If (Bool(OK))

//$target:=Folder($pathname; fk platform path)

//End if 
//End if 

//If ($target#Null && $target.exists)

//$progress:=Progress New

//$dmg:=File($target.parent.path+$target.name+".dmg")

//Progress SET TITLE($progress; "Creating: "+$dmg.fullName+"…")

//$hdutil:=cs.hdutil.new($dmg)

//If ($hdutil.create($target))

//Progress SET TITLE($progress; "Signing: "+$dmg.fullName+"…")

//$file:=Folder(fk user preferences folder).file("notarise.json")  // General file

//$credentials:=JSON Parse($file.getText())

//$codesign:=cs.codesign.new($credentials)

//If ($codesign.sign($dmg))

//Progress SET TITLE($progress; "Notarize: "+$dmg.fullName+"…")

//$notarytool:=cs.notarytool.new($hdutil.target; $credentials.keychainProfile)

//If ($notarytool.submit())

//If ($notarytool.staple())

//If ($notarytool.checkWithGatekeeper($dmg))

//Progress QUIT($progress)
//return True

//End if 

//ALERT(Current method name+": checkWithGatekeeper failed")
//Progress QUIT($progress)
//return 

//End if 

//ALERT(Current method name+": staple failed")
//Progress QUIT($progress)
//return 

//End if 

//ALERT(Current method name+": submit failed:\r\r"+JSON Stringify($notarytool.outputStream))
//Progress QUIT($progress)
//return 

//End if 

//ALERT(Current method name+": sign failed")
//Progress QUIT($progress)
//return 

//End if 

//ALERT(Current method name+": cretae dmg failed")
//Progress QUIT($progress)
//return 

//End if 