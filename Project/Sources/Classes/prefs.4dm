Class constructor($file : 4D:C1709.File; $rootElement : Text)
	
	var $content; $root : Text
	
	This:C1470.file:=$file
	This:C1470.rootElement:=$rootElement
	
	If (This:C1470.file.exists)
		
		$content:=This:C1470.file.getText()
		
	Else 
		
		$root:=DOM Create XML Ref:C861(This:C1470.rootElement)
		DOM EXPORT TO VAR:C863($root; $content)
		DOM CLOSE XML:C722($root)
		
	End if 
	
	This:C1470.content:=$content
	
	This:C1470.success:=True:C214
	
	// === === === === === === === === === === === === === === === === === === ===
Function load() : Object
	
	var $root : Text
	
	//If (This.reference#Null)
	
	//return True
	
	//End if 
	
	////$root:=DOM Parse XML variable(String(This.content)) //NOT COMPILABLE
	//var $t : Text
	//$t:=This.content
	//$root:=DOM Parse XML variable($t)
	//This.success:=Bool(OK)
	
	//If (This.success)
	
	//This.reference:=$root
	
	//End if 
	
	//return This.success
	
	var $xml : cs:C1710.xml
	$xml:=cs:C1710.xml.new(This:C1470.file)
	var $o : Object
	$o:=$xml.toObject()
	$xml.close()
	
	return $o
	
	
	// === === === === === === === === === === === === === === === === === === ===
Function save()
	
	var $content : Text
	
	If (This:C1470.load())
		
		DOM EXPORT TO VAR:C863(This:C1470.reference; $content)
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			This:C1470.file.setText($content)
			This:C1470.close()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function close()
	
	If (This:C1470.reference#Null:C1517)
		
		DOM CLOSE XML:C722(This:C1470.reference)
		This:C1470.reference:=Null:C1517
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function get($xpath : Text)
	
	If (This:C1470.load())
		
		
		
		
	End if 
	
	