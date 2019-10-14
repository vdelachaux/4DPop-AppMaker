  // ----------------------------------------------------
  // Object method : Editor.list.delete - (4DPop AppMaker.4DB)
  // Created 09/05/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form event:C388=On Selection Change:K2:29)
		
		  // OBJECT SET ENABLED(*;"b.delete.delete";(OBJECT Get pointer(Object named;"list.delete.items"))->>0)
		
		  //______________________________________________________
	: (Form event:C388=On Data Change:K2:15)
		
		_o_param_SET_ARRAY (Storage:C1525.environment.domPref;\
			"delete/array";\
			OBJECT Get pointer:C1124(Object named:K67:5;"list.delete.items"))
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Enter:K2:33)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->:=Get localized string:C991("tips.delete")
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Leave:K2:34)
		
		CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unnecessarily activated form event")
		
		  //______________________________________________________
End case 