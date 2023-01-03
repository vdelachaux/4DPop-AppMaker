Class extends lep

Class constructor($target : 4D:C1709.File; $keychainProfile : Text)
	
	Super:C1705()
	
	This:C1470.version:=This:C1470.getVersion()
	This:C1470.available:=This:C1470.success
	
	If (This:C1470.available)
		
		This:C1470.target:=$target
		This:C1470.keychainProfile:=$keychainProfile ? $keychainProfile : Null:C1517
		
		This:C1470.success:=(This:C1470.target.exists) & (This:C1470.keychainProfile#Null:C1517)
		
		If (Not:C34(This:C1470.target.exists))
			
			This:C1470._pushError(This:C1470.target.path+" not found!")
			
		End if 
		
		If (This:C1470.keychainProfile=Null:C1517)
			
			This:C1470._pushError("Keychain profile not provided")
			
		End if 
		
	Else 
		
		This:C1470._pushError("The command line tool \"notarytool\" is not installed!")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Outputs the current version and build number of notarytool.
Function getVersion() : Text
	
	This:C1470.launch("xcrun notarytool --version")
	return (This:C1470.success ? This:C1470.outputStream : "")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Save authentication credentials for the Apple notary service to the default login keychain.
If using --key-path to pass the file path of a private key, the contents of the private key are stored
in the new keychain item and the private key file can be deleted.
*/
Function storeCredential($keychainProfile : Text; $appleId : Text; $teamID : Text; $password : Text)
	
/*
xcrun notarytool store-credentials "AC_PASSWORD"
--apple-id "AC_USERNAME"
--team-id <WWDRTeamID>
--password <secret_2FA_password>
*/
	
	If (This:C1470.available)
		
		If (Count parameters:C259<4)
			
			// TODO:Display a dialog
			
		Else 
			
			This:C1470.launch("xcrun notarytool store-credentials "+This:C1470.quoted($keychainProfile)\
				+" --apple-id "+This:C1470.quoted($appleId)\
				+" --team-id "+$teamID\
				+" --password "+$password\
				)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Submit an archive to the Apple notary service.
*/
Function submit() : Boolean
	
	var $cmd : Text
	
	If (Not:C34(This:C1470.available))
		
		return 
		
	End if 
	
	$cmd:="xcrun notarytool submit"
	$cmd+=" --keychain-profile "+This:C1470.quoted(This:C1470.keychainProfile)
	$cmd+=" "+This:C1470.quoted(This:C1470.target.path)
	$cmd+=" --wait"
	$cmd+=" --timeout 1h"
	$cmd+=" --output-format json"
	
	This:C1470.setOutputType(Is object:K8:27)
	This:C1470.launch($cmd)
	This:C1470.setOutputType()
	
	If (This:C1470.success)
		
		This:C1470.success:=String:C10(This:C1470.outputStream.status)="Accepted"
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470.log(This:C1470.outputStream.id)
		
		return True:C214
		
	Else 
		
		// Log the response
		Folder:C1567(fk logs folder:K87:17; *).file("notarizing.json").setText(JSON Stringify:C1217(This:C1470.outputStream; *))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function staple($target) : Boolean
	
	var $cmd : Text
	
	$cmd:="xcrun stapler staple "
	
	If (Count parameters:C259>0)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($target)=Is text:K8:3)
				
				$cmd+=This:C1470.quoted($target)
				
				//______________________________________________________
			: (Value type:C1509($target)=Is object:K8:27) && (OB Instance of:C1731($target; 4D:C1709.File))
				
				$cmd+=This:C1470.quoted($target.path)
				
				//______________________________________________________
			Else 
				
				This:C1470._pushError("Type of parameter not managed")
				return 
				
				//______________________________________________________
		End case 
		
	Else 
		
		$cmd+=This:C1470.quoted(This:C1470.target.path)
		
	End if 
	
	This:C1470.launch($cmd)
	
	This:C1470.success:=Match regex:C1019("(?mi-s)The staple and validate action worked!"; This:C1470.outputStream; 1)
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError(This:C1470.outputStream)
		
	End if 
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function checkWithGatekeeper($target) : Boolean
	
	var $cmd : Text
	
	$cmd:="spctl"
	$cmd+=" --assess"
	$cmd+=" --type install"
	$cmd+=" -vvvv"
	$cmd+=" "
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($target)=Is text:K8:3)
			
			$cmd+=This:C1470.quoted($target)
			
			//______________________________________________________
		: (Value type:C1509($target)=Is object:K8:27) && (OB Instance of:C1731($target; 4D:C1709.File))
			
			$cmd+=This:C1470.quoted($target.path)
			
			//______________________________________________________
		Else 
			
			This:C1470._pushError("Type of parameter not managed")
			return 
			
			//______________________________________________________
	End case 
	
	This:C1470.resultInErrorStream:=True:C214  // ⚠️ RESULT IS ON ERROR STREAM
	This:C1470.launch($cmd)
	This:C1470.resultInErrorStream:=False:C215
	
	If (This:C1470.success)
		
		This:C1470.success:=Match regex:C1019("(?mi-s): accepted\\nsource=Notarized Developer ID\\n"; This:C1470.outputStream; 1)
		
	End if 
	
	return This:C1470.success
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function findIdentity()->$identities : Collection
	
	var $info : Text
	var $start : Integer
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	$identities:=New collection:C1472
	
	This:C1470.launch("security find-identity -p basic -v")
	
	If (This:C1470.success)
		
		$start:=1
		
		While (Match regex:C1019("(?m)\\s+(\\d+\\))\\s+([:Hex_Digit:]+)\\s+\"([^\"]+)\"$"; This:C1470.outputStream; $start; $pos; $len))
			
			$identities.push(New object:C1471(\
				"id"; Substring:C12($info; $pos{2}; $len{2}); \
				"name"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3})))
			
			$start:=$pos{3}+$len{3}
			
		End while 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Get status information for a previous submission.
$id is a Submission ID returned from a previous invocation of the submit subcommand.
*/
Function info($id : Text; $keychainProfile : Text) : Object
	
	//xcrun notarytool info "REQUEST_ID" --keychain-profile "AC_PASSWORD"
	
	If (This:C1470.available)
		
		//
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Retrieve notarization log for a single completed submission as JSON.
$id is a Submission ID returned from a previous invocation of the submit subcommand.
*/
Function log($id : Text)
	
	If (This:C1470.available)
		
		This:C1470.launch("xcrun notarytool log "+$id\
			+" --keychain-profile "+This:C1470.quoted(This:C1470.keychainProfile)\
			+" "+This:C1470.quoted(Folder:C1567(Folder:C1567(fk logs folder:K87:17; *).platformPath; fk platform path:K87:2).file("notarizing.json").path))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
/*
Get a list of previous submissions for your development team that were submitted via notarytool.
*/
Function history($keychainProfile : Text)
	
	//xcrun notarytool history --keychain-profile "AC_PASSWORD"
	
	If (This:C1470.available)
		
		//
		
	End if 