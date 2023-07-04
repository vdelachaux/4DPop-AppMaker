property disk : 4D:C1709.Folder

Class extends lep

// === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($target : 4D:C1709.File; $content)
	
	Super:C1705()
	
	This:C1470.target:=$target
	This:C1470.content:=Null:C1517
	This:C1470.disk:=Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function create($content) : Boolean
	
	// TODO: Allow collection & more (File, Folder,…)
	
	This:C1470.content:=$content
	
	var $srcPath; $tgtPath : Text
	
	Case of 
			//______________________________________________________
		: (Value type:C1509(This:C1470.content)=Is text:K8:3)
			
			$srcPath:=This:C1470.content
			
			//______________________________________________________
		: (Value type:C1509(This:C1470.content)=Is object:K8:27)
			
			$srcPath:=This:C1470.content.path
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	Case of 
			//______________________________________________________
		: (Value type:C1509(This:C1470.target)=Is text:K8:3)
			
			$tgtPath:=This:C1470.target
			
			//______________________________________________________
		: (Value type:C1509(This:C1470.target)=Is object:K8:27)
			
			$tgtPath:=This:C1470.target.path
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	If ((This:C1470.target#Null:C1517) && This:C1470.target.exists)
		
		This:C1470.target.delete()
		
	End if 
	
	This:C1470.launch("hdiutil create -srcfolder "+This:C1470.quoted($srcPath)+" -format UDBZ "+This:C1470.quoted($tgtPath))
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function attach() : Boolean
	
	If (This:C1470._target())
		
		This:C1470.launch("hdiutil attach "+This:C1470.quoted(This:C1470.target.path))
		
		If (This:C1470.success)
			
			var $pos; $len : Integer
			This:C1470.success:=Match regex:C1019("(?mi-s)(/Volumes/[^$]*)"; This:C1470.outputStream; 1; $pos; $len)
			
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
	/// Detach (unmount) disk image from system
Function detach() : Boolean
	
/*
hdiutil detach <devname>
	
Note: you can specify a mount point (e.g. /Volumes/MyDisk)
      instead of a dev node (e.g. /dev/disk1)
*/
	
	If (This:C1470._disk())
		
		This:C1470.launch("hdiutil detach "+This:C1470.quoted(Delete string:C232(This:C1470.disk.path; Length:C16(This:C1470.disk.path); 1)))
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _target() : Boolean
	
	This:C1470.success:=(This:C1470.target#Null:C1517) && This:C1470.target.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid target "+(This:C1470.target ? "" : This:C1470.target.path))
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _disk() : Boolean
	
	This:C1470.success:=(This:C1470.disk#Null:C1517) && This:C1470.disk.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid disk "+(This:C1470.disk ? "" : This:C1470.disk.path))
		
	End if 
	
	return (This:C1470.success)