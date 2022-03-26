//%attributes = {}
var $build : cs:C1710.build
$build:=cs:C1710.build.new()

//$build.lib4d:=File("Macintosh HD:Users:vincentdelachaux:GITHUB:4DPop:4DPop AppMaker:Build:Components:4DPop AppMaker.4dbase:Libraries:lib4d-arm64.dylib"; fk platform path)
//$build.buildTarget:=$build.lib4d.parent.parent

//var $hdutil : cs.hdutil
//$hdutil:=cs.hdutil.new($build.buildTarget.parent.file($build.buildTarget.name+".dmg"))
////$hdutil.create($build.lib4d)

//If ($hdutil.create($build.lib4d))

//If ($hdutil.attach())

//var $file : 4D.File
//$file:=$hdutil.disk.file($build.lib4d.fullName).copyTo($build.lib4d.parent; fk overwrite)

//If ($file.exists)


//If ($hdutil.detach())

//$hdutil.target.delete()

//End if 
//End if 
//End if 
//End if 

//$build.dmg()

//$build.dmg("open")



//$build.dmg("close")


//$build.removeSignature()

//If ($build.success)

//$build.sign()

//If ($build.success)

//$build.dmg()

//If ($build.success)

//$build.notarize()

//If ($build.success)

////Use (Storage.progress)

////Storage.progress.barber:=-2
////Storage.progress.max:=$c.length*(Num($Boo_component)+Num($Boo_compiled)+Num($Boo_standalone)+Num($Boo_server))
////Storage.progress.title:="⏳ Waiting for Apple's response"

////End use 

//$build.waitForNotarizeResult()

//If ($build.success)

//$build.staple()

//If ($build.success)

//$t:=$build.ckeckWithGatekeeper()

//If ($build.success)

////$build.copy()

//DISPLAY NOTIFICATION($Obj_database.structure.name; "Successfully notarized for : "+$t)

//$build.archive.delete()

//End if 
//End if 
//End if 
//End if 
//End if 
//End if 
//End if 
