Class extends lep

Class constructor($target : 4D:C1709.File; $keychainProfile : Text)
	
	Super:C1705()
	
	This:C1470.responses:=New collection:C1472
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
	
	If (This:C1470.available)
		
		This:C1470.setOutputType(Is object:K8:27)
		
		This:C1470.launch("xcrun notarytool submit "+This:C1470.quoted(This:C1470.target.path)\
			+" --keychain-profile "+This:C1470.quoted(This:C1470.keychainProfile)\
			+" --output-format json --wait")
		
		This:C1470.setOutputType()
		
		This:C1470.responses.push(JSON Stringify:C1217(This:C1470.outputStream))
		
		If (This:C1470.success)
			
			This:C1470.success:=This:C1470.outputStream.status="Accepted"
			
		End if 
	End if 
	
	return This:C1470.success
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function ckeckWithGatekeeper($path : Text; $certificate : Text) : Boolean
	
	This:C1470.resultInErrorStream:=True:C214  // ⚠️ RESULT IS ON ERROR STREAM
	This:C1470.launch("spctl --assess --type install -vvvv "+This:C1470.quoted($path))
	This:C1470.resultInErrorStream:=False:C215
	
	This:C1470.responses.push(This:C1470.outputStream+This:C1470.errorStream)
	
	If (This:C1470.success)
		
/*
<file>: accepted
source=Notarized Developer ID
origin=Developer ID Application: <certificate>
*/
		
		ARRAY LONGINT:C221($len; 0)
		ARRAY LONGINT:C221($pos; 0)
		If (Match regex:C1019("(?mi-s): accepted\\nsource=Notarized Developer ID\\norigin=Developer ID Application: ([^$]*)$"; This:C1470.outputStream; 1; $pos; $len))
			
			This:C1470.success:=Substring:C12(This:C1470.outputStream; $pos{1}; $len{1})=$certificate
			
		Else 
			
			This:C1470.success:=False:C215
			
		End if 
	End if 
	
	return This:C1470.success
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function staple() : Boolean
	
	This:C1470.launch("xcrun stapler staple "+This:C1470.quoted(This:C1470.target.path))
	This:C1470.responses.push(This:C1470.outputStream+This:C1470.errorStream)
	
	This:C1470.success:=Match regex:C1019("(?mi-s)The staple and validate action worked!"; This:C1470.outputStream; 1)
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError(This:C1470.outputStream)
		
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
Function log($id : Text; $keychainProfile : Text)
	
	//% xcrun notarytool log "REQUEST_ID" --keychain-profile "AC_PASSWORD" developer_log.json
	
	If (This:C1470.available)
		
		//
		
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