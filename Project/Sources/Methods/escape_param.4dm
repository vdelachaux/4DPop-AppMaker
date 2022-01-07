//%attributes = {"invisible":true,"preemptive":"capable"}
var $0 : Text
var $1 : Text

If (False:C215)
	C_TEXT:C284(escape_param; $0)
	C_TEXT:C284(escape_param; $1)
End if 

var $metacharacter; $metacharacters; $param : Text
var $shoudQuote : Boolean
var $i; $len : Integer

If (Count parameters:C259#0)
	
	$param:=$1
	
	Case of 
		: (Is macOS:C1572)
			$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
			For ($i; 1; Length:C16($metacharacters))
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$param:=Replace string:C233($param; $metacharacter; "\\"+$metacharacter; *)
			End for 
			
		: (Is Windows:C1573)
			
			$shoudQuote:=False:C215
			
			$metacharacters:="&|<>()%^\" "
			
			$len:=Length:C16($metacharacters)
			
			For ($i; 1; $len)
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$shoudQuote:=$shoudQuote | (Position:C15($metacharacter; $param; *)#0)
				If ($shoudQuote)
					$i:=$len
				End if 
			End for 
			
			If ($shoudQuote)
				If (Substring:C12($param; Length:C16($param))="\\")
					$param:="\""+$param+"\\\""
				Else 
					$param:="\""+$param+"\""
				End if 
			End if 
	End case 
End if 

$0:=$param