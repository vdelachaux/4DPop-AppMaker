Class constructor($app : Object)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is macOS:C1572)
			
			Case of 
					
					//======================================
				: (OB Instance of:C1731($app; 4D:C1709.Folder))
					
					If ($app.isPackage)
						
						If ($app.exists)
							
							This:C1470.app:=$app
							This:C1470.executableFile:=This:C1470._getBundleExecutable()
							
						End if 
					End if 
					
					//======================================
				: (OB Instance of:C1731($app; 4D:C1709.File))
					
					If ($app.exists)
						
						This:C1470.executableFile:=$app
						
					End if 
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is Windows:C1573)
			
			Case of 
					
					//======================================
				: (OB Instance of:C1731($app; 4D:C1709.File))
					
					If ($app.exists)
						
						This:C1470.executableFile:=$app
						
					End if 
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
Function _getBundleExecutable()->$executableFile : 4D:C1709.File
	
	If (This:C1470.app#Null:C1517)
		
		var $plistFile : 4D:C1709.File
		
		$plistFile:=This:C1470.app.folder("Contents").file("Info.plist")
		
		If ($plistFile.exists)
			
			ON ERR CALL:C155("ON_PARSE_ERROR")
			var $dom; $domKey : Text
			$dom:=DOM Parse XML source:C719($plistFile.platformPath)
			ON ERR CALL:C155("")
			
			If (OK=1)
				
				$domKey:=DOM Find XML element:C864($dom; "//key[text()='CFBundleExecutable']")
				
				If (OK=1)
					
					var $stringValue : Text
					DOM GET XML ELEMENT VALUE:C731(DOM Get next sibling XML element:C724($domKey); $stringValue)
					$executableFile:=This:C1470.app.folder("Contents").folder("MacOS").file($stringValue)
					
				End if 
			End if 
		End if 
	End if 
	
Function open($params : Collection)->$status : Object
	
	If ($params=Null:C1517)
		
		var $params : Collection
		$params:=New collection:C1472
		
	End if 
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is macOS:C1572)
			
			$params.unshift(_tempo_escape_param(This:C1470.executableFile.path))
			var $command : Text
			$command:=$params.join(" ")  // Callee should escape params
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is Windows:C1573)
			
			$params:=New collection:C1472(_tempo_escape_param($params.join(" ")))
			$params.unshift(_tempo_escape_param(This:C1470.executableFile.path))
			
			Case of 
					
					//======================================
				: (This:C1470.executableFile.extension=".bat")
					
					$params.unshift("cmd.exe /C start /B")
					
					//======================================
				: (This:C1470.executableFile.extension=".exe")
					
					$params.unshift("cmd.exe /C start \"\"")
					
					//======================================
				Else 
					
					$params.unshift("cmd.exe /C")
					
					//======================================
			End case 
			
			$command:=$params.join(" ")  // Callee should not escape params
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	C_BLOB:C604($stdIn; $stdOut; $stdErr)
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "TRUE")
	
	If (Is Windows:C1573)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		
	End if 
	
	LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr)
	
	$status:=New object:C1471
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is macOS:C1572)
			
			var $encoding; $EOL : Text
			$encoding:="utf-8"
			$EOL:="\n"
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is Windows:C1573)
			
			$encoding:="utf-16le"
			$EOL:="\r\n"  // Not necessarily true
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	$status.stdOut:=Split string:C1554(Convert to text:C1012($stdOut; $encoding); $EOL)
	$status.stdErr:=Split string:C1554(Convert to text:C1012($stdErr; $encoding); $EOL)
	
Function encodeObject($object : Object)->$encodedObject : Text
	
	If ($object#Null:C1517)
		
		var $json : Text
		$json:=JSON Stringify:C1217($object)
		
		var $data : Blob
		CONVERT FROM TEXT:C1011($json; "utf-8"; $data)
		
		BASE64 ENCODE:C895($data; $encodedObject)
		
	End if 