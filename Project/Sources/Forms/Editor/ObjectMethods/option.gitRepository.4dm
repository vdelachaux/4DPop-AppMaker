  // ----------------------------------------------------
  // Object method : Editor.option.launch - (4DPop AppMaker)
  // ID[406B53D3A83B42D8A62987192B8B8BAC]
  // Created #15-5-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form event:C388=On Clicked:K2:4)
		
		Storage:C1525.preferences.set("options@gitRepository";Choose:C955(Form:C1466.options.gitRepository;"true";"false"))
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Enter:K2:33)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->:=Get localized string:C991("tips.gitRepository")
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Leave:K2:34)
		
		CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10(Form event:C388)+")")
		
		  //______________________________________________________
End case 