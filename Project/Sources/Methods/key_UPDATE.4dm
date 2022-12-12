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
var $isSet; $isLocked : Boolean
var $goUp; $bottom; $number; $height; $i; $left : Integer
var $optimalHeight; $optimalWidth; $ref; $right; $sublist : Integer
var $top; $width; $indx; $pos : Integer
var $Ptr_column_1; $Ptr_column_2; $Ptr_column_3 : Pointer
var $node; $t; $name; $os; $databaseFolderPathname; $t : Text
var $type; $node; $xpath : Text
var $notSet : Picture

// ----------------------------------------------------
GET LIST ITEM:C378(Form:C1466.buildApp; *; $ref; $name)

OBJECT SET VISIBLE:C603(*; "element.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "button.array.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "os.@"; False:C215)
OBJECT SET VISIBLE:C603(*; "lock"; False:C215)
OBJECT SET VISIBLE:C603(*; "alert"; False:C215)

GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "xpath"; $xpath)
$t:=Get localized string:C991($xpath)
$t:=Length:C16($t)>0 ? $t : Get localized string:C991($name)

OBJECT SET VALUE:C1742("help"; $t)
OBJECT SET VALUE:C1742("help1"; $t)

OBJECT GET COORDINATES:C663(*; "help1"; $left; $top; $right; $bottom)
$width:=$right-$left
$height:=$bottom-$top
OBJECT GET BEST SIZE:C717(*; "help1"; $optimalWidth; $optimalHeight; $width)
OBJECT SET VISIBLE:C603(*; "help1"; $optimalHeight<=$height)
OBJECT SET VISIBLE:C603(*; "help"; $optimalHeight>$height)

//%W-518.5
If ($sublist=0)\
 & ($ref>0)
	
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "type"; $type)
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "os"; $os)
	GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "dom"; $node)
	
	$isSet:=(Length:C16($node)>0)
	$isLocked:=(($os#Choose:C955(Is macOS:C1572; "mac"; "win")) & (Length:C16($os)>0))
	
	If (FORM Event:C1606.code=On Clicked:K2:4)\
		 & ((Macintosh option down:C545 | Windows Alt down:C563) & $isSet)
		
		CONFIRM:C162(Get localized string:C991("AreYouSureYouWantToClearThisKey?"); Get localized string:C991("CommonDelete"))
		
		If (OK=1)
			
			DOM REMOVE XML ELEMENT:C869($node)
			SET LIST ITEM PARAMETER:C986(Form:C1466.buildApp; *; "dom"; "")
			Form:C1466.modified:=True:C214
			
			SET LIST ITEM ICON:C950(Form:C1466.buildApp; Selected list items:C379(Form:C1466.buildApp; *); $notSet)
			
		End if 
		
		Form:C1466.action:=-5
		Form:C1466.refresh()
		
	Else 
		
		OBJECT SET VISIBLE:C603(*; "element.value.label"; True:C214)
		
		$indx:=Position:C15("."; $type)
		
		If ($indx>0)
			
			OBJECT SET VISIBLE:C603(*; "element.@"+Substring:C12($type; 1; $indx-1)+"@"; True:C214)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "element.@"+$type+"@"; Length:C16($type)>0)
			
		End if 
		
		Case of 
				
				//…………………………………………
			: ($type="alpha@")
				
				$t:=Get localized string:C991(Replace string:C233($type; "alpha."; ""))
				
				If (Length:C16($t)=0)
					
					OBJECT SET VALUE:C1742("element.value.label"; Replace string:C233($type; "alpha."; ""))
					
				Else 
					
					OBJECT SET VALUE:C1742("element.value.label"; $t)
					
				End if 
				
				//FIXME:Remove interprocess
				If ($isSet)
					
					DOM GET XML ELEMENT VALUE:C731($node; <>Txt_value)
					
				Else 
					
					<>Txt_value:=""
					
				End if 
				
				//…………………………………………
			: ($type="boolean@")
				
				OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991(Replace string:C233($type; "boolean."; "")))
				
				If ($isSet)
					
					DOM GET XML ELEMENT VALUE:C731($node; $t)
					
				End if 
				
				$indx:=$t="True" ? 1 : 0
				
				OBJECT SET VALUE:C1742("element.boolean.1"; $indx)
				OBJECT SET VALUE:C1742("element.boolean.2"; 1-$indx)
				
				//…………………………………………
			: ($type="path.@")
				
				If ($isSet)
					
					DOM GET XML ELEMENT VALUE:C731($node; <>Txt_value)
					
				Else 
					
					<>Txt_value:=""
					
				End if 
				
				If ($isLocked)
					
					OBJECT SET VISIBLE:C603(*; "element.unlock.path@"; False:C215)
					
				Else 
					
					OBJECT SET VISIBLE:C603(*; "element.lock.path@"; False:C215)
					
					If (<>Txt_value="::") | (<>Txt_value="..\\")
						
						<>Txt_value:=Path to object:C1547(Storage:C1525.environment.databaseFolder).parentFolder
						
					Else 
						
						If (_o_doc_Is_Relative_Path(<>Txt_value))
							
							//Get the absolute path
							$databaseFolderPathname:=Storage:C1525.environment.databaseFolder
							
							For ($i; 1; Length:C16(<>Txt_value); 1)
								
								If (Position:C15(<>Txt_value[[$i]]; Choose:C955(Is macOS:C1572; ":"; ".\\"))#0)
									
									$goUp:=$i
									
								Else 
									
									break
									
								End if 
							End for 
							
							If ($goUp>0)
								
								If (Is Windows:C1573)
									
									$goUp:=$goUp-1
									
								End if 
							End if 
							
							For ($i; 1; $goUp; 1)
								
								Repeat 
									
									$indx:=Position:C15(Folder separator:K24:12; $databaseFolderPathname; $pos+1)
									
									If ($indx>0)
										
										$pos:=$indx
										
									End if 
								Until ($indx=0)
								
								$databaseFolderPathname:=Substring:C12($databaseFolderPathname; 1; $pos-1)
								
							End for 
							
							<>Txt_value:=Delete string:C232(<>Txt_value; 1; $goUp-Num:C11(Is macOS:C1572))
							<>Txt_value:=$databaseFolderPathname+<>Txt_value
							
							
						End if 
					End if 
					
					_o_doc_OBJET_LOCATION(<>Txt_value; "element.unlock.path.Button"; On Load:K2:1; -1)
					
					Case of 
							
							//__________________________
						: (Not:C34($isSet))
							
							//__________________________
						: (Test path name:C476(<>Txt_value)=Is a document:K24:1)
							
							//__________________________
						: (Test path name:C476(<>Txt_value)=Is a folder:K24:2)
							
							//__________________________
						Else 
							
							BEEP:C151
							OBJECT SET VISIBLE:C603(*; "Alert"; True:C214)
							
							//__________________________
					End case 
				End if 
				
				OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991($type="@.folder@" ? "folder" : "file"))
				
				$type:=Replace string:C233($type; ".folder"; "")
				$indx:=Position:C15(".file"; $type)
				
				If ($indx>0)
					
					$type:=Substring:C12($type; 1; $indx-1)
					
				End if 
				
				//…………………………………………
			: ($type="array")
				
				OBJECT SET VISIBLE:C603(*; "element."+$type+"@"; True:C214)
				OBJECT SET VISIBLE:C603(*; "element.value.label"; True:C214)
				
				OBJECT SET VISIBLE:C603(*; "C1"; True:C214)
				OBJECT SET VISIBLE:C603(*; "C2"; True:C214)
				OBJECT SET VISIBLE:C603(*; "C3"; True:C214)
				
				$Ptr_column_1:=OBJECT Get pointer:C1124(Object named:K67:5; "C1")
				$Ptr_column_2:=OBJECT Get pointer:C1124(Object named:K67:5; "C2")
				$Ptr_column_3:=OBJECT Get pointer:C1124(Object named:K67:5; "C3")
				
				ARRAY TEXT:C222($Ptr_column_1->; 0x0000)
				ARRAY LONGINT:C221($Ptr_column_2->; 0x0000)
				ARRAY BOOLEAN:C223($Ptr_column_3->; 0x0000)
				
				If ($isSet)
					
					//Get the number elements of the array. Then the elements if any {
					GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "xpath"; $t)
					
					If (Length:C16($t)>0)
						
						$node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp; $t+"/ItemsCount")
						
						If (OK=1)
							
							DOM GET XML ELEMENT VALUE:C731($node; $indx)
							
						End if 
						
						ARRAY TEXT:C222($tTxt_values; $indx)
						
						For ($i; 1; $indx; 1)
							
							$node:=DOM Find XML element:C864(Storage:C1525.environment.domBuildApp; $t+"/Item"+String:C10($i))
							
							If (OK=1)
								
								DOM GET XML ELEMENT VALUE:C731($node; $tTxt_values{$i})
								
							End if 
						End for 
					End if 
					//}
					
				Else 
					
					ARRAY TEXT:C222($tTxt_values; 0x0000)
					
				End if 
				
				//Get the type of the elements of the array and construct an appropriate listbox {
				GET LIST ITEM PARAMETER:C985(Form:C1466.buildApp; *; "arraytype"; $type)
				
				Case of 
						
						//+++++++++++++++++++++++++++++++++++++++
					: ($type="plugin.@")
						
						//Get the plugin list {
						PLUGIN LIST:C847($Ptr_column_2->; $Ptr_column_1->)
						
						For ($i; Size of array:C274($Ptr_column_1->); 1; -1)
							
							Case of 
									
									//…………………………………………
								: ($Ptr_column_1->{$i}="4D Internet Commands")
									
									$Ptr_column_2->{$i}:=15010
									
									//…………………………………………
								: ($Ptr_column_1->{$i}="4D@Pack")
									
									$Ptr_column_2->{$i}:=11999
									
									//…………………………………………
								: ($Ptr_column_2->{$i}=808464432)
									
									DELETE FROM ARRAY:C228($Ptr_column_1->; $i; 1)
									DELETE FROM ARRAY:C228($Ptr_column_2->; $i; 1)
									
									//…………………………………………
								: ($Ptr_column_2->{$i}=4D View license:K44:4)
									
									$Ptr_column_2->{$i}:=13000
									
									//…………………………………………
								: ($Ptr_column_2->{$i}=4D Write license:K44:2)
									
									$Ptr_column_2->{$i}:=12000
									
									//…………………………………………
								: ($Ptr_column_2->{$i}=4D ODBC Pro license:K44:9)
									
									$Ptr_column_2->{$i}:=13500
									
									//…………………………………………
							End case 
						End for 
						//}
						
						$number:=Size of array:C274($Ptr_column_1->)
						ARRAY BOOLEAN:C223($Ptr_column_3->; $number)
						
						If ($number>0)
							
							If ($type="@.name")
								
								For ($i; 1; $number; 1)
									
									$Ptr_column_3->{$i}:=(Find in array:C230($tTxt_values; $Ptr_column_1->{$i})=-1)
									
								End for 
								
								OBJECT SET VISIBLE:C603(*; "C2"; False:C215)
								
							Else 
								
								For ($i; 1; $number; 1)
									
									$Ptr_column_3->{$i}:=(Find in array:C230($tTxt_values; String:C10($Ptr_column_2->{$i}))=-1)
									
								End for 
								
								OBJECT SET VISIBLE:C603(*; "C1"; False:C215)
								
							End if 
							
							OBJECT SET VISIBLE:C603(*; "C3"; True:C214)
							
							OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991("plugin"))
							
						Else 
							
							OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991("no-plugin"))
							OBJECT SET VISIBLE:C603(*; "element.array"; False:C215)
							
						End if 
						
						//+++++++++++++++++++++++++++++++++++++++
					: ($type="component")
						
						COMPONENT LIST:C1001($Ptr_column_1->)
						
						$number:=Size of array:C274($Ptr_column_1->)
						
						If ($number>0)
							
							ARRAY BOOLEAN:C223($Ptr_column_3->; $number)
							
							For ($i; 1; $number; 1)
								
								$Ptr_column_3->{$i}:=(Find in array:C230($tTxt_values; $Ptr_column_1->{$i})=-1)
								
							End for 
							
							OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991("component"))
							
							ARRAY LONGINT:C221($Ptr_column_2->; $number)
							OBJECT SET VISIBLE:C603(*; "C2"; False:C215)
							
						Else 
							
							OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991("no-component"))
							OBJECT SET VISIBLE:C603(*; "element.array"; False:C215)
							
						End if 
						
						//+++++++++++++++++++++++++++++++++++++++
					: ($type="path.@")  //Licences...
						
						If (Asserted:C1132($type="path.file.license4D"))
							
							//%W-518.1
							COPY ARRAY:C226($tTxt_values; $Ptr_column_1->)
							//%W+518.1
							
							$number:=Size of array:C274($Ptr_column_1->)
							
							OBJECT SET VALUE:C1742("element.value.label"; Get localized string:C991("licences"))
							
						End if 
						
						ARRAY BOOLEAN:C223($Ptr_column_3->; $number)
						ARRAY LONGINT:C221($Ptr_column_2->; $number)
						OBJECT SET VISIBLE:C603(*; "C2"; False:C215)
						OBJECT SET VISIBLE:C603(*; "C3"; False:C215)
						
						OBJECT SET VISIBLE:C603(*; "button.array.@"; True:C214)
						
						OBJECT SET VISIBLE:C603(*; "button.array.add@"; Not:C34($isLocked))
						OBJECT SET VISIBLE:C603(*; "button.array.delete@"; $Ptr_column_1->>0)
						
						//+++++++++++++++++++++++++++++++++++++++
					Else 
						
						TRACE:C157
						
						//+++++++++++++++++++++++++++++++++++++++
				End case   //}
				
				OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "element.array"; Align left:K42:2)
				LISTBOX SELECT ROW:C912(*; "element.array"; 0; lk remove from selection:K53:3)
				
				//…………………………………………
		End case 
	End if 
	
	If (Length:C16($type)#0)
		
		If (Length:C16($os)>0)
			
			OBJECT SET VISIBLE:C603(*; "os."+$os+".alone@"; True:C214)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "os.@.all"; True:C214)
			
		End if 
		
		OBJECT SET VISIBLE:C603(*; "lock"; $isLocked)
		
	End if 
	
End if 
//%W+518.5