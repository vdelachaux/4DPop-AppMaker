//%attributes = {}
#DECLARE($component : Object; $commitMessage : Text) : Boolean

If (False:C215)
	C_OBJECT:C1216(gitCommit; $1)
	C_TEXT:C284(gitCommit; $2)
	C_BOOLEAN:C305(gitCommit; $0)
End if 

var $err; $in; $out : Text

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $component.folder)
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811("git add --all"; $in; $out; $err)

If (Length:C16($out+$err)>0)
	
	ALERT:C41(Current method name:C684+": Error git add: "+$out+" "+$err)
	return 
	
Else 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $component.folder)
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811("git commit -a -q -m "+Char:C90(34)+$commitMessage+Char:C90(34); $in; $out; $err)
	
	If (Length:C16($out+$err)>0)
		
		ALERT:C41(Current method name:C684+": Error git commit: "+$out+" "+$err)
		return 
		
	Else 
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $component.folder)
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		LAUNCH EXTERNAL PROCESS:C811("git push"; $in; $out; $err)
		
		If (Length:C16($out+$err)>0)
			
			ALERT:C41(Current method name:C684+": Error git push: "+$out+" "+$err)
			return 
			
		End if 
		
		return True:C214
		
	End if 
End if 