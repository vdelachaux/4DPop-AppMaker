//%attributes = {}
// ----------------------------------------------------
// Method :  APP MAKER HANDLER
// Created 30/05/08 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Build application and more...
// ----------------------------------------------------
// Declarations
#DECLARE($action : Text)

var $success : Boolean
var $data : Object

// ----------------------------------------------------
Case of 
		
		//================================================================================
	: (Length:C16($action)=0)  // No parameter
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=Current method name:C684)
				
				// Error managemnt routine
				
				//……………………………………………………………………
			Else 
				
				// This method must be executed in a new process
				BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; "$"+Current method name:C684; "_open"; *))
				
				//……………………………………………………………………
		End case 
		
		//================================================================================
	: ($action="_open")  // Display the main dialog
		
		APP MAKER HANDLER("_declarations")
		APP MAKER HANDLER("_init")
		
		$data:=New object:C1471(\
			"process"; Current process:C322; \
			"window"; Open form window:C675("Editor"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4; *))
		DIALOG:C40("Editor"; $data)
		CLOSE WINDOW:C154($data.window)
		
		If (Storage:C1525.environment.domBuildApp#Null:C1517)
			
			If (Bool:C1537($data.modified))
				
				DOM EXPORT TO FILE:C862(Storage:C1525.environment.domBuildApp; Storage:C1525.environment.buildApp)
				
			End if 
			
			Use (Storage:C1525)
				
				Use (Storage:C1525.environment)
					
					DOM CLOSE XML:C722(Storage:C1525.environment.domBuildApp)
					Storage:C1525.environment.domBuildApp:=Null:C1517
					
				End use 
			End use 
		End if 
		
		Storage:C1525.preferences.save()
		
		APP MAKER HANDLER("_deinit")
		
		//================================================================================
	: ($action="_declarations")
		
		COMPILER_o_
		
		//================================================================================
	: ($action="_init")
		
		_o_appMaker_INIT
		
		//================================================================================
	: ($action="_deinit")
		
		$success:=PHP Execute:C1058(""; "quit_4d_php")
		
		//================================================================================
	Else 
		
		TRACE:C157
		
		//================================================================================
End case 