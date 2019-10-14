Case of 
		  //______________________________________________________
	: (Form event:C388=On Mouse Enter:K2:33)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->:=Get localized string:C991("4DPop_run")
		
		  //______________________________________________________
	: (Form event:C388=On Mouse Leave:K2:34)
		
		CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5;"tips"))->)
		
		  //______________________________________________________
	: (Form event:C388=On Clicked:K2:4)
		
		OBJECT SET VISIBLE:C603(*;"tips.run";True:C214)
		
		Form:C1466.page(1;50)
		
		  //______________________________________________________
End case 