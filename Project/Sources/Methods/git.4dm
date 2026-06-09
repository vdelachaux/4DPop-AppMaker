//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : git
// Database: 4D Mobile Express
// Created #28-6-2017 by Eric Marchand
// ----------------------------------------------------
#DECLARE($git : Object) : Object

var $errorStream; $inputStream; $outputStream : Text

If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
	
	var $result:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

Case of 
		
		//__________________________________________________________
	: ($git=Null:C1517)
		
		$result.error:="$1 must be an object"
		
		//__________________________________________________________
	: ($git.action=Null:C1517)
		
		$result.error:="Missing property 'action'"
		
		//__________________________________________________________
	: ($git.action="--version")
		
		var $cmd : Text:="git "+$git.action
		
		LAUNCH EXTERNAL PROCESS:C811($cmd; $inputStream; $outputStream; $errorStream)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$cmd))
			
			If (Length:C16($errorStream)=0)
				
				$result.success:=True:C214
				$result.value:=$outputStream
				
			Else 
				
				$result.error:=$errorStream
				
			End if 
		End if 
		
		//__________________________________________________________
	: ($git.action="--commit")
		
		$git.action:="status"
		$result:=git($git)
		
		If ($result.success)
			
			$git.action:="init"
			$result:=git($git)
			
			If ($result.success)
				
				If (Position:C15("No commits yet"; $result.value)#0)
					
					// First commit
					$git.comment:="initial"
					
				End if 
				
				// Add all files
				$git.action:="add --all"
				$result:=git($git)
				
				If ($result.success)
					
					// Finally commit
					$git.action:="commit -m '"+$git.comment+"'"
					$result:=git($git)
					
				End if 
			End if 
		End if 
		
		//__________________________________________________________
	Else 
		
		If (($git.path=Null:C1517)\
			 & ($git.posix=Null:C1517))
			
			$result.error:="Missing property 'path' or 'posix'"
			
		Else 
			
			If ($git.posix=Null:C1517)
				
				$git.posix:=Convert path system to POSIX:C1106($git.path)
				
			End if 
			
			$cmd:="git -C '"+$git.posix+"' "+$git.action
			
		End if 
		
		If (Length:C16($cmd)>0)
			
			LAUNCH EXTERNAL PROCESS:C811($cmd; $inputStream; $outputStream; $errorStream)
			
			If (Asserted:C1132(OK=1; "LEP failed: "+$cmd))
				
				If (Length:C16($errorStream)=0)
					
					$result.success:=True:C214
					$result.results:=Split string:C1554($outputStream; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
				Else 
					
					$result.errors:=Split string:C1554($errorStream; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
				End if 
			End if 
		End if 
		
		//__________________________________________________________
End case 

return $result