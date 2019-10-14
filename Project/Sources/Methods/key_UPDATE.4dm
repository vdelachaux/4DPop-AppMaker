//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : key_UPDATE
  // Database: 4DPop AppMaker
  // ID[49102400DC654F3AB84E7F8FAB4BBF1F]
  // Created #10-7-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_keyDefined;$Boo_locked)
C_LONGINT:C283($Lon_back;$Lon_bottom;$Lon_count;$Lon_height;$Lon_i;$Lon_left)
C_LONGINT:C283($Lon_optimalHeight;$Lon_optimalWidth;$Lon_parameters;$Lon_ref;$Lon_right;$Lon_sublist)
C_LONGINT:C283($Lon_top;$Lon_width;$Lon_x;$Lon_y)
C_POINTER:C301($Ptr_column_1;$Ptr_column_2;$Ptr_column_3;$Ptr_object)
C_TEXT:C284($Dom_node;$Txt_buffer;$Txt_name;$Txt_platform;$Txt_structureFolderPath;$Txt_tagValue)
C_TEXT:C284($Txt_type;$Txt_UID;$Txt_xpath)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
GET LIST ITEM:C378(Form:C1466.buildApp;*;$Lon_ref;$Txt_name)

OBJECT SET VISIBLE:C603(*;"element.@";False:C215)
OBJECT SET VISIBLE:C603(*;"button.array.@";False:C215)
OBJECT SET VISIBLE:C603(*;"os.@";False:C215)
OBJECT SET VISIBLE:C603(*;"lock";False:C215)
OBJECT SET VISIBLE:C603(*;"alert";False:C215)

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"xpath";$Txt_xpath)
$Txt_buffer:=Get localized string:C991($Txt_xpath)

If (Length:C16($Txt_buffer)=0)
	
	$Txt_buffer:=Get localized string:C991($Txt_name)
	
End if 

(OBJECT Get pointer:C1124(Object named:K67:5;"help"))->:=$Txt_buffer
(OBJECT Get pointer:C1124(Object named:K67:5;"help1"))->:=$Txt_buffer
OBJECT GET COORDINATES:C663(*;"help1";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
$Lon_width:=$Lon_right-$Lon_left
$Lon_height:=$Lon_bottom-$Lon_top
OBJECT GET BEST SIZE:C717(*;"help1";$Lon_optimalWidth;$Lon_optimalHeight;$Lon_width)
OBJECT SET VISIBLE:C603(*;"help1";$Lon_optimalHeight<=$Lon_height)
OBJECT SET VISIBLE:C603(*;"help";$Lon_optimalHeight>$Lon_height)
REDRAW WINDOW:C456

If ($Lon_sublist=0)\
 & ($Lon_ref>0)
	
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"type";$Txt_type)
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"os";$Txt_platform)
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"UID";$Txt_UID)
	
	$Boo_keyDefined:=(Length:C16($Txt_UID)>0)
	$Boo_locked:=(($Txt_platform#Choose:C955(Is macOS:C1572;"mac";"win")) & (Length:C16($Txt_platform)>0))
	
	If (Form event:C388=On Clicked:K2:4)\
		 & ((Macintosh option down:C545 | Windows Alt down:C563) & $Boo_keyDefined)
		
		CONFIRM:C162(Get localized string:C991("AreYouSureYouWantToClearThisKey?");Get localized string:C991("CommonDelete"))
		
		If (OK=1)
			
			DOM REMOVE XML ELEMENT:C869($Txt_UID)
			SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp;*;"UID";"")
			
			key_mark (False:C215)
			
			Form:C1466.modified:=True:C214
			
		End if 
		
		Form:C1466.action:=-5
		Form:C1466.refresh()
		
	Else 
		
		$Ptr_object:=OBJECT Get pointer:C1124(Object named:K67:5;"element.value.label")
		OBJECT SET VISIBLE:C603(*;"element.value.label";True:C214)
		
		$Lon_x:=Position:C15(".";$Txt_type)
		
		If ($Lon_x>0)
			
			OBJECT SET VISIBLE:C603(*;"element.@"+Substring:C12($Txt_type;1;$Lon_x-1)+"@";True:C214)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;"element.@"+$Txt_type+"@";Length:C16($Txt_type)>0)
			
		End if 
		
		Case of 
				
				  //…………………………………………
			: ($Txt_type="alpha@")
				
				$Ptr_object->:=Get localized string:C991(Replace string:C233($Txt_type;"alpha.";""))
				
				If ($Boo_keyDefined)
					
					DOM GET XML ELEMENT VALUE:C731($Txt_UID;<>Txt_value)
					
				Else 
					
					<>Txt_value:=""
					
				End if 
				
				  //…………………………………………
			: ($Txt_type="boolean@")
				
				$Ptr_object->:=Get localized string:C991(Replace string:C233($Txt_type;"boolean.";""))
				
				If ($Boo_keyDefined)
					
					DOM GET XML ELEMENT VALUE:C731($Txt_UID;$Txt_tagValue)
					
					$Lon_x:=Num:C11($Txt_tagValue="True")
					
				Else 
					
					$Lon_x:=0
					
				End if 
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"element.boolean.1"))->:=$Lon_x
				(OBJECT Get pointer:C1124(Object named:K67:5;"element.boolean.2"))->:=1-$Lon_x
				
				  //…………………………………………
			: ($Txt_type="path.@")
				
				If ($Boo_keyDefined)
					
					DOM GET XML ELEMENT VALUE:C731($Txt_UID;<>Txt_value)
					
				Else 
					
					<>Txt_value:=""
					
				End if 
				
				If ($Boo_locked)
					
					OBJECT SET VISIBLE:C603(*;"element.unlock.path@";False:C215)
					
				Else 
					
					OBJECT SET VISIBLE:C603(*;"element.lock.path@";False:C215)
					
					If (<>Txt_value="::") | (<>Txt_value="..\\")
						
						<>Txt_value:=Path to object:C1547(Storage:C1525.environment.databaseFolder).parentFolder
						
					Else 
						
						If (doc_Is_Relative_Path (<>Txt_value))
							
							  //Get the absolute path {
							$Txt_structureFolderPath:=Storage:C1525.environment.databaseFolder
							
							For ($Lon_i;1;Length:C16(<>Txt_value);1)
								
								If (Position:C15(<>Txt_value[[$Lon_i]];Choose:C955(Is macOS:C1572;":";".\\"))#0)
									
									$Lon_back:=$Lon_i
									
								Else 
									
									$Lon_i:=MAXLONG:K35:2-1
									
								End if 
							End for 
							
							If ($Lon_back>0)
								
								If (Is Windows:C1573)
									
									$Lon_back:=$Lon_back-1
									
								End if 
							End if 
							
							For ($Lon_i;1;$Lon_back;1)
								
								$Lon_y:=0
								
								Repeat 
									
									$Lon_x:=Position:C15(Folder separator:K24:12;$Txt_structureFolderPath;$Lon_y+1)
									
									If ($Lon_x>0)
										
										$Lon_y:=$Lon_x
										
									End if 
								Until ($Lon_x=0)
								
								$Txt_structureFolderPath:=Substring:C12($Txt_structureFolderPath;1;$Lon_y-1)
								
							End for 
							
							<>Txt_value:=Delete string:C232(<>Txt_value;1;$Lon_back-Num:C11(Is macOS:C1572))
							<>Txt_value:=$Txt_structureFolderPath+<>Txt_value
							  //}
							
						End if 
					End if 
					
					doc_OBJET_LOCATION (<>Txt_value;"element.unlock.path.Button";On Load:K2:1;-1)
					
					Case of 
							
							  //__________________________
						: (Not:C34($Boo_keyDefined))
							
							  //__________________________
						: (Test path name:C476(<>Txt_value)=Is a document:K24:1)
							
							  //__________________________
						: (Test path name:C476(<>Txt_value)=Is a folder:K24:2)
							
							  //__________________________
						Else 
							
							BEEP:C151
							OBJECT SET VISIBLE:C603(*;"Alert";True:C214)
							
							  //__________________________
					End case 
				End if 
				
				$Ptr_object->:=Choose:C955($Txt_type="@.folder@";Get localized string:C991("folder");Get localized string:C991("file"))
				
				$Txt_type:=Replace string:C233($Txt_type;".folder";"")
				$Lon_x:=Position:C15(".file";$Txt_type)
				
				If ($Lon_x>0)
					
					$Txt_type:=Substring:C12($Txt_type;1;$Lon_x-1)
					
				End if 
				
				  //…………………………………………
			: ($Txt_type="array")
				
				OBJECT SET VISIBLE:C603(*;"element."+$Txt_type+"@";True:C214)
				OBJECT SET VISIBLE:C603(*;"element.value.label";True:C214)
				
				OBJECT SET VISIBLE:C603(*;"C1";True:C214)
				OBJECT SET VISIBLE:C603(*;"C2";True:C214)
				OBJECT SET VISIBLE:C603(*;"C3";True:C214)
				
				$Ptr_column_1:=OBJECT Get pointer:C1124(Object named:K67:5;"C1")
				$Ptr_column_2:=OBJECT Get pointer:C1124(Object named:K67:5;"C2")
				$Ptr_column_3:=OBJECT Get pointer:C1124(Object named:K67:5;"C3")
				
				ARRAY TEXT:C222($Ptr_column_1->;0x0000)
				ARRAY LONGINT:C221($Ptr_column_2->;0x0000)
				ARRAY BOOLEAN:C223($Ptr_column_3->;0x0000)
				
				If ($Boo_keyDefined)
					
					  //Get the number elements of the array. Then the elements if any {
					GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"xpath";$Txt_buffer)
					
					If (Length:C16($Txt_buffer)>0)
						
						$Dom_node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;$Txt_buffer+"/ItemsCount")
						
						If (OK=1)
							
							DOM GET XML ELEMENT VALUE:C731($Dom_node;$Lon_x)
							
						End if 
						
						ARRAY TEXT:C222($tTxt_values;$Lon_x)
						
						For ($Lon_i;1;$Lon_x;1)
							
							$Dom_node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp;$Txt_buffer+"/Item"+String:C10($Lon_i))
							
							If (OK=1)
								
								DOM GET XML ELEMENT VALUE:C731($Dom_node;$tTxt_values{$Lon_i})
								
							End if 
						End for 
					End if 
					  //}
					
				Else 
					
					ARRAY TEXT:C222($tTxt_values;0x0000)
					
				End if 
				
				  //Get the type of the elements of the array and construct an appropriate listbox {
				GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp;*;"arraytype";$Txt_type)
				
				Case of 
						
						  //+++++++++++++++++++++++++++++++++++++++
					: ($Txt_type="plugin.@")
						
						  //Get the plugin list {
						PLUGIN LIST:C847($Ptr_column_2->;$Ptr_column_1->)
						
						For ($Lon_i;Size of array:C274($Ptr_column_1->);1;-1)
							
							Case of 
									
									  //…………………………………………
								: ($Ptr_column_1->{$Lon_i}="4D Internet Commands")
									
									$Ptr_column_2->{$Lon_i}:=15010
									
									  //…………………………………………
								: ($Ptr_column_1->{$Lon_i}="4D@Pack")
									
									$Ptr_column_2->{$Lon_i}:=11999
									
									  //…………………………………………
								: ($Ptr_column_2->{$Lon_i}=808464432)
									
									DELETE FROM ARRAY:C228($Ptr_column_1->;$lon_i;1)
									DELETE FROM ARRAY:C228($Ptr_column_2->;$lon_i;1)
									
									  //…………………………………………
								: ($Ptr_column_2->{$Lon_i}=4D View license:K44:4)
									
									$Ptr_column_2->{$Lon_i}:=13000
									
									  //…………………………………………
								: ($Ptr_column_2->{$Lon_i}=4D Write license:K44:2)
									
									$Ptr_column_2->{$Lon_i}:=12000
									
									  //…………………………………………
								: ($Ptr_column_2->{$Lon_i}=4D ODBC Pro license:K44:9)
									
									$Ptr_column_2->{$Lon_i}:=13500
									
									  //…………………………………………
							End case 
						End for 
						  //}
						
						$Lon_count:=Size of array:C274($Ptr_column_1->)
						ARRAY BOOLEAN:C223($Ptr_column_3->;$Lon_count)
						
						If ($Lon_count>0)
							
							If ($Txt_type="@.name")
								
								For ($Lon_i;1;$Lon_count;1)
									
									$Ptr_column_3->{$Lon_i}:=(Find in array:C230($tTxt_values;$Ptr_column_1->{$Lon_i})=-1)
									
								End for 
								
								OBJECT SET VISIBLE:C603(*;"C2";False:C215)
								
							Else 
								
								For ($Lon_i;1;$Lon_count;1)
									
									$Ptr_column_3->{$Lon_i}:=(Find in array:C230($tTxt_values;String:C10($Ptr_column_2->{$Lon_i}))=-1)
									
								End for 
								
								OBJECT SET VISIBLE:C603(*;"C1";False:C215)
								
							End if 
							
							OBJECT SET VISIBLE:C603(*;"C3";True:C214)
							
							$Ptr_object->:=Get localized string:C991("plugin")
							
						Else 
							
							$Ptr_object->:=Get localized string:C991("no-plugin")
							OBJECT SET VISIBLE:C603(*;"element.array";False:C215)
							
						End if 
						
						  //+++++++++++++++++++++++++++++++++++++++
					: ($Txt_type="component")
						
						COMPONENT LIST:C1001($Ptr_column_1->)
						
						$Lon_count:=Size of array:C274($Ptr_column_1->)
						
						If ($Lon_count>0)
							
							ARRAY BOOLEAN:C223($Ptr_column_3->;$Lon_count)
							
							For ($Lon_i;1;$Lon_count;1)
								
								$Ptr_column_3->{$Lon_i}:=(Find in array:C230($tTxt_values;$Ptr_column_1->{$Lon_i})=-1)
								
							End for 
							
							$Ptr_object->:=Get localized string:C991("component")
							
							ARRAY LONGINT:C221($Ptr_column_2->;$Lon_count)
							OBJECT SET VISIBLE:C603(*;"C2";False:C215)
							
						Else 
							
							$Ptr_object->:=Get localized string:C991("no-component")
							OBJECT SET VISIBLE:C603(*;"element.array";False:C215)
							
						End if 
						
						  //+++++++++++++++++++++++++++++++++++++++
					: ($Txt_type="path.@")  //Licences...
						
						If (Asserted:C1132($Txt_type="path.file.license4D"))
							
							COPY ARRAY:C226($tTxt_values;$Ptr_column_1->)
							
							$Lon_count:=Size of array:C274($Ptr_column_1->)
							
							$Ptr_object->:=Get localized string:C991("licences")
							
						End if 
						
						ARRAY BOOLEAN:C223($Ptr_column_3->;$Lon_count)
						ARRAY LONGINT:C221($Ptr_column_2->;$Lon_count)
						OBJECT SET VISIBLE:C603(*;"C2";False:C215)
						OBJECT SET VISIBLE:C603(*;"C3";False:C215)
						
						OBJECT SET VISIBLE:C603(*;"button.array.@";True:C214)
						
						OBJECT SET VISIBLE:C603(*;"button.array.add@";Not:C34($Boo_locked))
						OBJECT SET VISIBLE:C603(*;"button.array.delete@";$Ptr_column_1->>0)
						
						  //+++++++++++++++++++++++++++++++++++++++
					Else 
						
						TRACE:C157
						
						  //+++++++++++++++++++++++++++++++++++++++
				End case   //}
				
				OBJECT SET HORIZONTAL ALIGNMENT:C706(*;"element.array";Align left:K42:2)
				LISTBOX SELECT ROW:C912(*;"element.array";0;lk remove from selection:K53:3)
				
				  //…………………………………………
		End case 
	End if 
	
	If (Length:C16($Txt_type)#0)
		
		If (Length:C16($Txt_platform)>0)
			
			OBJECT SET VISIBLE:C603(*;"os."+$Txt_platform+".alone@";True:C214)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;"os.@.all";True:C214)
			
		End if 
		
		OBJECT SET VISIBLE:C603(*;"lock";$Boo_locked)
		
	End if 
End if 

  // ----------------------------------------------------
  // End