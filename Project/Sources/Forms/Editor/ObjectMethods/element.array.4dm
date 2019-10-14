C_TEXT:C284($Txt_type)

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"arraytype";$Txt_type)

Case of 
		  //______________________________________________________
	: ($Txt_type="plugin.@")
		  //______________________________________________________
	: ($Txt_type="component")
		  //______________________________________________________
	: ($Txt_type="path.@")
		
		OBJECT SET VISIBLE:C603(*;"button.array.delete@";(OBJECT Get pointer:C1124(Object named:K67:5;"C1"))->>0)
		
		  //______________________________________________________
End case 