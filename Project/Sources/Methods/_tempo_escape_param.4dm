//%attributes = {}
#DECLARE($text : Text) : Text

var $char : Text

For each ($char; Split string:C1554("\\!\"#$%&'()=~|<>?;*`[] "; ""))
	
	$text:=Replace string:C233($text; $char; "\\"+$char; *)
	
End for each 

return $text