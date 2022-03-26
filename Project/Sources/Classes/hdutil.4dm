Class extends lep

// === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($target : 4D:C1709.File; $content)
	
	Super:C1705()
	
	This:C1470.target:=$target
	This:C1470.content:=Null:C1517
	This:C1470.disk:=Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function create($content) : Boolean
	
	// TODO: Allow collection & pathname
	This:C1470.content:=$content
	
	If ((This:C1470.target#Null:C1517) && This:C1470.target.exists)
		
		This:C1470.target.delete()
		
	End if 
	
	This:C1470.launch("hdiutil create -format UDBZ -plist -srcfolder "+This:C1470.quoted(This:C1470.content.path)+" "+This:C1470.quoted(This:C1470.target.path))
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function attach() : Boolean
	
	If (This:C1470._target())
		
		This:C1470.launch("hdiutil attach "+This:C1470.quoted(This:C1470.target.path))
		
		If (This:C1470.success)
			
			var $pos; $len : Integer
			This:C1470.success:=Match regex:C1019("(?i-ms)\\t+(/\\H*)*$"; This:C1470.outputStream; 1; $pos; $len)
			
			If (This:C1470.success)
				
				This:C1470.disk:=Folder:C1567(Substring:C12(This:C1470.outputStream; $pos+1; $len))
				This:C1470.success:=This:C1470.disk.exists
				
			Else 
				
				This:C1470._pushError("hdiutil attach "+This:C1470.quoted(This:C1470.target.path)+": failed")
				
			End if 
		End if 
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function detach() : Boolean
	
	If (This:C1470._disk())
		
		This:C1470.launch("hdiutil detach "+This:C1470.disk.path)
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _target() : Boolean
	
	This:C1470.success:=(This:C1470.target#Null:C1517) && This:C1470.target.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid target "+This:C1470.target ? "" : This:C1470.target.path)
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _disk() : Boolean
	
	This:C1470.success:=(This:C1470.disk#Null:C1517) && This:C1470.disk.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid disk "+This:C1470.disk ? "" : This:C1470.disk.path)
		
	End if 
	
	return (This:C1470.success)