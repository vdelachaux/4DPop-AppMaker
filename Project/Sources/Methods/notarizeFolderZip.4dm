//%attributes = {}
var $cmd; $pathname : Text
var $credentials : Object
var $target; $zip : 4D:C1709.File
var $src : 4D:C1709.Folder
var $lep : cs:C1710.lep
var $notarytool : cs:C1710.notarytool

$pathname:=Select document:C905(8858; ".4dbase"; "Select a component to notarize"; Package selection:K24:9)

If (Bool:C1537(OK))
	
	$credentials:=JSON Parse:C1218(Folder:C1567(fk user preferences folder:K87:10).file("notarise.json").getText())  // General file
	
	$src:=Folder:C1567(DOCUMENT; fk platform path:K87:2)
	$zip:=File:C1566(Delete string:C232($src.path; Length:C16($src.path); 1)+".zip")
	$zip.delete()
	
	$lep:=cs:C1710.lep.new()
	
	$cmd:="ditto -c -k --keepParent "+Char:C90(34)+$src.path+Char:C90(34)
	$cmd+=" "+Char:C90(34)+$zip.path+Char:C90(34)
	$lep.launch($cmd)
	
	If ($lep.success)
		
		$notarytool:=cs:C1710.notarytool.new($zip; $credentials.keychainProfile)
		
		If ($notarytool.submit())
			
			$target:=$src.file("Libraries/lib4d-arm64.dylib")
			
			If ($notarytool.staple($target))
				
				If ($notarytool.checkWithGatekeeper($src.path))  //; $credentials.certificate))
					
					//If ($notarytool.checkWithGatekeeper($target.path))  //; $credentials.certificate))
					
					ALERT:C41("Successful notarization")
					return 
					
				End if 
				
				ALERT:C41("checkWithGatekeeper failed")
				return 
				
			End if 
			
			ALERT:C41("staple failed")
			return 
			
		End if 
		
		ALERT:C41("submit failed:\r\r"+JSON Stringify:C1217($notarytool.outputStream))
		return 
		
	End if 
	
Else 
	
	// Cancelled
	
End if 