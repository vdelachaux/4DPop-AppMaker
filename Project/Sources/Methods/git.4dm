//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : git
  // Database: 4D Mobile Express
  // Created #28-6-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($Obj_git;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(git ;$0)
	C_OBJECT:C1216(git ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_git:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"True")
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

Case of 
		
		  //__________________________________________________________
	: ($Obj_git=Null:C1517)
		
		$Obj_out.error:="$1 must be an object"
		
		  //__________________________________________________________
	: ($Obj_git.action=Null:C1517)
		
		$Obj_out.error:="Missing property 'action'"
		
		  //__________________________________________________________
	: ($Obj_git.action="--version")
		
		$Txt_cmd:="git "+$Obj_git.action
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_out.success:=True:C214
				$Obj_out.value:=$Txt_out
				
			Else 
				
				$Obj_out.error:=$Txt_error
				
			End if 
		End if 
		
		  //__________________________________________________________
	: ($Obj_git.action="--commit")
		
		$Obj_git.action:="status"
		$Obj_out:=git ($Obj_git)
		
		If ($Obj_out.success)
			
			$Obj_git.action:="init"
			$Obj_out:=git ($Obj_git)
			
			If ($Obj_out.success)
				
				If (Position:C15("No commits yet";$Obj_out.value)#0)
					
					  // First commit
					$Obj_git.comment:="initial"
					
				End if 
				
				  // Add all files
				$Obj_git.action:="add --all"
				$Obj_out:=git ($Obj_git)
				
				If ($Obj_out.success)
					
					  // Finally commit
					$Obj_git.action:="commit -m '"+$Obj_git.comment+"'"
					$Obj_out:=git ($Obj_git)
					
				End if 
			End if 
		End if 
		
		  //__________________________________________________________
	Else 
		
		If (($Obj_git.path=Null:C1517)\
			 & ($Obj_git.posix=Null:C1517))
			
			$Obj_out.error:="Missing property 'path' or 'posix'"
			
		Else 
			
			If ($Obj_git.posix=Null:C1517)
				
				$Obj_git.posix:=Convert path system to POSIX:C1106($Obj_git.path)
				
			End if 
			
			$Txt_cmd:="git -C '"+$Obj_git.posix+"' "+$Obj_git.action
			
		End if 
		
		If (Length:C16($Txt_cmd)>0)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_out.success:=True:C214
					$Obj_out.results:=Split string:C1554($Txt_out;"\n";sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
				Else 
					
					$Obj_out.errors:=Split string:C1554($Txt_error;"\n";sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					
				End if 
			End if 
		End if 
		
		  //__________________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End