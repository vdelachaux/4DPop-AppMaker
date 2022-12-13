//%attributes = {}
#DECLARE($target : 4D:C1709.Folder) : Boolean

If (False:C215)
	C_OBJECT:C1216(makeDMG; $1)
	C_BOOLEAN:C305(makeDMG; $0)
End if 

var $pathname : Text
var $credentials : Object
var $dmg; $file : 4D:C1709.File
var $codesign : cs:C1710.codesign
var $hdutil : cs:C1710.hdutil
var $notarytool : cs:C1710.notarytool

If (Count parameters:C259=0)
	
	$pathname:=Select folder:C670("select the component folder"; 8859)
	
	If (Bool:C1537(OK))
		
		$target:=Folder:C1567($pathname; fk platform path:K87:2)
		
	End if 
End if 

If ($target#Null:C1517 && $target.exists)
	
	$dmg:=File:C1566(Delete string:C232($target.path; Length:C16($target.path); 1)+".dmg")
	
	$hdutil:=cs:C1710.hdutil.new($dmg)
	
	If ($hdutil.create($target))
		
		$file:=Folder:C1567(fk user preferences folder:K87:10).file("notarise.json")  // General file
		
		$credentials:=JSON Parse:C1218($file.getText())
		
		$codesign:=cs:C1710.codesign.new($credentials)
		
		If ($codesign.sign($dmg))
			
			$notarytool:=cs:C1710.notarytool.new($credentials.keychainProfile)
			
			If ($notarytool.submit($dmg.path))
				
				If ($notarytool.staple($dmg))
					
					If ($notarytool.ckeckWithGatekeeper($dmg; $credentials.certificate))
						
						//ALERT("Successful notarization")
						return True:C214
						
					End if 
					
					ALERT:C41(Current method name:C684+": ckeckWithGatekeeper failed")
					return 
					
				End if 
				
				ALERT:C41(Current method name:C684+": staple failed")
				return 
				
			End if 
			
			ALERT:C41(Current method name:C684+": submit failed:\r\r"+JSON Stringify:C1217($notarytool.outputStream))
			return 
			
		End if 
		
		ALERT:C41(Current method name:C684+": sign failed")
		return 
		
	End if 
End if 