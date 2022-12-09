//%attributes = {}
var $pathname : Text
$pathname:=Select folder:C670("select a folder"; 8858)

If (Bool:C1537(OK))
	
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567($pathname; fk platform path:K87:2)
	
	var $dmg : 4D:C1709.File
	$dmg:=File:C1566(Delete string:C232($folder.path; Length:C16($folder.path); 1)+".dmg")
	
	var $hdutil : cs:C1710.hdutil
	$hdutil:=cs:C1710.hdutil.new($dmg)
	
	If ($hdutil.create($folder))
		
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
					
					If ($notarytool.ckeckWithGatekeeper($dmg; $credentials.certificate))
						
						ALERT:C41("Successful notarization")
						return 
						
					End if 
					
					ALERT:C41("ckeckWithGatekeeper failed")
					return 
					
				End if 
				
				ALERT:C41("staple failed")
				return 
				
			End if 
			
			ALERT:C41("submit failed:\r\r"+JSON Stringify:C1217($notarytool.outputStream))
			return 
			
		End if 
		
		ALERT:C41("sign failed")
		return 
		
	End if 
End if 

