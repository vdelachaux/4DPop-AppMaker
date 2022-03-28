// ----------------------------------------------------
// Object method : Editor1.b.run - (4DPop AppMaker.4DB)
// Created 05/05/11 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations

// ----------------------------------------------------
// Initialisations

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Form event code:C388=On Mouse Enter:K2:33)
		
		OBJECT SET VISIBLE:C603(*; "tips.run"; True:C214)
		
		//______________________________________________________
	: (Form event code:C388=On Mouse Leave:K2:34)
		
		OBJECT SET VISIBLE:C603(*; "tips.run"; False:C215)
		
		//______________________________________________________
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Bool:C1537(Form:C1466.modified))
			
			DOM EXPORT TO FILE:C862(Storage:C1525.environment.domBuildApp; Storage:C1525.environment.buildApp)
			Form:C1466.modified:=False:C215
			
		End if 
		
		APP_MAKER_HANDLER("_run")
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unnecessarily activated form event")
		
		//______________________________________________________
End case 