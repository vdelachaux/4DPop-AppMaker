C_LONGINT:C283($Lon_count;$Lon_x)
C_POINTER:C301($Ptr_array)
C_TEXT:C284($Mnu_choice;$Mnu_main;$Txt_buffer;$Txt_path)

$Ptr_array:=OBJECT Get pointer:C1124(Object named:K67:5;"list.delete.items")

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
		
		$Txt_buffer:=Select document:C905(200;"*";"";Package open:K24:8+Alias selection:K24:10+Use sheet window:K24:11)
		
		If (OK=1)
			
			$Txt_path:=DOCUMENT
			
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="folder")
		
		$Txt_path:=Select folder:C670("";200;Package open:K24:8+Use sheet window:K24:11)
		
		  //______________________________________________________
End case 

If (Length:C16($Txt_path)>0)
	
	OK:=1
	
	  //Validate a local path relative to the target or to the source
	  //$Txt_buffer:=doc_getFromPath ("parent";APP_MAKER_Get_target_path )
	$Txt_buffer:=_o_APP_MAKER_Get_target_path (kRoot)
	
	If (Position:C15($Txt_buffer;$Txt_path)=1)
		
		$Txt_path:=Replace string:C233($Txt_path;$Txt_buffer;"./")
		
	Else 
		
		If (Position:C15(Storage:C1525.environment.databaseFolder;$Txt_path)=1)
			
			$Txt_path:=Replace string:C233($Txt_path;Storage:C1525.environment.databaseFolder;"./")
			
		Else 
			
			If (Position:C15(Storage:C1525.environment.databaseFolder;$Txt_path)=1)
				
				$Txt_path:=Replace string:C233($Txt_path;Storage:C1525.environment.databaseFolder;"./")
				
			Else 
				
				ALERT:C41("File/folder must be in the source/target package")
				
				OK:=0
				
			End if 
		End if 
	End if 
	
	If (OK=1)
		
		$Txt_path:=Replace string:C233($Txt_path;Folder separator:K24:12;"/")
		
		$Lon_x:=Find in array:C230($Ptr_array->;$Txt_path)
		
		If ($Lon_x=-1)
			
			$Lon_count:=LISTBOX Get number of rows:C915(*;"list.delete")+1
			LISTBOX INSERT ROWS:C913(*;"list.delete";$Lon_count)
			
			LISTBOX SELECT ROW:C912(*;"list.delete";$Lon_count;lk replace selection:K53:1)
			OBJECT SET ENABLED:C1123(*;"b.delete.delete";True:C214)
			
			$Ptr_array->{$Lon_count}:=$Txt_path
			
			_o_param_SET_ARRAY (Storage:C1525.environment.domPref;"delete/array";$Ptr_array)
			
		Else 
			
			LISTBOX SELECT ROW:C912(*;"list.delete";$Lon_x;lk replace selection:K53:1)
			OBJECT SET ENABLED:C1123(*;"b.delete.delete";True:C214)
			
		End if 
	End if 
End if 
