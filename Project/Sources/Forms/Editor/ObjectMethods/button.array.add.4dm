  //EDITOR_Object_Methods
C_LONGINT:C283($Lon_count)
C_POINTER:C301($Ptr_column_1)
C_TEXT:C284($Txt_buffer;$Txt_path;$Txt_type)

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"arraytype";$Txt_type)

If ($Txt_type="path.folder")
	
	$Txt_path:=Select folder:C670(Get localized string:C991("selectFolder");1)
	
Else 
	
	$Txt_buffer:=Select document:C905(1;\
		Replace string:C233($Txt_type;"path.file";"");\
		Get localized string:C991("selectFile");\
		Package open:K24:8+Use sheet window:K24:11)
	
	$Txt_path:=DOCUMENT
	
End if 

Case of 
		
		  //………………………………………………
	: (OK=0)
		
		  //………………………………………………
	: ($Txt_type="@license4D")
		
		$Ptr_column_1:=OBJECT Get pointer:C1124(Object named:K67:5;"C1")
		
		$Lon_count:=LISTBOX Get number of rows:C915(*;"element.array")+1
		LISTBOX INSERT ROWS:C913(*;"element.array";$Lon_count)
		
		$Ptr_column_1->{$Lon_count}:=$Txt_path
		BuildApp_SET_ARRAY ($Ptr_column_1)
		
		LISTBOX SELECT ROW:C912(*;"element.array";$Lon_count;lk replace selection:K53:1)
		OBJECT SET VISIBLE:C603(*;"button.array.delete@";True:C214)
		
		Form:C1466.modified:=True:C214
		
		  //………………………………………………
	Else 
		
		TRACE:C157
		
		  //………………………………………………
End case 