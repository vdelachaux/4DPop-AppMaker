C_LONGINT:C283($Lon_count;$Lon_x)
C_POINTER:C301($Ptr_array)
C_TEXT:C284($Mnu_choice;$Mnu_main;$Txt_buffer;$Txt_path)

$Ptr_array:=OBJECT Get pointer:C1124(Object named:K67:5;"list.copy.items")

$Mnu_main:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("File…"))
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"file")

APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("Folder…"))
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"folder")

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
		  //______________________________________________________
	: ($Mnu_choice="file")
		
		$Txt_buffer:=Select document:C905(100;"*";"";Package open:K24:8+Alias selection:K24:10+Use sheet window:K24:11)
		
		If (OK=1)
			
			$Txt_path:=DOCUMENT
			
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="folder")
		
		$Txt_path:=Select folder:C670("";100;Package open:K24:8+Use sheet window:K24:11)
		
		  //______________________________________________________
End case 

If (Length:C16($Txt_path)>0)
	
	$Txt_path:=Replace string:C233($Txt_path;Storage:C1525.environment.databaseFolder;"")
	$Txt_path:=Replace string:C233($Txt_path;Folder separator:K24:12;"/")
	
	$Lon_x:=Find in array:C230($Ptr_array->;$Txt_path)
	
	If ($Lon_x=-1)
		
		$Lon_count:=LISTBOX Get number of rows:C915(*;"list.copy")+1
		LISTBOX INSERT ROWS:C913(*;"list.copy";$Lon_count)
		
		LISTBOX SELECT ROW:C912(*;"list.copy";$Lon_count;lk replace selection:K53:1)
		OBJECT SET ENABLED:C1123(*;"b.copy.delete";True:C214)
		
		$Ptr_array->{$Lon_count}:=$Txt_path
		
		_o_param_SET_ARRAY (Storage:C1525.environment.domPref;\
			"copy/array";\
			$Ptr_array)
		
	Else 
		
		LISTBOX SELECT ROW:C912(*;"list.copy";$Lon_x;lk replace selection:K53:1)
		OBJECT SET ENABLED:C1123(*;"b.copy.delete";True:C214)
		
	End if 
	
End if 
