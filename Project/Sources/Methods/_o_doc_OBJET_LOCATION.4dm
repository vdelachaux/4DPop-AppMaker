//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : doc_OBJET_LOCATION
// Created 01/02/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)
C_LONGINT:C283($4)

C_LONGINT:C283($Lon_bottom; $Lon_dep_H; $Lon_formEvent; $Lon_Height; $Lon_i; $Lon_left)
C_LONGINT:C283($Lon_maxWidth; $Lon_Position; $Lon_Redim_H; $Lon_right; $Lon_Size; $Lon_top)
C_LONGINT:C283($Lon_Width; $Lon_x)
C_TEXT:C284($Mnu_pop; $Txt_Buffer; $Txt_File; $Txt_FullPath; $Txt_object; $Txt_Path)
C_TEXT:C284($Txt_Volume)

ARRAY TEXT:C222($tTxt_Volumes; 0)

If (False:C215)
	C_TEXT:C284(_o_doc_OBJET_LOCATION; $1)
	C_TEXT:C284(_o_doc_OBJET_LOCATION; $2)
	C_LONGINT:C283(_o_doc_OBJET_LOCATION; $3)
	C_LONGINT:C283(_o_doc_OBJET_LOCATION; $4)
End if 

$Txt_FullPath:=$1
$Txt_object:=$2

If (Count parameters:C259>=3)
	
	$Lon_formEvent:=$3
	
	If (Count parameters:C259>=4)
		
		$Lon_Position:=$4
		
	Else 
		
		$Lon_Position:=Align left:K42:2
		
	End if 
	
Else 
	
	$Lon_Position:=Align left:K42:2
	
End if 

$Lon_formEvent:=Choose:C955($Lon_formEvent=0; Form event code:C388; $Lon_formEvent)

$Lon_Size:=Length:C16($Txt_FullPath)

Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		If ($Lon_Size>0)
			
			$Txt_Volume:=Replace string:C233(_o_doc_getVolumeName($Txt_FullPath); Folder separator:K24:12; "")
			$Txt_File:=Replace string:C233(Path to object:C1547($Txt_FullPath).name; Folder separator:K24:12; "")
			
			If ($Txt_File#$Txt_Volume)
				
				$Txt_Buffer:=Replace string:C233(Get localized string:C991("FileInVolume"); "{file}"; $Txt_File)
				$Txt_Buffer:=Replace string:C233($Txt_Buffer; "{volume}"; $Txt_Volume)
				
			Else 
				
				$Txt_Buffer:="\""+$Txt_File+"\""
				
			End if 
			
		Else 
			
			$Txt_Buffer:=" "
			
		End if 
		
		OBJECT SET TITLE:C194(*; $Txt_object; $Txt_Buffer)
		
		OBJECT GET COORDINATES:C663(*; $Txt_object; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
		$Lon_maxWidth:=$Lon_right-$Lon_left
		OBJECT GET BEST SIZE:C717(*; $Txt_object; $Lon_Width; $Lon_Height; $Lon_maxWidth)
		
		If ($Lon_Position#-1)
			
			OBJECT GET COORDINATES:C663(*; $Txt_object; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
			$Lon_maxWidth:=$Lon_right-$Lon_left
			OBJECT GET BEST SIZE:C717(*; $Txt_object; $Lon_Width; $Lon_Height; $Lon_maxWidth)
			
			If ($Lon_Width<$Lon_maxWidth)
				
				OBJECT GET COORDINATES:C663(*; $Txt_object; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
				
				Case of 
						
						//______________________________________________________
					: ($Lon_Position=0)\
						 | ($Lon_Position=Align left:K42:2)
						
						$Lon_dep_H:=0
						$Lon_Redim_H:=$Lon_Width-$Lon_maxWidth
						
						//______________________________________________________
					: ($Lon_Position=Align center:K42:3)
						
						$Lon_dep_H:=(($Lon_maxWidth-$Lon_Width)\2)-4
						$Lon_Redim_H:=-$Lon_dep_H*2
						
						//______________________________________________________
					: ($Lon_Position=Align right:K42:4)
						
						$Lon_dep_H:=$Lon_maxWidth-$Lon_Width
						$Lon_Redim_H:=-$Lon_dep_H
						
						//______________________________________________________
					Else 
						
						$Lon_dep_H:=0
						$Lon_Redim_H:=$Lon_Width-$Lon_maxWidth
						
						//______________________________________________________
				End case 
				
				OBJECT MOVE:C664(*; $Txt_object; $Lon_dep_H; 0; $Lon_Redim_H; 0)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		OBJECT SET BORDER STYLE:C1262(*; $Txt_object; Border Plain:K42:28)
		OBJECT SET FORMAT:C236(*; $Txt_Object; ";;;;;;;;;;1")
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		OBJECT SET BORDER STYLE:C1262(*; $Txt_object; Border None:K42:27)
		OBJECT SET FORMAT:C236(*; $Txt_Object; ";;;;;;;;;;0")
		
		//______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)\
		 | ($Lon_formEvent=On Long Click:K2:37)\
		 | ($Lon_formEvent=On Alternative Click:K2:36)  //display the path in a menu
		
		VOLUME LIST:C471($tTxt_Volumes)
		
		$Mnu_pop:=Create menu:C408
		
		For ($Lon_i; 1; Length:C16($Txt_FullPath); 1)
			
			If ($Txt_FullPath[[$Lon_i]]=Folder separator:K24:12)
				
				If (Is Windows:C1573)
					
					APPEND MENU ITEM:C411($Mnu_pop; $Txt_Buffer)
					
				Else 
					
					INSERT MENU ITEM:C412($Mnu_pop; 0; $Txt_Buffer)
					
				End if 
				
				$Lon_x:=$Lon_x+1
				SET MENU ITEM PARAMETER:C1004($Mnu_pop; -1; String:C10($Lon_x))
				$Txt_Path:=Substring:C12($Txt_FullPath; 1; $Lon_i-1)
				
				Case of 
						
						//______________________________________________________
					: (Find in array:C230($tTxt_Volumes; $Txt_Path)>0)
						
						If (Is Windows:C1573)
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/WIN/genericHardDrive.png")
							
						Else 
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/MAC/genericHardDrive.png")
							
						End if 
						
						//______________________________________________________
					: (Test path name:C476($Txt_Path)=Is a folder:K24:2)
						
						If (Is Windows:C1573)
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/WIN/genericFolder.png")
							
						Else 
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/MAC/genericFolder.png")
							
						End if 
						
						//  `______________________________________________________
						//________________________________________
					: (Test path name:C476($Txt_Path)=Is a document:K24:1)
						
						If (Is Windows:C1573)
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/WIN/genericFile.png")
							
						Else 
							
							SET MENU ITEM ICON:C984($Mnu_pop; -1; "#images/MAC/genericFile.png")
							
						End if 
						
						//______________________________________________________
				End case 
				
				$Txt_Path:=Substring:C12($Txt_FullPath; 1; $Lon_i)
				SET MENU ITEM PARAMETER:C1004($Mnu_pop; -1; $Txt_Path)
				$Txt_Buffer:=""
				
			Else 
				
				$Txt_Buffer:=$Txt_Buffer+$Txt_FullPath[[$Lon_i]]
				
			End if 
		End for 
		
		If (Length:C16($Txt_Buffer)>0)
			
			If (Is Windows:C1573)
				
				APPEND MENU ITEM:C411($Mnu_pop; $Txt_Buffer)
				
			Else 
				
				INSERT MENU ITEM:C412($Mnu_pop; 0; $Txt_Buffer)
				
			End if 
			
			$Lon_x:=$Lon_x+1
			SET MENU ITEM PARAMETER:C1004($Mnu_pop; -1; String:C10($Lon_x))
			
			SET MENU ITEM ICON:C984($Mnu_pop; -1; \
				"#images/"\
				+Choose:C955(Is Windows:C1573; "WIN"; "MAC")\
				+"/genericFile.png")
			
		End if 
		
		If (Count menu items:C405($Mnu_pop)>0)
			
			APPEND MENU ITEM:C411($Mnu_pop; "-")
			APPEND MENU ITEM:C411($Mnu_pop; Get localized string:C991("CopyPath"))
			SET MENU ITEM PARAMETER:C1004($Mnu_pop; -1; "copy")
			$Txt_Path:=Dynamic pop up menu:C1006($Mnu_pop)
			
			Case of 
					
					//………………………
				: ($Txt_Path="")
					
					//………………………
				: ($Txt_Path="copy")
					
					SET TEXT TO PASTEBOARD:C523($Txt_FullPath)
					
					//………………………
				Else 
					
					SHOW ON DISK:C922($Txt_Path)
					
					//………………………
			End case 
		End if 
		
		RELEASE MENU:C978($Mnu_pop)
		
		//______________________________________________________
End case 