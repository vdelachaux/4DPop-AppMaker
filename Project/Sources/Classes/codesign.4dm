Class extends lep

/*
The codesign command is used to create, check, and display code signa-
tures, as well as inquire into the dynamic status of signed code in the
system.

https://ss64.com/osx/codesign.html

Sign:
      codesign -s identity [-i identifier] [-r requirements] [-fv] [path ...]

      Verify:
      codesign -v [-R requirement] [-v] [path|pid ...]

      Display:
      codesign -d [-v] [path|pid ...]

      Hosting chain:
      codesign -h [-v] [pid ...]
*/

// === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($credentials : Object)
	
	Super:C1705()
	
	This:C1470.appleID:=$credentials.appleID ? String:C10($credentials.appleID) : Null:C1517
	This:C1470.certificate:=$credentials.certificate ? String:C10($credentials.certificate) : Null:C1517
	This:C1470.publicID:=$credentials.publicID ? String:C10($credentials.publicID) : Null:C1517
	This:C1470.keychainProfile:=$credentials.keychainProfile ? String:C10($credentials.keychainProfile) : Null:C1517
	
	This:C1470.identity:=This:C1470.findIdentities().query("name = :1"; "Developer ID Application: "+This:C1470.certificate).pop()
	This:C1470.success:=This:C1470.identity#Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function removeSignature($path) : Boolean
	
	// TODO: Allow collection & more (File, Folder,…)
	
	This:C1470.launch("codesign --remove-signature "+This:C1470.quoted($path))
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/** Sign the code at the path(s) given using an identity.
- When signing a bundle, the nested code content is be recursively signed (--deep)
- Replace any existing signature on the path(s) given (--force)
- Contacts the Apple servers to authenticate the time of the signature. (--timestamp)
- Harden (--options runtime)
*/
Function sign($path) : Boolean
	
	var $identity : Text
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.certificate#Null:C1517)
			
			$identity:=This:C1470.quoted("Developer ID Application: "+This:C1470.certificate)
			
			//______________________________________________________
		: (This:C1470.identity#Null:C1517)
			
			$identity:=This:C1470.identity.name
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("No certificate provided nor identity found")
			This:C1470.success:=False:C215
			
			//______________________________________________________
	End case 
	
	If (This:C1470.success)
		
		Case of 
				//______________________________________________________
			: (Value type:C1509($path)=Is object:K8:27) && ((OB Instance of:C1731($path; 4D:C1709.File)) || (OB Instance of:C1731($path; 4D:C1709.Folder)))
				
				$path:=$path.path
				
				//______________________________________________________
			: (Value type:C1509($path)=Is text:K8:3)
				
				// We assume that it's a unix pathname
				
				//______________________________________________________
			Else 
				
				This:C1470._pushError("$path must be a unix pathname or a File/Folder object")
				
				//______________________________________________________
		End case 
		
		If (Length:C16($identity)>0)
			
			// ⚠️ RESULT IS ON ERROR STREAM
			This:C1470.resultInErrorStream:=True:C214
			This:C1470.launch("codesign --verbose --deep --timestamp --options runtime --force --sign "+$identity+" "+This:C1470.quoted($path))
			This:C1470.resultInErrorStream:=False:C215
			
		End if 
	End if 
	
	return This:C1470.success
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function verifySignature($path) : Boolean
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($path)=Is object:K8:27) && ((OB Instance of:C1731($path; 4D:C1709.File)) || (OB Instance of:C1731($path; 4D:C1709.Folder)))
			
			$path:=$path.path
			
			//______________________________________________________
		: (Value type:C1509($path)=Is text:K8:3)
			
			// We assume that it's a unix pathname
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("$path must be a unix pathname or a File/Folder object")
			
			//______________________________________________________
	End case 
	
	This:C1470.launch("codesign --verify --verbose --deep --strict  "+This:C1470.quoted($path))
	
	If (This:C1470.success)
		
/*
<file>: valid on disk
<file>: satisfies its Designated Requirement
*/
		
	End if 
	
	return This:C1470.success
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function storeCredential() : Boolean
	
	//TODO: TODO
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	///
Function findIdentities() : Collection
	
	var $start : Integer
	var $identities : Collection
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$identities:=New collection:C1472
	
	This:C1470.launch("security find-identity -p basic -v")
	
	If (This:C1470.success)
		
		$start:=1
		
		While (Match regex:C1019("(?m)\\s+(\\d+\\))\\s+([:Hex_Digit:]+)\\s+\"([^\"]+)\"$"; This:C1470.outputStream; $start; $pos; $len))
			
			$identities.push(New object:C1471(\
				"id"; Substring:C12(This:C1470.outputStream; $pos{2}; $len{2}); \
				"name"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3})))
			
			$start:=$pos{3}+$len{3}
			
		End while 
	End if 
	
	return $identities
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function getPublicID($password : Text)
	
	This:C1470.launch("xcrun altool --list-providers -u "+This:C1470.appleID+" -p "+$password)