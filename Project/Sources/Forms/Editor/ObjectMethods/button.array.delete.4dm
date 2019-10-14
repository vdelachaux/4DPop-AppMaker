C_POINTER:C301($Ptr_column_1)
C_TEXT:C284($Txt_type)

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"arraytype";$Txt_type)

Case of 
		
		  //………………………………………………
	: ($Txt_type="@license4D")
		
		$Ptr_column_1:=OBJECT Get pointer:C1124(Object named:K67:5;"C1")
		
		LISTBOX DELETE ROWS:C914(*;"element.array";$Ptr_column_1->)
		
		BuildApp_SET_ARRAY ($Ptr_column_1)
		
		LISTBOX SELECT ROW:C912(*;"element.array";0;lk remove from selection:K53:3)
		OBJECT SET VISIBLE:C603(*;"button.array.delete@";False:C215)
		
		Form:C1466.modified:=True:C214
		  //………………………………………………
	Else 
		
		TRACE:C157
		
		  //………………………………………………
End case 