//%attributes = {}


var $name : Text
$name:=Select document:C905(8858; ".dmg"; "select a disk image"; 0)

If (Bool:C1537(OK))
	
	var $dmg : 4D:C1709.File
	$dmg:=File:C1566(DOCUMENT; fk platform path:K87:2)
	
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk user preferences folder:K87:10).file("notarise.json")  // General file
	
	var $credentials : Object
	$credentials:=JSON Parse:C1218($file.getText())
	
	var $codesign : cs:C1710.codesign
	$codesign:=cs:C1710.codesign.new($credentials)
	
	If ($codesign.sign($dmg))
		
		var $notarytool : cs:C1710.notarytool
		$notarytool:=cs:C1710.notarytool.new($credentials.keychainProfile)
		
		If ($notarytool.submit($dmg.path))
			
			If ($notarytool.staple($dmg))
				
				If ($notarytool.checkWithGatekeeper($dmg))  //; $credentials.certificate))
					
					ALERT:C41("Successful notarization")
					return 
					
				End if 
				
				ALERT:C41("checkWithGatekeeper failed")
				return 
				
			End if 
			
			ALERT:C41("staple failed")
			return 
			
		End if 
		
		ALERT:C41("submit failed\\r\\r"+JSON Stringify:C1217($notarytool.outputStream))
		return 
		
	End if 
	
	ALERT:C41("sign failed")
	return 
	
End if 