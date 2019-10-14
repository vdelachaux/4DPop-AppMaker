  // ----------------------------------------------------
  // Object method : Editor.method.before.box - (4DPop AppMaker.4DB)
  // Created 09/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form event:C388=On Data Change:K2:15)
		
		Storage:C1525.preferences.set("methods@before";Form:C1466.methods.before)
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Enter:K2:33)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->:=Get localized string:C991("tips.method.before")
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Leave:K2:34)
		
		CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unnecessarily activated form event")
		
		  //______________________________________________________
End case 